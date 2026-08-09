from django.test import TestCase
from rest_framework.test import APIClient
from rest_framework import status
from django.utils import timezone
from datetime import timedelta
from accounts.models import User, Institute, SubscriptionPlan, EmailOTP
from students.models import StudentProfile
from attendance.models import AttendanceRecord, AttendanceSession

class ProductionHardeningTestCase(TestCase):
    def setUp(self):
        self.client = APIClient()
        
        # Plan with max_students=1 limit
        self.plan_limited = SubscriptionPlan.objects.create(
            name='Limited Trial Plan',
            tier=SubscriptionPlan.Tier.FREE_TRIAL,
            max_students=1,
            max_staff=2
        )

        self.institute = Institute.objects.create(
            code='HARD',
            name='Hardened Tech Institute',
            plan=self.plan_limited
        )

        self.admin_user = User.objects.create_user(
            email='admin@hardened.edu',
            password='password123',
            first_name='Hardened',
            last_name='Admin',
            role=User.Role.ADMIN,
            institute=self.institute,
            is_staff=True
        )

    def test_public_registration_role_lockdown(self):
        """Public registration MUST force role=STUDENT and ignore role=ADMIN."""
        payload = {
            'email': 'hacker@public.com',
            'password': 'password123',
            'first_name': 'Hacker',
            'last_name': 'Attempt',
            'role': 'ADMIN' # Hacker attempts to self-assign ADMIN role
        }
        response = self.client.post('/api/v1/auth/register/', payload)
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        
        user = User.objects.get(email='hacker@public.com')
        self.assertEqual(user.role, User.Role.STUDENT, "Public registration must force role=STUDENT!")

    def test_real_otp_generation_and_verification(self):
        """Request OTP creates DB EmailOTP record; verify OTP validates code and expiry."""
        req_res = self.client.post('/api/v1/auth/request-otp/', {'phone_or_email': 'student@hardened.edu'})
        self.assertEqual(req_res.status_code, status.HTTP_200_OK)
        
        otp_code = req_res.data['otp_code']
        self.assertNotEqual(otp_code, '123456', "OTP code must NOT be hardcoded demo string!")
        self.assertEqual(len(otp_code), 6)

        # Invalid OTP check
        inv_res = self.client.post('/api/v1/auth/verify-otp/', {'phone_or_email': 'student@hardened.edu', 'otp': '000000'})
        self.assertEqual(inv_res.status_code, status.HTTP_400_BAD_REQUEST)

        # Valid OTP check for created user
        student = User.objects.create_user(
            email='student@hardened.edu',
            password='password123',
            role=User.Role.STUDENT,
            institute=self.institute
        )

        valid_res = self.client.post('/api/v1/auth/verify-otp/', {'phone_or_email': 'student@hardened.edu', 'otp': otp_code})
        self.assertEqual(valid_res.status_code, status.HTTP_200_OK)
        self.assertIn('access', valid_res.data['tokens'])

    def test_saas_plan_limit_enforcement(self):
        """OnboardStudentView must reject onboarding when max_students limit is reached."""
        self.client.force_authenticate(user=self.admin_user)
        
        # Student 1 onboarding (Allowed: max_students=1)
        res1 = self.client.post('/api/v1/auth/onboard-student/', {
            'email': 'st1@hardened.edu',
            'first_name': 'Student1',
            'password': 'password123'
        })
        self.assertEqual(res1.status_code, status.HTTP_201_CREATED)

        # Student 2 onboarding (Blocked: limit reached!)
        res2 = self.client.post('/api/v1/auth/onboard-student/', {
            'email': 'st2@hardened.edu',
            'first_name': 'Student2',
            'password': 'password123'
        })
        self.assertEqual(res2.status_code, status.HTTP_403_FORBIDDEN)
        self.assertIn('limit reached', res2.data['detail'].lower())

    def test_manual_roll_call_database_persistence(self):
        """Manual roll call must create/update real AttendanceRecord rows in DB."""
        self.client.force_authenticate(user=self.admin_user)

        student = User.objects.create_user(
            email='st_roll@hardened.edu',
            password='password123',
            role=User.Role.STUDENT,
            institute=self.institute
        )

        roll_payload = {
            'records': [
                {'student_id': student.id, 'status': 'PRESENT'}
            ]
        }
        res = self.client.post('/api/v1/attendance/manual-roll-call/', roll_payload, format='json')
        self.assertEqual(res.status_code, status.HTTP_200_OK)

        rec = AttendanceRecord.objects.filter(student=student).first()
        self.assertIsNotNone(rec, "Manual roll call must persist AttendanceRecord in DB!")
        self.assertEqual(rec.status, AttendanceRecord.Status.PRESENT)
