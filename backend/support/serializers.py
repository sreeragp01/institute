from rest_framework import serializers
from .models import SupportTicket, TicketResponse

class TicketResponseSerializer(serializers.ModelSerializer):
    user_email = serializers.ReadOnlyField(source='user.email')
    user_name = serializers.ReadOnlyField(source='user.get_full_name')

    class Meta:
        model = TicketResponse
        fields = '__all__'
        read_only_fields = ('created_at', 'user')

class SupportTicketSerializer(serializers.ModelSerializer):
    created_by_email = serializers.ReadOnlyField(source='created_by.email')
    created_by_name = serializers.ReadOnlyField(source='created_by.get_full_name')
    responses = TicketResponseSerializer(many=True, read_only=True)

    class Meta:
        model = SupportTicket
        fields = '__all__'
        read_only_fields = ('created_at', 'updated_at', 'created_by', 'institute')
