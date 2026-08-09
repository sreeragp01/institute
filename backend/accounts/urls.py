from django.urls import path
from rest_framework_simplejwt.views import TokenRefreshView
from .views import (
    CustomTokenObtainPairView, RegisterView, RegisterInstituteView, UserProfileView,
    ListUsersView, InstituteConfigView, RequestOTPView, VerifyOTPView,
    ForgotPasswordView, ResetPasswordView, SuperAdminDashboardMetricsView,
    SuperAdminInstituteListView, OnboardStaffView, OnboardStudentView
)

urlpatterns = [
    path('login/', CustomTokenObtainPairView.as_view(), name='auth_login'),
    path('refresh/', TokenRefreshView.as_view(), name='auth_refresh'),
    path('register/', RegisterView.as_view(), name='auth_register'),
    path('register-institute/', RegisterInstituteView.as_view(), name='auth_register_institute'),
    path('me/', UserProfileView.as_view(), name='auth_me'),
    path('institute-config/', InstituteConfigView.as_view(), name='institute_config'),
    path('users/', ListUsersView.as_view(), name='user_list'),
    path('onboard-staff/', OnboardStaffView.as_view(), name='onboard_staff'),
    path('onboard-student/', OnboardStudentView.as_view(), name='onboard_student'),
    
    # OTP & Reset
    path('request-otp/', RequestOTPView.as_view(), name='request_otp'),
    path('verify-otp/', VerifyOTPView.as_view(), name='verify_otp'),
    path('forgot-password/', ForgotPasswordView.as_view(), name='forgot_password'),
    path('reset-password/', ResetPasswordView.as_view(), name='reset_password'),

    # Super Admin Platform APIs
    path('super-admin/metrics/', SuperAdminDashboardMetricsView.as_view(), name='super_admin_metrics'),
    path('super-admin/institutes/', SuperAdminInstituteListView.as_view(), name='super_admin_institutes'),
]

