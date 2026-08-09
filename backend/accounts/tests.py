from django.test import TestCase
from rest_framework.test import APIClient
from rest_framework import status
from accounts.models import User, Institute, SubscriptionPlan
from certificates.models import IssuedCertificate
from courses.models import Course

class SMECTenantAuthTestCase(TestCase):
    def setUp(self):
        self.client = APIClient()
        self.plan = SubscriptionPlan.objects.create(
            name='Pro Plan',
            tier=SubscriptionPlan.Tier.PROFESSIONAL,
            price_per_month=299.00
        )
        self.institute_a = Institute.objects.create(
            name='Institute Alpha',
            code='ALPHA',
            plan=self.plan,
            subscription_status=Institute.SubscriptionStatus.ACTIVE
        )
        self.user_a = User.objects.create_user(
            email='admin@alpha.edu',
            password='password123',
            first_name='Alpha',
            last_name='Admin',
            role=User.Role.ADMIN,
            institute=self.institute_a
        )

    def test_public_institute_registration(self):
        response = self.client.post('/api/v1/auth/register-institute/', {
            'institute_name': 'Beta Tech Academy',
            'contact_email': 'info@betatech.edu',
            'tier': 'PROFESSIONAL',
            'admin_email': 'admin@betatech.edu',
            'admin_password': 'password123',
            'admin_first_name': 'BetaAdmin'
        }, format='json')

        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertIn('tokens', response.data)
        self.assertEqual(response.data['institute']['name'], 'Beta Tech Academy')
        self.assertEqual(response.data['user']['email'], 'admin@betatech.edu')

    def test_jwt_authentication_and_tenant_claims(self):
        login_res = self.client.post('/api/v1/auth/login/', {
            'email': 'admin@alpha.edu',
            'password': 'password123'
        }, format='json')

        self.assertEqual(login_res.status_code, status.HTTP_200_OK)
        token = login_res.data['access']
        self.client.credentials(HTTP_AUTHORIZATION=f'Bearer {token}')

        me_res = self.client.get('/api/v1/auth/me/')
        self.assertEqual(me_res.status_code, status.HTTP_200_OK)
        self.assertEqual(me_res.data['institute']['code'], 'ALPHA')

    def test_public_certificate_verification(self):
        cert = IssuedCertificate.objects.create(
            institute=self.institute_a,
            student=self.user_a,
            certificate_number='CERT-ALPHA-001',
            certificate_type=IssuedCertificate.CertType.COMPLETION,
            verification_code='VERIFY-TEST-99'
        )

        # Public verification requires NO authentication
        self.client.credentials() # Clear credentials
        res = self.client.get('/api/v1/certificates/verify/VERIFY-TEST-99/')
        self.assertEqual(res.status_code, status.HTTP_200_OK)
        self.assertTrue(res.data['is_valid'])
        self.assertEqual(res.data['institute_code'], 'ALPHA')

    def test_ai_study_assistant(self):
        self.client.force_authenticate(user=self.user_a)
        res = self.client.post('/api/v1/ai/study-assistant/', {
            'notes': 'Deep Learning uses Neural Networks with multiple hidden layers to extract representations.'
        }, format='json')

        self.assertEqual(res.status_code, status.HTTP_200_OK)
        self.assertIn('summary', res.data)
        self.assertIn('flashcards', res.data)
        self.assertIn('interview_questions', res.data)
