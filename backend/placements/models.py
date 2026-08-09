from django.db import models
from accounts.models import User, Institute

class Company(models.Model):
    institute = models.ForeignKey(Institute, on_delete=models.CASCADE, related_name='companies')
    name = models.CharField(max_length=150)
    logo_url = models.URLField(blank=True, null=True)
    website = models.URLField(blank=True, null=True)
    location = models.CharField(max_length=100, blank=True, null=True)

    def __str__(self):
        return self.name

class PlacementDrive(models.Model):
    institute = models.ForeignKey(Institute, on_delete=models.CASCADE, related_name='placement_drives')
    company = models.ForeignKey(Company, on_delete=models.CASCADE, related_name='drives')
    title = models.CharField(max_length=150) # e.g. Junior Data Scientist Drive
    role_description = models.TextField()
    package_lpa = models.DecimalField(max_digits=5, decimal_places=2, default=6.50) # Package in LPA
    eligibility_criteria = models.CharField(max_length=200, default='Minimum 75% Attendance & Passing Grades')
    drive_date = models.DateField()
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.company.name} - {self.title} ({self.package_lpa} LPA)"

class JobApplication(models.Model):
    class ApplicationStatus(models.TextChoices):
        APPLIED = 'APPLIED', 'Applied'
        SHORTLISTED = 'SHORTLISTED', 'Shortlisted'
        INTERVIEWED = 'INTERVIEWED', 'Interview Scheduled'
        SELECTED = 'SELECTED', 'Selected / Offered'
        REJECTED = 'REJECTED', 'Rejected'

    drive = models.ForeignKey(PlacementDrive, on_delete=models.CASCADE, related_name='applications')
    student = models.ForeignKey(User, on_delete=models.CASCADE, related_name='job_applications')
    status = models.CharField(max_length=20, choices=ApplicationStatus.choices, default=ApplicationStatus.APPLIED)
    applied_at = models.DateTimeField(auto_now_add=True)
    offer_letter_url = models.URLField(blank=True, null=True)

    def __str__(self):
        return f"{self.student.email} -> {self.drive.company.name} ({self.get_status_display()})"
