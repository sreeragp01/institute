from rest_framework import serializers
from .models import Announcement, Event, Notification, DirectMessage

class AnnouncementSerializer(serializers.ModelSerializer):
    posted_by_name = serializers.CharField(source='posted_by.get_full_name', read_only=True)

    class Meta:
        model = Announcement
        fields = ['id', 'institute', 'title', 'content', 'target_role', 'posted_by', 'posted_by_name', 'created_at']
        read_only_fields = ['id', 'institute', 'posted_by', 'created_at']

class EventSerializer(serializers.ModelSerializer):
    class Meta:
        model = Event
        fields = ['id', 'institute', 'title', 'description', 'start_time', 'end_time', 'location', 'created_at']
        read_only_fields = ['id', 'institute', 'created_at']

class NotificationSerializer(serializers.ModelSerializer):
    class Meta:
        model = Notification
        fields = ['id', 'user', 'title', 'message', 'is_read', 'notification_type', 'created_at']
        read_only_fields = ['id', 'user', 'created_at']

class DirectMessageSerializer(serializers.ModelSerializer):
    sender_name = serializers.CharField(source='sender.get_full_name', read_only=True)
    recipient_name = serializers.CharField(source='recipient.get_full_name', read_only=True)

    class Meta:
        model = DirectMessage
        fields = ['id', 'sender', 'sender_name', 'recipient', 'recipient_name', 'message_text', 'is_read', 'created_at']
        read_only_fields = ['id', 'sender', 'created_at']
