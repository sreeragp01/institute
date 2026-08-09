from rest_framework import serializers
from .models import Announcement, Event, Notification, DirectMessage
from accounts.serializers import UserSerializer

class AnnouncementSerializer(serializers.ModelSerializer):
    posted_by_name = serializers.CharField(source='posted_by.get_full_name', read_only=True)

    class Meta:
        model = Announcement
        fields = '__all__'

class EventSerializer(serializers.ModelSerializer):
    class Meta:
        model = Event
        fields = '__all__'

class NotificationSerializer(serializers.ModelSerializer):
    class Meta:
        model = Notification
        fields = '__all__'
        read_only_fields = ['user']

class DirectMessageSerializer(serializers.ModelSerializer):
    sender_name = serializers.CharField(source='sender.get_full_name', read_only=True)
    recipient_name = serializers.CharField(source='recipient.get_full_name', read_only=True)

    class Meta:
        model = DirectMessage
        fields = ['id', 'sender', 'sender_name', 'recipient', 'recipient_name', 'message_text', 'is_read', 'created_at']
        read_only_fields = ['sender']
