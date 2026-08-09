from rest_framework import serializers
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer
from .models import User, Institute, SubscriptionPlan

class SubscriptionPlanSerializer(serializers.ModelSerializer):
    class Meta:
        model = SubscriptionPlan
        fields = '__all__'

class InstituteSerializer(serializers.ModelSerializer):
    plan = SubscriptionPlanSerializer(read_only=True)

    class Meta:
        model = Institute
        fields = [
            'id', 'name', 'code', 'logo_url', 'address', 'website',
            'contact_email', 'contact_phone', 'domain', 'primary_color',
            'accent_color', 'academic_year', 'working_days', 'time_zone',
            'plan', 'subscription_status', 'created_at', 'updated_at'
        ]

class UserSerializer(serializers.ModelSerializer):
    institute = InstituteSerializer(read_only=True)

    class Meta:
        model = User
        fields = ['id', 'email', 'phone_number', 'role', 'first_name', 'last_name', 'profile_picture', 'is_active', 'institute']
        read_only_fields = ['id', 'is_active']

class RegisterSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True, min_length=6)
    institute_code = serializers.CharField(write_only=True, required=False)

    class Meta:
        model = User
        fields = ['email', 'password', 'first_name', 'last_name', 'phone_number', 'role', 'institute_code']

    def create(self, validated_data):
        institute_code = validated_data.pop('institute_code', None)
        password = validated_data.pop('password')

        institute = None
        if institute_code:
            try:
                institute = Institute.objects.get(code__iexact=institute_code)
            except Institute.DoesNotExist:
                pass

        user = User.objects.create(institute=institute, **validated_data)
        user.set_password(password)
        user.save()
        return user

class RegisterInstituteSerializer(serializers.Serializer):
    institute_name = serializers.CharField(max_length=150)
    logo_url = serializers.URLField(required=False, allow_blank=True)
    address = serializers.CharField(required=False, allow_blank=True)
    website = serializers.URLField(required=False, allow_blank=True)
    contact_email = serializers.EmailField()
    contact_phone = serializers.CharField(max_length=20, required=False, allow_blank=True)
    tier = serializers.ChoiceField(choices=SubscriptionPlan.Tier.choices, default=SubscriptionPlan.Tier.FREE_TRIAL)
    
    admin_email = serializers.EmailField()
    admin_password = serializers.CharField(min_length=6, write_only=True)
    admin_first_name = serializers.CharField(max_length=50)
    admin_last_name = serializers.CharField(max_length=50, required=False, allow_blank=True)
    admin_phone = serializers.CharField(max_length=20, required=False, allow_blank=True)

    def create(self, validated_data):
        name = validated_data['institute_name']
        import re
        code_base = re.sub(r'[^A-Z0-9]', '', name.upper())[:6] or "SMEC"
        code = code_base
        count = 1
        while Institute.objects.filter(code=code).exists():
            code = f"{code_base}{count}"
            count += 1

        plan, _ = SubscriptionPlan.objects.get_or_create(
            tier=validated_data.get('tier', SubscriptionPlan.Tier.FREE_TRIAL),
            defaults={'name': f"{validated_data.get('tier', 'FREE_TRIAL').title()} Plan"}
        )

        institute = Institute.objects.create(
            name=name,
            code=code,
            logo_url=validated_data.get('logo_url', ''),
            address=validated_data.get('address', ''),
            website=validated_data.get('website', ''),
            contact_email=validated_data.get('contact_email'),
            contact_phone=validated_data.get('contact_phone', ''),
            plan=plan,
            subscription_status=Institute.SubscriptionStatus.TRIAL
        )

        admin_user = User.objects.create(
            email=validated_data['admin_email'],
            first_name=validated_data['admin_first_name'],
            last_name=validated_data.get('admin_last_name', ''),
            phone_number=validated_data.get('admin_phone', ''),
            role=User.Role.ADMIN,
            institute=institute,
            is_staff=True
        )
        admin_user.set_password(validated_data['admin_password'])
        admin_user.save()

        return {'institute': institute, 'admin_user': admin_user}

class CustomTokenObtainPairSerializer(TokenObtainPairSerializer):
    @classmethod
    def get_token(cls, user):
        token = super().get_token(user)
        token['email'] = user.email
        token['role'] = user.role
        token['full_name'] = f"{user.first_name} {user.last_name}".strip()

        if user.institute:
            token['institute_id'] = user.institute.id
            token['institute_code'] = user.institute.code
            token['institute_name'] = user.institute.name
            token['primary_color'] = user.institute.primary_color
            token['accent_color'] = user.institute.accent_color
            token['subscription_status'] = user.institute.subscription_status
        else:
            token['institute_id'] = None
            token['institute_code'] = 'GLOBAL'
            token['institute_name'] = 'Global Super Admin'
            token['primary_color'] = '#1E40AF'
            token['accent_color'] = '#06B6D4'
            token['subscription_status'] = 'ACTIVE'

        return token

    def validate(self, attrs):
        data = super().validate(attrs)
        data['user'] = UserSerializer(self.user).data
        return data

