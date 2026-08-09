from django.urls import path
from .views import AttendanceSummaryView, CreateQRSessionView, ScanQRView, GPSAttendanceView, BiometricSyncView

urlpatterns = [
    path('summary/', AttendanceSummaryView.as_view(), name='attendance_summary'),
    path('qr-session/', CreateQRSessionView.as_view(), name='create_qr_session'),
    path('scan-qr/', ScanQRView.as_view(), name='scan_qr'),
    path('gps-mark/', GPSAttendanceView.as_view(), name='gps_attendance'),
    path('biometric-sync/', BiometricSyncView.as_view(), name='biometric_sync'),
]

