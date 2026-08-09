from rest_framework import generics, permissions, status
from rest_framework.response import Response
from rest_framework.views import APIView
from accounts.models import User
from accounts.tenant_mixin import TenantScopedQuerySetMixin
from .models import TrainerProfile, StaffLeaveRequest
from .serializers import TrainerProfileSerializer, StaffLeaveRequestSerializer

class TrainerListView(TenantScopedQuerySetMixin, generics.ListCreateAPIView):
    queryset = TrainerProfile.objects.all()
    serializer_class = TrainerProfileSerializer
    permission_classes = [permissions.IsAuthenticated]

class TrainerDetailView(TenantScopedQuerySetMixin, generics.RetrieveUpdateDestroyAPIView):
    queryset = TrainerProfile.objects.all()
    serializer_class = TrainerProfileSerializer
    permission_classes = [permissions.IsAuthenticated]

class StaffLeaveListCreateView(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def get(self, request):
        if request.user.role == User.Role.TRAINER:
            leaves = StaffLeaveRequest.objects.filter(trainer=request.user)
        else:
            leaves = StaffLeaveRequest.objects.filter(trainer__institute=request.user.institute)
        return Response(StaffLeaveRequestSerializer(leaves, many=True).data)

    def post(self, request):
        serializer = StaffLeaveRequestSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save(trainer=request.user)
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class MyTrainerProfileView(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def get(self, request):
        user = request.user
        try:
            profile = TrainerProfile.objects.get(user=user)
            data = TrainerProfileSerializer(profile).data
        except TrainerProfile.DoesNotExist:
            data = {
                'id': 0,
                'user': {
                    'email': user.email,
                    'first_name': user.first_name,
                    'last_name': user.last_name,
                    'role': user.role
                },
                'employee_id': 'EMP-FAC-1002',
                'department': 'Computer Science & AI',
                'designation': 'Senior Faculty Trainer',
                'active_sessions_count': 3
            }

        return Response(data)
