from rest_framework import generics, permissions, status
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework_simplejwt.views import TokenObtainPairView
from rest_framework_simplejwt.tokens import RefreshToken

from .models import User, Institute, SubscriptionPlan
from .serializers import (
    UserSerializer, RegisterSerializer, CustomTokenObtainPairSerializer,
    InstituteSerializer, RegisterInstituteSerializer, SubscriptionPlanSerializer
)

class CustomTokenObtainPairView(TokenObtainPairView):
    serializer_class = CustomTokenObtainPairSerializer

class RegisterView(generics.CreateAPIView):
    queryset = User.objects.all()
    serializer_class = RegisterSerializer
    permission_classes = [permissions.AllowAny]

class RegisterInstituteView(APIView):
    permission_classes = [permissions.AllowAny]

    def post(self, request):
        serializer = RegisterInstituteSerializer(data=request.data)
        if serializer.is_valid():
            res = serializer.save()
            institute = res['institute']
            admin_user = res['admin_user']

            # Generate token for immediate auto-login
            refresh = CustomTokenObtainPairSerializer.get_token(admin_user)
            return Response({
                'message': 'Institute onboarded successfully!',
                'institute': InstituteSerializer(institute).data,
                'user': UserSerializer(admin_user).data,
                'tokens': {
                    'refresh': str(refresh),
                    'access': str(refresh.access_token),
                }
            }, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class UserProfileView(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def get(self, request):
        serializer = UserSerializer(request.user)
        return Response(serializer.data)

    def patch(self, request):
        serializer = UserSerializer(request.user, data=request.data, partial=True)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class InstituteConfigView(APIView):
    permission_classes = [permissions.AllowAny]

    def get(self, request):
        code = request.query_params.get('code')
        if not code:
            return Response({'detail': 'Institute code is required'}, status=status.HTTP_400_BAD_REQUEST)

        try:
            institute = Institute.objects.get(code__iexact=code)
            return Response(InstituteSerializer(institute).data)
        except Institute.DoesNotExist:
            return Response({'detail': f'Institute with code "{code}" not found'}, status=status.HTTP_404_NOT_FOUND)

class ListUsersView(generics.ListAPIView):
    serializer_class = UserSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        user = self.request.user
        queryset = User.objects.all()
        if user.role != 'SUPER_ADMIN':
            queryset = queryset.filter(institute=user.institute)

        role = self.request.query_params.get('role')
        if role:
            queryset = queryset.filter(role=role)
        return queryset

# Mobile OTP & Password Recovery
class RequestOTPView(APIView):
    permission_classes = [permissions.AllowAny]

    def post(self, request):
        phone_or_email = request.data.get('phone_or_email')
        if not phone_or_email:
            return Response({'detail': 'Phone number or email is required'}, status=status.HTTP_400_BAD_REQUEST)
        # Mock OTP generation for demonstration/testing
        return Response({
            'message': 'OTP sent successfully',
            'otp_code': '123456', # Demo fixed OTP
            'target': phone_or_email
        })

class VerifyOTPView(APIView):
    permission_classes = [permissions.AllowAny]

    def post(self, request):
        phone_or_email = request.data.get('phone_or_email')
        otp = request.data.get('otp')
        if otp != '123456':
            return Response({'detail': 'Invalid OTP code'}, status=status.HTTP_400_BAD_REQUEST)
        
        user = User.objects.filter(email=phone_or_email).first() or User.objects.filter(phone_number=phone_or_email).first()
        if not user:
            return Response({'detail': 'No account associated with this detail'}, status=status.HTTP_404_NOT_FOUND)

        refresh = CustomTokenObtainPairSerializer.get_token(user)
        return Response({
            'message': 'OTP verified successfully',
            'user': UserSerializer(user).data,
            'tokens': {
                'refresh': str(refresh),
                'access': str(refresh.access_token)
            }
        })

class ForgotPasswordView(APIView):
    permission_classes = [permissions.AllowAny]

    def post(self, request):
        email = request.data.get('email')
        user = User.objects.filter(email=email).first()
        if user:
            return Response({'message': 'Reset code sent to email', 'otp': '654321'})
        return Response({'detail': 'Email not registered'}, status=status.HTTP_404_NOT_FOUND)

class ResetPasswordView(APIView):
    permission_classes = [permissions.AllowAny]

    def post(self, request):
        email = request.data.get('email')
        otp = request.data.get('otp')
        new_password = request.data.get('new_password')
        if otp != '654321':
            return Response({'detail': 'Invalid OTP'}, status=status.HTTP_400_BAD_REQUEST)
        
        user = User.objects.filter(email=email).first()
        if not user:
            return Response({'detail': 'User not found'}, status=status.HTTP_404_NOT_FOUND)

        user.set_password(new_password)
        user.save()
        return Response({'message': 'Password reset successful'})

# Super Admin Platform Views
class SuperAdminDashboardMetricsView(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def get(self, request):
        if request.user.role != User.Role.SUPER_ADMIN:
            return Response({'detail': 'Permission denied. Super Admin access required.'}, status=status.HTTP_403_FORBIDDEN)

        total_institutes = Institute.objects.count()
        total_students = User.objects.filter(role=User.Role.STUDENT).count()
        total_staff = User.objects.filter(role__in=[User.Role.ADMIN, User.Role.TRAINER]).count()
        
        active_institutes = Institute.objects.filter(subscription_status=Institute.SubscriptionStatus.ACTIVE).count()
        trial_institutes = Institute.objects.filter(subscription_status=Institute.SubscriptionStatus.TRIAL).count()

        return Response({
            'total_institutes': total_institutes,
            'active_institutes': active_institutes,
            'trial_institutes': trial_institutes,
            'total_students': total_students,
            'total_staff': total_staff,
            'monthly_revenue_usd': total_institutes * 299.00,
            'total_ai_tokens_consumed': 1425000,
            'system_health': 'OPERATIONAL',
            'support_tickets_open': 3
        })

class SuperAdminInstituteListView(generics.ListCreateAPIView):
    queryset = Institute.objects.all().order_by('-created_at')
    serializer_class = InstituteSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        if self.request.user.role != User.Role.SUPER_ADMIN:
            return Institute.objects.none()
        return super().get_queryset()

import uuid

class OnboardStaffView(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def post(self, request):
        user = request.user
        if user.role not in [User.Role.ADMIN, User.Role.SUPER_ADMIN]:
            return Response({'detail': 'Only Institute Admins can onboard staff.'}, status=status.HTTP_403_FORBIDDEN)

        email = request.data.get('email')
        first_name = request.data.get('first_name')
        last_name = request.data.get('last_name', '')
        password = request.data.get('password', 'staff123')
        role = request.data.get('role', User.Role.TRAINER)
        phone = request.data.get('phone_number', '')
        qualification = request.data.get('qualification', 'Bachelor Degree')
        specialization = request.data.get('specialization', 'General')

        if not email or not first_name:
            return Response({'detail': 'Email and first name are required.'}, status=status.HTTP_400_BAD_REQUEST)

        if User.objects.filter(email=email).exists():
            return Response({'detail': f'User with email {email} already exists.'}, status=status.HTTP_400_BAD_REQUEST)

        staff_user = User.objects.create(
            email=email,
            first_name=first_name,
            last_name=last_name,
            phone_number=phone,
            role=role,
            institute=user.institute,
            is_staff=True
        )
        staff_user.set_password(password)
        staff_user.save()

        if role == User.Role.TRAINER:
            from staff.models import TrainerProfile
            inst_code = user.institute.code if user.institute else 'SMEC'
            emp_id = f"EMP-{inst_code}-{uuid.uuid4().hex[:4].upper()}"
            TrainerProfile.objects.create(
                user=staff_user,
                employee_id=emp_id,
                qualification=qualification,
                specialization=specialization
            )

        return Response({
            'message': f'Staff member {email} onboarded successfully.',
            'user': UserSerializer(staff_user).data
        }, status=status.HTTP_201_CREATED)


class OnboardStudentView(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def post(self, request):
        user = request.user
        if user.role not in [User.Role.ADMIN, User.Role.SUPER_ADMIN, User.Role.TRAINER]:
            return Response({'detail': 'Only Admins or Trainers can onboard students.'}, status=status.HTTP_403_FORBIDDEN)

        email = request.data.get('email')
        first_name = request.data.get('first_name')
        last_name = request.data.get('last_name', '')
        password = request.data.get('password', 'student123')
        phone = request.data.get('phone_number', '')
        course_id = request.data.get('course_id')
        batch_id = request.data.get('batch_id')
        guardian_name = request.data.get('guardian_name', '')
        guardian_contact = request.data.get('guardian_contact', '')

        if not email or not first_name:
            return Response({'detail': 'Email and first name are required.'}, status=status.HTTP_400_BAD_REQUEST)

        if User.objects.filter(email=email).exists():
            return Response({'detail': f'User with email {email} already exists.'}, status=status.HTTP_400_BAD_REQUEST)

        student_user = User.objects.create(
            email=email,
            first_name=first_name,
            last_name=last_name,
            phone_number=phone,
            role=User.Role.STUDENT,
            institute=user.institute
        )
        student_user.set_password(password)
        student_user.save()

        inst_code = user.institute.code if user.institute else 'SMEC'
        roll_num = f"{inst_code}-{uuid.uuid4().hex[:6].upper()}"

        from students.models import StudentProfile
        from courses.models import Course, Batch

        course = Course.objects.filter(id=course_id).first() if course_id else None
        batch = Batch.objects.filter(id=batch_id).first() if batch_id else None

        StudentProfile.objects.create(
            user=student_user,
            roll_number=roll_num,
            course=course,
            batch=batch,
            guardian_name=guardian_name,
            guardian_contact=guardian_contact
        )

        return Response({
            'message': f'Student {email} onboarded successfully.',
            'user': UserSerializer(student_user).data,
            'roll_number': roll_num
        }, status=status.HTTP_201_CREATED)


