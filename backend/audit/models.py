from django.db import models
from accounts.models import User, Institute

class AuditLog(models.Model):
    institute = models.ForeignKey(Institute, on_delete=models.CASCADE, null=True, blank=True, related_name='audit_logs')
    actor = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, blank=True)
    action = models.CharField(max_length=150)
    target_model = models.CharField(max_length=100, blank=True, null=True)
    details = models.TextField(blank=True, null=True)
    ip_address = models.GenericIPAddressField(null=True, blank=True)
    timestamp = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        actor_email = self.actor.email if self.actor else 'SYSTEM'
        return f"[{self.timestamp.strftime('%Y-%m-%d %H:%M')}] {actor_email}: {self.action}"
