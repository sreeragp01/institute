from django.db import models
from accounts.models import User, Institute
from courses.models import Course, Batch

class Announcement(models.Model):
    institute = models.ForeignKey(Institute, on_delete=models.CASCADE, null=True, blank=True, related_name='announcements')
    title = models.CharField(max_length=200)
    body = models.TextField()
    posted_by = models.ForeignKey(User, on_delete=models.CASCADE)
    target_batch = models.ForeignKey(Batch, on_delete=models.SET_NULL, null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.title

class Event(models.Model):
    institute = models.ForeignKey(Institute, on_delete=models.CASCADE, null=True, blank=True, related_name='events')
    title = models.CharField(max_length=200)
    description = models.TextField()
    event_date = models.DateTimeField()
    venue = models.CharField(max_length=150)
    organizer = models.CharField(max_length=100)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.title

class Notification(models.Model):
    class Channel(models.TextChoices):
        IN_APP = 'IN_APP', 'In-App Alert'
        PUSH = 'PUSH', 'Push Notification'
        SMS = 'SMS', 'SMS Alert'
        EMAIL = 'EMAIL', 'Email Notification'

    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='notifications')
    title = models.CharField(max_length=150)
    message = models.TextField()
    channel = models.CharField(max_length=20, choices=Channel.choices, default=Channel.IN_APP)
    is_read = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"[{self.channel}] {self.user.email}: {self.title}"

class DirectMessage(models.Model):
    sender = models.ForeignKey(User, on_delete=models.CASCADE, related_name='sent_messages')
    recipient = models.ForeignKey(User, on_delete=models.CASCADE, related_name='received_messages')
    message_text = models.TextField()
    is_read = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.sender.email} -> {self.recipient.email}: {self.message_text[:30]}"

