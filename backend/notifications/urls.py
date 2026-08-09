from django.urls import path
from .views import (
    AnnouncementListView, EventListView, NotificationListView,
    MarkNotificationReadView, SendBroadcastView, DirectMessageListView
)

urlpatterns = [
    path('announcements/', AnnouncementListView.as_view(), name='announcement_list'),
    path('events/', EventListView.as_view(), name='event_list'),
    path('in-app/', NotificationListView.as_view(), name='notification_list'),
    path('in-app/<int:pk>/read/', MarkNotificationReadView.as_view(), name='notification_read'),
    path('broadcast/', SendBroadcastView.as_view(), name='notification_broadcast'),
    path('messages/', DirectMessageListView.as_view(), name='direct_messages'),
]
