from rest_framework import generics, permissions
from .models import AuditLog
from .serializers import AuditLogSerializer

class AuditLogListView(generics.ListAPIView):
    serializer_class = AuditLogSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        user = self.request.user
        if user.role == 'SUPER_ADMIN':
            return AuditLog.objects.all().order_by('-timestamp')
        if user.role == 'ADMIN':
            return AuditLog.objects.filter(institute=user.institute).order_by('-timestamp')
        return AuditLog.objects.none()
