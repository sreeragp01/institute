from django.urls import path
from .views import TrainerListView, TrainerDetailView, StaffLeaveListCreateView

urlpatterns = [
    path('trainers/', TrainerListView.as_view(), name='trainer_list'),
    path('trainers/<int:pk>/', TrainerDetailView.as_view(), name='trainer_detail'),
    path('leave-requests/', StaffLeaveListCreateView.as_view(), name='staff_leave_requests'),
]
