from django.db import models
from accounts.models import User, Institute
from courses.models import Course

class FeeStructure(models.Model):
    institute = models.ForeignKey(Institute, on_delete=models.CASCADE, null=True, blank=True, related_name='fee_structures')
    course = models.OneToOneField(Course, on_delete=models.CASCADE, related_name='fee_structure')
    total_amount = models.DecimalField(max_digits=10, decimal_places=2)
    installments_count = models.IntegerField(default=3)

    def __str__(self):
        return f"{self.course.name} Fee: ₹{self.total_amount}"

class FeePayment(models.Model):
    class Status(models.TextChoices):
        PAID = 'PAID', 'Paid'
        PENDING = 'PENDING', 'Pending'
        OVERDUE = 'OVERDUE', 'Overdue'

    institute = models.ForeignKey(Institute, on_delete=models.CASCADE, null=True, blank=True, related_name='fee_payments')
    student = models.ForeignKey(User, on_delete=models.CASCADE, related_name='fee_payments')
    amount = models.DecimalField(max_digits=10, decimal_places=2)
    due_date = models.DateField()
    paid_date = models.DateField(blank=True, null=True)
    status = models.CharField(max_length=20, choices=Status.choices, default=Status.PENDING)
    transaction_id = models.CharField(max_length=100, blank=True, null=True)
    receipt_url = models.URLField(blank=True, null=True)

    def __str__(self):
        return f"{self.student.email} - ₹{self.amount} ({self.status})"
