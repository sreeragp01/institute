from rest_framework import generics, permissions
from accounts.tenant_mixin import TenantScopedQuerySetMixin
from .models import Course, Batch, Timetable
from .serializers import CourseSerializer, BatchSerializer, TimetableSerializer

class CourseListView(TenantScopedQuerySetMixin, generics.ListAPIView):
    queryset = Course.objects.all()
    serializer_class = CourseSerializer
    permission_classes = [permissions.IsAuthenticated]

class BatchListView(TenantScopedQuerySetMixin, generics.ListAPIView):
    queryset = Batch.objects.all()
    serializer_class = BatchSerializer
    permission_classes = [permissions.IsAuthenticated]

class TimetableListView(TenantScopedQuerySetMixin, generics.ListAPIView):
    queryset = Timetable.objects.all()
    serializer_class = TimetableSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        queryset = super().get_queryset()
        batch_id = self.request.query_params.get('batch')
        if batch_id:
            queryset = queryset.filter(batch_id=batch_id)
        return queryset

