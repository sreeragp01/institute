from django.db import models
from accounts.models import User, Institute
from courses.models import Subject

class TrainerProfile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='trainer_profile')
    employee_id = models.CharField(max_length=50, unique=True)
    qualification = models.CharField(max_length=150, blank=True, null=True)
    specialization = models.CharField(max_length=150, blank=True, null=True)
    assigned_subjects = models.ManyToManyField(Subject, blank=True, related_name='trainers')
    monthly_salary = models.DecimalField(max_digits=10, decimal_places=2, default=50000.00)
    joining_date = models.DateField(auto_now_add=True)

    def __str__(self):
        return f"{self.user.email} [{self.employee_id}]"

class StaffLeaveRequest(models.Model):
    class Status(models.TextChoices):
        PENDING = 'PENDING', 'Pending'
        APPROVED = 'APPROVED', 'Approved'
        REJECTED = 'REJECTED', 'Rejected'

    trainer = models.ForeignKey(User, on_delete=models.CASCADE, related_name='staff_leave_requests')
    from_date = models.DateField()
    to_date = models.DateField()
    reason = models.TextField()
    status = models.CharField(max_length=20, choices=Status.choices, default=Status.PENDING)
    reviewed_by = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, blank=True, related_name='reviewed_staff_leaves')
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Staff Leave: {self.trainer.email} ({self.from_date} - {self.to_date})"

