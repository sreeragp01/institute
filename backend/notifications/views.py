from django.db import models
from rest_framework import generics, permissions, status
from rest_framework.response import Response
from rest_framework.views import APIView

from accounts.models import User
from accounts.tenant_mixin import TenantScopedQuerySetMixin
from .models import Announcement, Event, Notification, DirectMessage
from .serializers import AnnouncementSerializer, EventSerializer, NotificationSerializer, DirectMessageSerializer

class AnnouncementListView(TenantScopedQuerySetMixin, generics.ListCreateAPIView):
    queryset = Announcement.objects.all().order_by('-created_at')
    serializer_class = AnnouncementSerializer
    permission_classes = [permissions.IsAuthenticated]

    def perform_create(self, serializer):
        serializer.save(institute=self.request.user.institute, posted_by=self.request.user)

class EventListView(TenantScopedQuerySetMixin, generics.ListCreateAPIView):
    queryset = Event.objects.all().order_by('-event_date')
    serializer_class = EventSerializer
    permission_classes = [permissions.IsAuthenticated]

    def perform_create(self, serializer):
        serializer.save(institute=self.request.user.institute)

class NotificationListView(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def get(self, request):
        notifications = Notification.objects.filter(user=request.user).order_by('-created_at')
        return Response(NotificationSerializer(notifications, many=True).data)

class MarkNotificationReadView(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def post(self, request, pk):
        Notification.objects.filter(id=pk, user=request.user).update(is_read=True)
        return Response({'message': 'Notification marked as read.'})

class SendBroadcastView(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def post(self, request):
        title = request.data.get('title')
        message = request.data.get('message')
        channel = request.data.get('channel', Notification.Channel.IN_APP)

        if not title or not message:
            return Response({'detail': 'Title and message required.'}, status=status.HTTP_400_BAD_REQUEST)

        # Broadcast to all users in current institute
        target_users = User.objects.filter(institute=request.user.institute)
        notifications = [
            Notification(user=u, title=title, message=message, channel=channel)
            for u in target_users
        ]
        Notification.objects.bulk_create(notifications)

        return Response({
            'message': f'Broadcast notification dispatched to {len(notifications)} users via {channel}.',
            'sent_count': len(notifications)
        }, status=status.HTTP_201_CREATED)

class DirectMessageListView(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def get(self, request):
        messages = DirectMessage.objects.filter(
            models.Q(sender=request.user) | models.Q(recipient=request.user)
        ).order_by('created_at')
        return Response(DirectMessageSerializer(messages, many=True).data)

    def post(self, request):
        recipient_id = request.data.get('recipient_id')
        text = request.data.get('message_text')

        if not recipient_id or not text:
            return Response({'detail': 'recipient_id and message_text are required.'}, status=status.HTTP_400_BAD_REQUEST)

        try:
            recipient = User.objects.get(id=recipient_id)
        except User.DoesNotExist:
            return Response({'detail': 'Recipient user not found.'}, status=status.HTTP_404_NOT_FOUND)

        msg = DirectMessage.objects.create(
            sender=request.user,
            recipient=recipient,
            message_text=text
        )

        return Response(DirectMessageSerializer(msg).data, status=status.HTTP_201_CREATED)
