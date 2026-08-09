import uuid
from rest_framework import generics, permissions, status
from rest_framework.response import Response
from rest_framework.views import APIView
from accounts.models import User
from accounts.tenant_mixin import TenantScopedQuerySetMixin
from .models import IssuedCertificate
from .serializers import IssuedCertificateSerializer

class IssuedCertificateListView(TenantScopedQuerySetMixin, generics.ListCreateAPIView):
    queryset = IssuedCertificate.objects.all().order_by('-issue_date')
    serializer_class = IssuedCertificateSerializer
    permission_classes = [permissions.IsAuthenticated]

    def perform_create(self, serializer):
        v_code = uuid.uuid4().hex[:12].upper()
        cert_num = f"CERT-{uuid.uuid4().hex[:8].upper()}"
        serializer.save(
            institute=self.request.user.institute,
            verification_code=v_code,
            certificate_number=cert_num
        )

class PublicCertificateVerificationView(APIView):
    permission_classes = [permissions.AllowAny]

    def get(self, request, code):
        try:
            cert = IssuedCertificate.objects.get(verification_code__iexact=code)
        except IssuedCertificate.DoesNotExist:
            return Response({
                'is_valid': False,
                'detail': f'Certificate with verification code "{code}" is NOT valid or does not exist.'
            }, status=status.HTTP_404_NOT_FOUND)

        return Response({
            'is_valid': True,
            'certificate_number': cert.certificate_number,
            'certificate_type': cert.get_certificate_type_display(),
            'student_name': cert.student.get_full_name() or cert.student.email,
            'institute_name': cert.institute.name,
            'institute_code': cert.institute.code,
            'course_name': cert.course.name if cert.course else 'N/A',
            'issue_date': str(cert.issue_date),
            'verification_code': cert.verification_code,
            'status': 'VERIFIED_GENUINE'
        })
