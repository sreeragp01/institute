from rest_framework import serializers
from .models import AuditLog

class AuditLogSerializer(serializers.ModelSerializer):
    actor_email = serializers.ReadOnlyField(source='actor.email')
    actor_name = serializers.ReadOnlyField(source='actor.get_full_name')

    class Meta:
        model = AuditLog
        fields = ['id', 'institute', 'actor', 'actor_email', 'actor_name', 'action', 'model_name', 'object_id', 'ip_address', 'changes', 'created_at']
        read_only_fields = ['id', 'institute', 'actor', 'created_at']
