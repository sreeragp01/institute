from django.test import TestCase
from rest_framework.test import APIClient
from rest_framework import status
from accounts.models import User, Institute, SubscriptionPlan
from admissions.models import Enquiry

class TenantIsolationTestCase(TestCase):
    def setUp(self):
        self.client = APIClient()

        # Create Subscription Plan
        self.plan = SubscriptionPlan.objects.create(
            tier=SubscriptionPlan.Tier.PROFESSIONAL,
            name='Pro Plan',
            price_per_month=299.00
        )

        # Create Institute A
        self.institute_a = Institute.objects.create(
            code='INST_A', name='Institute Alpha', plan=self.plan
        )
        self.admin_a = User.objects.create_user(
            email='admin@alpha.com', password='password123',
            role=User.Role.ADMIN, institute=self.institute_a
        )

        # Create Institute B
        self.institute_b = Institute.objects.create(
            code='INST_B', name='Institute Beta', plan=self.plan
        )
        self.admin_b = User.objects.create_user(
            email='admin@beta.com', password='password123',
            role=User.Role.ADMIN, institute=self.institute_b
        )

        # Create Enquiry belonging to Institute A
        self.enquiry_a = Enquiry.objects.create(
            institute=self.institute_a,
            candidate_name='Candidate A',
            email='candidate_a@test.com',
            phone_number='1234567890',
            interested_course='Python & AI'
        )

    def test_tenant_isolation_list_enquiries(self):
        # Authenticate as Admin B (Institute B)
        self.client.force_authenticate(user=self.admin_b)
        response = self.client.get('/api/v1/admissions/enquiries/')

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        # Admin B should NOT see Institute A's enquiries
        enquiry_ids = [item['id'] for item in response.data]
        self.assertNotIn(self.enquiry_a.id, enquiry_ids)

    def test_tenant_isolation_detail_access(self):
        # Authenticate as Admin B and attempt to view Institute A's enquiry
        self.client.force_authenticate(user=self.admin_b)
        response = self.client.get(f'/api/v1/admissions/enquiries/{self.enquiry_a.id}/')

        self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND)
