from rest_framework import generics, permissions, status
from rest_framework.response import Response
from rest_framework.views import APIView
from accounts.models import User
from accounts.tenant_mixin import TenantScopedQuerySetMixin
from .models import Company, PlacementDrive, JobApplication
from .serializers import CompanySerializer, PlacementDriveSerializer, JobApplicationSerializer

class PlacementDriveListView(TenantScopedQuerySetMixin, generics.ListCreateAPIView):
    queryset = PlacementDrive.objects.all().order_by('-drive_date')
    serializer_class = PlacementDriveSerializer
    permission_classes = [permissions.IsAuthenticated]

    def perform_create(self, serializer):
        serializer.save(institute=self.request.user.institute)

class ApplyJobDriveView(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def post(self, request, pk):
        try:
            drive = PlacementDrive.objects.get(id=pk)
        except PlacementDrive.DoesNotExist:
            return Response({'detail': 'Placement drive not found'}, status=status.HTTP_404_NOT_FOUND)

        application, created = JobApplication.objects.get_or_create(
            drive=drive,
            student=request.user,
            defaults={'status': JobApplication.ApplicationStatus.APPLIED}
        )

        return Response({
            'message': f'Application successfully submitted for {drive.company.name} ({drive.title}).',
            'application': JobApplicationSerializer(application).data
        }, status=status.HTTP_201_CREATED if created else status.HTTP_200_OK)

class MyJobApplicationsView(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def get(self, request):
        if request.user.role == User.Role.STUDENT:
            applications = JobApplication.objects.filter(student=request.user)
        else:
            applications = JobApplication.objects.filter(drive__institute=request.user.institute)
        return Response(JobApplicationSerializer(applications, many=True).data)
