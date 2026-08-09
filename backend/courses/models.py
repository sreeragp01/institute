from django.db import models
from accounts.models import User, Institute

class Course(models.Model):
    institute = models.ForeignKey(Institute, on_delete=models.CASCADE, null=True, blank=True, related_name='courses')
    name = models.CharField(max_length=150)
    code = models.CharField(max_length=20)
    description = models.TextField(blank=True, null=True)
    duration_months = models.IntegerField(default=6)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        unique_together = ('institute', 'code')

    def __str__(self):
        inst = self.institute.code if self.institute else "GLOBAL"
        return f"[{inst}] {self.code} - {self.name}"

class Batch(models.Model):
    course = models.ForeignKey(Course, on_delete=models.CASCADE, related_name='batches')
    name = models.CharField(max_length=100)
    start_date = models.DateField()
    end_date = models.DateField()
    trainer = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, limit_choices_to={'role': User.Role.TRAINER})

    def __str__(self):
        return f"{self.course.code} ({self.name})"

class Subject(models.Model):
    course = models.ForeignKey(Course, on_delete=models.CASCADE, related_name='subjects')
    name = models.CharField(max_length=100)
    code = models.CharField(max_length=20)

    def __str__(self):
        return self.name

class Timetable(models.Model):
    class DayOfWeek(models.TextChoices):
        MONDAY = 'MON', 'Monday'
        TUESDAY = 'TUE', 'Tuesday'
        WEDNESDAY = 'WED', 'Wednesday'
        THURSDAY = 'THU', 'Thursday'
        FRIDAY = 'FRI', 'Friday'
        SATURDAY = 'SAT', 'Saturday'

    batch = models.ForeignKey(Batch, on_delete=models.CASCADE, related_name='timetables')
    subject = models.ForeignKey(Subject, on_delete=models.CASCADE)
    trainer = models.ForeignKey(User, on_delete=models.SET_NULL, null=True)
    day = models.CharField(max_length=3, choices=DayOfWeek.choices)
    start_time = models.TimeField()
    end_time = models.TimeField()
    room_number = models.CharField(max_length=50, default='Lab 1')

    def __str__(self):
        return f"{self.batch.name} - {self.subject.name} ({self.day} {self.start_time})"
