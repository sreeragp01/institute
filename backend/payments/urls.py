from django.urls import path
from .views import FeePaymentListView, FeeStructureListView, PayFeeOnlineView, FeeInvoiceDetailView

urlpatterns = [
    path('', FeePaymentListView.as_view(), name='fee_payment_list'),
    path('structures/', FeeStructureListView.as_view(), name='fee_structure_list'),
    path('<int:pk>/pay/', PayFeeOnlineView.as_view(), name='fee_pay'),
    path('<int:pk>/invoice/', FeeInvoiceDetailView.as_view(), name='fee_invoice'),
]

