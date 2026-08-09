from django.db import models
from accounts.models import User, Institute
from courses.models import Course, Batch

class Exam(models.Model):
    class ExamType(models.TextChoices):
        MCQ = 'MCQ', 'Multiple Choice Test'
        CODING = 'CODING', 'Coding Challenge'
        PRACTICAL = 'PRACTICAL', 'Practical Lab Assessment'

    institute = models.ForeignKey(Institute, on_delete=models.CASCADE, related_name='exams')
    course = models.ForeignKey(Course, on_delete=models.CASCADE, related_name='exams')
    batch = models.ForeignKey(Batch, on_delete=models.SET_NULL, null=True, blank=True, related_name='exams')
    title = models.CharField(max_length=150)
    exam_type = models.CharField(max_length=20, choices=ExamType.choices, default=ExamType.MCQ)
    duration_minutes = models.IntegerField(default=60)
    total_marks = models.IntegerField(default=100)
    pass_marks = models.IntegerField(default=40)
    scheduled_at = models.DateTimeField()
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.title} ({self.get_exam_type_display()})"

class Question(models.Model):
    exam = models.ForeignKey(Exam, on_delete=models.CASCADE, related_name='questions')
    question_text = models.TextField()
    options = models.JSONField(default=list, blank=True) # list of string options for MCQ
    correct_option = models.IntegerField(default=0) # 0-indexed correct option
    starter_code = models.TextField(blank=True, null=True) # For coding tests
    test_cases = models.JSONField(default=list, blank=True) # For coding evaluation
    marks = models.IntegerField(default=10)

    def __str__(self):
        return f"Q: {self.question_text[:50]}"

class ExamSubmission(models.Model):
    exam = models.ForeignKey(Exam, on_delete=models.CASCADE, related_name='submissions')
    student = models.ForeignKey(User, on_delete=models.CASCADE, related_name='exam_submissions')
    answers = models.JSONField(default=dict) # e.g. {"q1": 0, "q2": 1}
    marks_obtained = models.DecimalField(max_digits=5, decimal_places=2, default=0.00)
    rank = models.IntegerField(null=True, blank=True)
    is_passed = models.BooleanField(default=False)
    submitted_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.student.email} - {self.exam.title} ({self.marks_obtained}/{self.exam.total_marks})"
