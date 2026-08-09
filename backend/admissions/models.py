from django.db import models
from accounts.models import User, Institute

class LeadSource(models.TextChoices):
    WEBSITE = 'WEBSITE', 'Website Enquiry'
    WALK_IN = 'WALK_IN', 'Walk-in Visit'
    REFERRAL = 'REFERRAL', 'Student Referral'
    SOCIAL = 'SOCIAL', 'Social Media'
    CALL = 'CALL', 'Phone Call'

class EnquiryStatus(models.TextChoices):
    NEW = 'NEW', 'New Enquiry'
    CONTACTED = 'CONTACTED', 'Contacted'
    COUNSELED = 'COUNSELED', 'Counseled'
    REGISTERED = 'REGISTERED', 'Onboarded'
    LOST = 'LOST', 'Closed / Lost'

class Enquiry(models.Model):
    institute = models.ForeignKey(Institute, on_delete=models.CASCADE, related_name='enquiries')
    candidate_name = models.CharField(max_length=150)
    email = models.EmailField()
    phone_number = models.CharField(max_length=20)
    interested_course = models.CharField(max_length=150)
    source = models.CharField(max_length=20, choices=LeadSource.choices, default=LeadSource.WEBSITE)
    status = models.CharField(max_length=20, choices=EnquiryStatus.choices, default=EnquiryStatus.NEW)
    notes = models.TextField(blank=True, null=True)
    assigned_counselor = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, blank=True, related_name='assigned_enquiries')
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"{self.candidate_name} - {self.interested_course} ({self.status})"
