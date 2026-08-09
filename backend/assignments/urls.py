from django.urls import path
from .views import AssignmentListCreateView, SubmitAssignmentView, GradeSubmissionView

urlpatterns = [
    path('', AssignmentListCreateView.as_view(), name='assignment_list'),
    path('<int:assignment_id>/submit/', SubmitAssignmentView.as_view(), name='submit_assignment'),
    path('submissions/<int:submission_id>/grade/', GradeSubmissionView.as_view(), name='grade_submission'),
]
