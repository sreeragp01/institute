from rest_framework import serializers
from .models import Exam, Question, ExamSubmission

class QuestionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Question
        fields = ['id', 'question_text', 'options', 'starter_code', 'test_cases', 'marks']

class ExamSerializer(serializers.ModelSerializer):
    questions = QuestionSerializer(many=True, read_only=True)
    course_name = serializers.CharField(source='course.name', read_only=True)

    class Meta:
        model = Exam
        fields = ['id', 'title', 'exam_type', 'course', 'course_name', 'batch', 'duration_minutes', 'total_marks', 'pass_marks', 'scheduled_at', 'questions']

class ExamSubmissionSerializer(serializers.ModelSerializer):
    exam_title = serializers.CharField(source='exam.title', read_only=True)
    student_name = serializers.CharField(source='student.get_full_name', read_only=True)

    class Meta:
        model = ExamSubmission
        fields = ['id', 'exam', 'exam_title', 'student', 'student_name', 'answers', 'marks_obtained', 'rank', 'is_passed', 'submitted_at']
        read_only_fields = ['student', 'marks_obtained', 'rank', 'is_passed']
