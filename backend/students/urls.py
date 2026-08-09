from django.urls import path
from .views import (
    StudentListView, StudentDetailView, StudentBulkImportView,
    StudentBatchPromotionView, StudentQRCardView, LeaveRequestListCreateView
)

urlpatterns = [
    path('', StudentListView.as_view(), name='student_list'),
    path('<int:pk>/', StudentDetailView.as_view(), name='student_detail'),
    path('import-excel/', StudentBulkImportView.as_view(), name='student_import_excel'),
    path('promote-batch/', StudentBatchPromotionView.as_view(), name='student_promote_batch'),
    path('<int:pk>/qr-card/', StudentQRCardView.as_view(), name='student_qr_card'),
    path('leave-requests/', LeaveRequestListCreateView.as_view(), name='student_leave_requests'),
]
