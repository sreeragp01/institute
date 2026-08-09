from rest_framework import generics, permissions, status
from rest_framework.response import Response
from .models import Enquiry
from .serializers import EnquirySerializer
from accounts.permissions import IsInstituteAdmin, IsTrainer, IsSuperAdmin, IsTenantObject

class EnquiryListCreateView(generics.ListCreateAPIView):
    serializer_class = EnquirySerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        user = self.request.user
        if user.role == 'SUPER_ADMIN':
            return Enquiry.objects.all().order_by('-created_at')
        if not user.institute:
            return Enquiry.objects.none()
        return Enquiry.objects.filter(institute=user.institute).order_by('-created_at')

    def perform_create(self, serializer):
        user = self.request.user
        serializer.save(institute=user.institute)

class EnquiryDetailView(generics.RetrieveUpdateDestroyAPIView):
    serializer_class = EnquirySerializer
    permission_classes = [permissions.IsAuthenticated, IsTenantObject]

    def get_queryset(self):
        user = self.request.user
        if user.role == 'SUPER_ADMIN':
            return Enquiry.objects.all()
        return Enquiry.objects.filter(institute=user.institute)
