from rest_framework import serializers
from .models import SupportTicket, TicketResponse

class TicketResponseSerializer(serializers.ModelSerializer):
    user_email = serializers.ReadOnlyField(source='user.email')
    user_name = serializers.ReadOnlyField(source='user.get_full_name')

    class Meta:
        model = TicketResponse
        fields = ['id', 'ticket', 'user', 'user_email', 'user_name', 'message', 'created_at']
        read_only_fields = ['id', 'user', 'created_at']

class SupportTicketSerializer(serializers.ModelSerializer):
    created_by_email = serializers.ReadOnlyField(source='created_by.email')
    created_by_name = serializers.ReadOnlyField(source='created_by.get_full_name')
    responses = TicketResponseSerializer(many=True, read_only=True)

    class Meta:
        model = SupportTicket
        fields = ['id', 'institute', 'created_by', 'created_by_email', 'created_by_name', 'subject', 'description', 'category', 'priority', 'status', 'responses', 'created_at', 'updated_at']
        read_only_fields = ['id', 'institute', 'created_by', 'created_at', 'updated_at']
