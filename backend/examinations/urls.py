from django.urls import path
from .views import ExamListView, ExamDetailView, SubmitExamView

urlpatterns = [
    path('', ExamListView.as_view(), name='exam_list'),
    path('<int:pk>/', ExamDetailView.as_view(), name='exam_detail'),
    path('<int:pk>/submit/', SubmitExamView.as_view(), name='exam_submit'),
]
