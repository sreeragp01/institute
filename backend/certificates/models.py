from django.db import models
from accounts.models import User, Institute
from courses.models import Course

class IssuedCertificate(models.Model):
    class CertType(models.TextChoices):
        COMPLETION = 'COMPLETION', 'Course Completion Certificate'
        INTERNSHIP = 'INTERNSHIP', 'Internship Certificate'
        WORKSHOP = 'WORKSHOP', 'Workshop Certificate'

    institute = models.ForeignKey(Institute, on_delete=models.CASCADE, related_name='certificates')
    student = models.ForeignKey(User, on_delete=models.CASCADE, related_name='certificates')
    course = models.ForeignKey(Course, on_delete=models.SET_NULL, null=True, blank=True)
    certificate_number = models.CharField(max_length=50, unique=True)
    certificate_type = models.CharField(max_length=20, choices=CertType.choices, default=CertType.COMPLETION)
    verification_code = models.CharField(max_length=64, unique=True)
    issue_date = models.DateField(auto_now_add=True)
    pdf_url = models.URLField(blank=True, null=True)

    def __str__(self):
        return f"{self.student.email} - {self.certificate_number} ({self.get_certificate_type_display()})"
