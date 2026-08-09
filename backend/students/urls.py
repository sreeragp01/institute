from django.urls import path
from .views import (
    StudentListView, StudentDetailView, StudentBulkImportView,
    StudentBatchPromotionView, StudentQRCardView, LeaveRequestListCreateView,
    LeaveRequestDetailView, MyStudentProfileView, MyParentProfileView
)

urlpatterns = [
    path('', StudentListView.as_view(), name='student_list'),
    path('my-profile/', MyStudentProfileView.as_view(), name='my_student_profile'),
    path('parent-profile/', MyParentProfileView.as_view(), name='my_parent_profile'),
    path('<int:pk>/', StudentDetailView.as_view(), name='student_detail'),
    path('import-excel/', StudentBulkImportView.as_view(), name='student_import_excel'),
    path('promote-batch/', StudentBatchPromotionView.as_view(), name='student_promote_batch'),
    path('<int:pk>/qr-card/', StudentQRCardView.as_view(), name='student_qr_card'),
    path('leave-requests/', LeaveRequestListCreateView.as_view(), name='student_leave_requests'),
    path('leave-requests/<int:pk>/', LeaveRequestDetailView.as_view(), name='student_leave_request_detail'),
]
