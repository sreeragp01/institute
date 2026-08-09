from django.urls import path
from .views import (
    AIChatbotView, AIQuizGeneratorView, AIStudyAssistantView,
    AIAttendancePredictorView, AIReportGeneratorView
)

urlpatterns = [
    path('chat/', AIChatbotView.as_view(), name='ai_chat'),
    path('quiz/', AIQuizGeneratorView.as_view(), name='ai_quiz'),
    path('study-assistant/', AIStudyAssistantView.as_view(), name='ai_study_assistant'),
    path('attendance-predict/', AIAttendancePredictorView.as_view(), name='ai_attendance_predict'),
    path('report-generator/', AIReportGeneratorView.as_view(), name='ai_report_generator'),
]

