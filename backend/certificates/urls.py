from django.urls import path
from .views import IssuedCertificateListView, PublicCertificateVerificationView

urlpatterns = [
    path('', IssuedCertificateListView.as_view(), name='certificate_list'),
    path('verify/<str:code>/', PublicCertificateVerificationView.as_view(), name='certificate_verify'),
]
