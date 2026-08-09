from django.db import models
from django.contrib.auth.models import AbstractUser, BaseUserManager

class SubscriptionPlan(models.Model):
    class Tier(models.TextChoices):
        FREE_TRIAL = 'FREE_TRIAL', 'Free Trial'
        BASIC = 'BASIC', 'Basic Plan'
        PROFESSIONAL = 'PROFESSIONAL', 'Professional Plan'
        ENTERPRISE = 'ENTERPRISE', 'Enterprise Plan'

    name = models.CharField(max_length=100)
    tier = models.CharField(max_length=20, choices=Tier.choices, unique=True, default=Tier.FREE_TRIAL)
    price_per_month = models.DecimalField(max_digits=10, decimal_places=2, default=0.00)
    max_students = models.IntegerField(default=50)
    max_staff = models.IntegerField(default=10)
    ai_credits_monthly = models.IntegerField(default=100)
    features = models.JSONField(default=dict, blank=True)

    def __str__(self):
        return f"{self.name} ({self.get_tier_display()})"

class Institute(models.Model):
    class SubscriptionStatus(models.TextChoices):
        ACTIVE = 'ACTIVE', 'Active'
        TRIAL = 'TRIAL', 'Trial'
        SUSPENDED = 'SUSPENDED', 'Suspended'
        EXPIRED = 'EXPIRED', 'Expired'

    name = models.CharField(max_length=150)
    code = models.CharField(max_length=20, unique=True) # e.g. SMEC, APEX, MIT
    logo_url = models.URLField(blank=True, null=True)
    address = models.TextField(blank=True, null=True)
    website = models.URLField(blank=True, null=True)
    contact_email = models.EmailField(blank=True, null=True)
    contact_phone = models.CharField(max_length=20, blank=True, null=True)
    domain = models.CharField(max_length=100, blank=True, null=True)
    
    primary_color = models.CharField(max_length=10, default='#1E40AF') # Deep Blue
    accent_color = models.CharField(max_length=10, default='#06B6D4') # Cyber Cyan
    
    latitude = models.FloatField(default=9.9312) # Default Kochi Campus Lat
    longitude = models.FloatField(default=76.2673) # Default Kochi Campus Lon
    geofence_radius_meters = models.FloatField(default=150.0) # Geofence radius in meters
    
    academic_year = models.CharField(max_length=20, default='2026-2027')
    working_days = models.JSONField(default=list, blank=True) # e.g. ["Mon", "Tue", "Wed", "Thu", "Fri"]
    time_zone = models.CharField(max_length=50, default='UTC')
    
    plan = models.ForeignKey(SubscriptionPlan, on_delete=models.SET_NULL, null=True, blank=True)
    subscription_status = models.CharField(
        max_length=20,
        choices=SubscriptionStatus.choices,
        default=SubscriptionStatus.TRIAL
    )
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"{self.name} ({self.code})"

class UserManager(BaseUserManager):
    def create_user(self, email, password=None, **extra_fields):
        if not email:
            raise ValueError('Email address is required')
        email = self.normalize_email(email)
        user = self.model(email=email, **extra_fields)
        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_superuser(self, email, password=None, **extra_fields):
        extra_fields.setdefault('is_staff', True)
        extra_fields.setdefault('is_superuser', True)
        extra_fields.setdefault('role', User.Role.SUPER_ADMIN)
        return self.create_user(email, password, **extra_fields)

class User(AbstractUser):
    class Role(models.TextChoices):
        SUPER_ADMIN = 'SUPER_ADMIN', 'Platform Super Admin'
        ADMIN = 'ADMIN', 'Institute Admin'
        TRAINER = 'TRAINER', 'Staff / Trainer'
        STUDENT = 'STUDENT', 'Student'
        PARENT = 'PARENT', 'Parent'
        RECEPTION_HR = 'RECEPTION_HR', 'Reception / HR'

    username = None
    email = models.EmailField(unique=True)
    institute = models.ForeignKey(Institute, on_delete=models.CASCADE, null=True, blank=True, related_name='users')
    phone_number = models.CharField(max_length=20, blank=True, null=True)
    role = models.CharField(max_length=20, choices=Role.choices, default=Role.STUDENT)
    profile_picture = models.ImageField(upload_to='profiles/', blank=True, null=True)
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = []

    objects = UserManager()

    def __str__(self):
        inst = self.institute.code if self.institute else "GLOBAL"
        return f"[{inst}] {self.email} ({self.get_role_display()})"

from django.utils import timezone
from datetime import timedelta

class EmailOTP(models.Model):
    email_or_phone = models.CharField(max_length=150, db_index=True)
    otp_code = models.CharField(max_length=6)
    created_at = models.DateTimeField(auto_now_add=True)
    expires_at = models.DateTimeField()
    is_verified = models.BooleanField(default=False)

    def is_valid(self):
        return not self.is_verified and timezone.now() <= self.expires_at

    def __str__(self):
        return f"OTP for {self.email_or_phone}: {self.otp_code} (Valid: {self.is_valid()})"


