from django.test import TestCase
from rest_framework.test import APIClient
from rest_framework import status
from datetime import date
from accounts.models import User, Institute
from courses.models import Course
from payments.models import FeePayment, FeeStructure

class PaymentModuleTestCase(TestCase):
    def setUp(self):
        self.client = APIClient()
        self.institute = Institute.objects.create(code='SMEC', name='SMEC Tech')
        self.course = Course.objects.create(institute=self.institute, code='CS-101', name='Computer Science')
        self.student_user = User.objects.create_user(
            email='student@smec.edu', password='password123',
            first_name='Ananya', last_name='Sharma',
            role=User.Role.STUDENT, institute=self.institute
        )
        self.fee_structure = FeeStructure.objects.create(
            institute=self.institute, course=self.course,
            total_amount=45000.00, installments_count=3
        )
        self.payment = FeePayment.objects.create(
            institute=self.institute, student=self.student_user,
            amount=15000.00, due_date=date.today(), status=FeePayment.Status.PENDING
        )

    def test_get_fee_payment_list(self):
        self.client.force_authenticate(user=self.student_user)
        response = self.client.get('/api/v1/fees/')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertGreaterEqual(len(response.data), 1)

    def test_online_fee_payment_simulation(self):
        self.client.force_authenticate(user=self.student_user)
        response = self.client.post(f'/api/v1/fees/{self.payment.id}/pay/')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIn('transaction_id', response.data)
        self.assertEqual(response.data['payment']['status'], 'PAID')

    def test_get_fee_invoice_details(self):
        self.client.force_authenticate(user=self.student_user)
        response = self.client.get(f'/api/v1/fees/{self.payment.id}/invoice/')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIn('breakdown', response.data)
        self.assertEqual(response.data['invoice_number'], f"INV-{self.payment.id:06d}")
