from django.urls import path
from .views import AssignmentListCreateView, SubmitAssignmentView

urlpatterns = [
    path('', AssignmentListCreateView.as_view(), name='assignment_list'),
    path('<int:assignment_id>/submit/', SubmitAssignmentView.as_view(), name='submit_assignment'),
]
