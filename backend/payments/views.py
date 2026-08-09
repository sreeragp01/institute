import uuid
from datetime import date
from rest_framework import generics, permissions, status
from rest_framework.response import Response
from rest_framework.views import APIView
from accounts.models import User
from accounts.tenant_mixin import TenantScopedQuerySetMixin
from .models import FeePayment, FeeStructure
from .serializers import FeePaymentSerializer, FeeStructureSerializer

class FeePaymentListView(TenantScopedQuerySetMixin, generics.ListAPIView):
    queryset = FeePayment.objects.all().order_by('-due_date')
    serializer_class = FeePaymentSerializer
    permission_classes = [permissions.IsAuthenticated]

class FeeStructureListView(TenantScopedQuerySetMixin, generics.ListAPIView):
    queryset = FeeStructure.objects.all()
    serializer_class = FeeStructureSerializer
    permission_classes = [permissions.IsAuthenticated]

class PayFeeOnlineView(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def post(self, request, pk):
        try:
            payment = FeePayment.objects.get(id=pk)
        except FeePayment.DoesNotExist:
            return Response({'detail': 'Fee payment record not found'}, status=status.HTTP_404_NOT_FOUND)

        txn_id = f"TXN-{uuid.uuid4().hex[:10].upper()}"
        payment.status = FeePayment.Status.PAID
        payment.paid_date = date.today()
        payment.transaction_id = txn_id
        payment.receipt_url = f"https://smecconnect.com/receipts/{payment.id}.pdf"
        payment.save()

        return Response({
            'message': 'Payment successful! Receipt generated.',
            'transaction_id': txn_id,
            'amount_paid': str(payment.amount),
            'paid_date': str(payment.paid_date),
            'receipt_url': payment.receipt_url,
            'payment': FeePaymentSerializer(payment).data
        })

class FeeInvoiceDetailView(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def get(self, request, pk):
        try:
            payment = FeePayment.objects.get(id=pk)
        except FeePayment.DoesNotExist:
            return Response({'detail': 'Invoice not found'}, status=status.HTTP_404_NOT_FOUND)

        amt = float(payment.amount)
        return Response({
            'invoice_number': f"INV-{payment.id:06d}",
            'student_name': payment.student.get_full_name() or payment.student.email,
            'student_email': payment.student.email,
            'institute_name': payment.institute.name if payment.institute else 'SMEC Connect',
            'amount_due': str(payment.amount),
            'due_date': str(payment.due_date),
            'paid_date': str(payment.paid_date) if payment.paid_date else None,
            'status': payment.status,
            'transaction_id': payment.transaction_id,
            'breakdown': [
                {'description': 'Tuition & Academic Training Fee', 'amount': f"{amt * 0.85:.2f}"},
                {'description': 'Lab Workstation & AI Cloud Access', 'amount': f"{amt * 0.10:.2f}"},
                {'description': 'Library & Examination Fee', 'amount': f"{amt * 0.05:.2f}"},
            ]
        })

