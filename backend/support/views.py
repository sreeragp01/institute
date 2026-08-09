from rest_framework import generics, permissions, status
from rest_framework.response import Response
from rest_framework.views import APIView
from .models import SupportTicket, TicketResponse
from .serializers import SupportTicketSerializer, TicketResponseSerializer
from accounts.permissions import IsTenantObject

class TicketListCreateView(generics.ListCreateAPIView):
    serializer_class = SupportTicketSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        user = self.request.user
        if user.role == 'SUPER_ADMIN':
            return SupportTicket.objects.all().order_by('-created_at')
        if user.role in ['ADMIN', 'TRAINER']:
            return SupportTicket.objects.filter(institute=user.institute).order_by('-created_at')
        # Students & Parents see their own submitted tickets
        return SupportTicket.objects.filter(created_by=user).order_by('-created_at')

    def perform_create(self, serializer):
        user = self.request.user
        serializer.save(created_by=user, institute=user.institute)

class TicketDetailView(generics.RetrieveUpdateDestroyAPIView):
    serializer_class = SupportTicketSerializer
    permission_classes = [permissions.IsAuthenticated, IsTenantObject]

    def get_queryset(self):
        user = self.request.user
        if user.role == 'SUPER_ADMIN':
            return SupportTicket.objects.all()
        if user.role in ['ADMIN', 'TRAINER']:
            return SupportTicket.objects.filter(institute=user.institute)
        return SupportTicket.objects.filter(created_by=user)

class TicketReplyView(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def post(self, request, ticket_id):
        ticket = SupportTicket.objects.filter(id=ticket_id).first()
        if not ticket:
            return Response({'detail': 'Ticket not found'}, status=status.HTTP_404_NOT_FOUND)

        message = request.data.get('message')
        if not message:
            return Response({'detail': 'Message content is required'}, status=status.HTTP_400_BAD_REQUEST)

        response = TicketResponse.objects.create(ticket=ticket, user=request.user, message=message)
        # Update ticket status if replied by staff
        if request.user.role in ['ADMIN', 'TRAINER', 'SUPER_ADMIN'] and ticket.status == 'OPEN':
            ticket.status = 'IN_PROGRESS'
            ticket.save()

        return Response(TicketResponseSerializer(response).data, status=status.HTTP_201_CREATED)
