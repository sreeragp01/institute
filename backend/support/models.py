from django.db import models
from accounts.models import User, Institute

class TicketPriority(models.TextChoices):
    LOW = 'LOW', 'Low'
    MEDIUM = 'MEDIUM', 'Medium'
    HIGH = 'HIGH', 'High'
    URGENT = 'URGENT', 'Urgent'

class TicketStatus(models.TextChoices):
    OPEN = 'OPEN', 'Open'
    IN_PROGRESS = 'IN_PROGRESS', 'In Progress'
    RESOLVED = 'RESOLVED', 'Resolved'
    CLOSED = 'CLOSED', 'Closed'

class TicketCategory(models.TextChoices):
    ACADEMIC = 'ACADEMIC', 'Academic & Courses'
    FEE_BILLING = 'FEE_BILLING', 'Fee & Billing'
    ATTENDANCE = 'ATTENDANCE', 'Attendance Query'
    TECHNICAL = 'TECHNICAL', 'Technical & App Support'
    GENERAL = 'GENERAL', 'General Enquiry'

class SupportTicket(models.Model):
    institute = models.ForeignKey(Institute, on_delete=models.CASCADE, related_name='support_tickets')
    created_by = models.ForeignKey(User, on_delete=models.CASCADE, related_name='submitted_tickets')
    assigned_to = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, blank=True, related_name='assigned_tickets')
    category = models.CharField(max_length=30, choices=TicketCategory.choices, default=TicketCategory.GENERAL)
    priority = models.CharField(max_length=20, choices=TicketPriority.choices, default=TicketPriority.MEDIUM)
    status = models.CharField(max_length=20, choices=TicketStatus.choices, default=TicketStatus.OPEN)
    subject = models.CharField(max_length=200)
    description = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"[{self.status}] {self.subject} ({self.created_by.email})"

class TicketResponse(models.Model):
    ticket = models.ForeignKey(SupportTicket, on_delete=models.CASCADE, related_name='responses')
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    message = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Response on {self.ticket.subject} by {self.user.email}"
