from django.urls import path
from .views import CourseListView, BatchListView, TimetableListView

urlpatterns = [
    path('', CourseListView.as_view(), name='course_list'),
    path('batches/', BatchListView.as_view(), name='batch_list'),
    path('timetable/', TimetableListView.as_view(), name='timetable_list'),
]
