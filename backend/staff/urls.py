from django.urls import path
from .views import TrainerListView, TrainerDetailView, StaffLeaveListCreateView, MyTrainerProfileView

urlpatterns = [
    path('trainers/', TrainerListView.as_view(), name='trainer_list'),
    path('my-profile/', MyTrainerProfileView.as_view(), name='my_trainer_profile'),
    path('trainers/<int:pk>/', TrainerDetailView.as_view(), name='trainer_detail'),
    path('leave-requests/', StaffLeaveListCreateView.as_view(), name='staff_leave_requests'),
]
