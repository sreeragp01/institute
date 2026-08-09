from django.urls import path
from .views import PlacementDriveListView, ApplyJobDriveView, MyJobApplicationsView

urlpatterns = [
    path('drives/', PlacementDriveListView.as_view(), name='placement_drives'),
    path('drives/<int:pk>/apply/', ApplyJobDriveView.as_view(), name='apply_placement_drive'),
    path('my-applications/', MyJobApplicationsView.as_view(), name='my_job_applications'),
]
