from django.test import TestCase
from rest_framework.test import APIClient
from rest_framework import status
from datetime import date
from accounts.models import User, Institute
from courses.models import Course, Batch
from students.models import StudentProfile, LeaveRequest

class StudentModuleTestCase(TestCase):
    def setUp(self):
        self.client = APIClient()
        self.institute = Institute.objects.create(code='SMEC', name='SMEC Tech')
        self.course = Course.objects.create(institute=self.institute, code='CS-101', name='Computer Science')
        self.batch = Batch.objects.create(
            course=self.course, name='Batch 2026',
            start_date=date.today(), end_date=date.today()
        )

        self.student_user = User.objects.create_user(
            email='student@smec.edu', password='password123',
            first_name='Ananya', last_name='Sharma',
            role=User.Role.STUDENT, institute=self.institute
        )
        self.student_profile = StudentProfile.objects.create(
            user=self.student_user, roll_number='SMEC-2026-001',
            course=self.course, batch=self.batch
        )

        self.trainer_user = User.objects.create_user(
            email='trainer@smec.edu', password='password123',
            role=User.Role.TRAINER, institute=self.institute
        )

    def test_get_my_student_profile(self):
        self.client.force_authenticate(user=self.student_user)
        response = self.client.get('/api/v1/students/my-profile/')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['roll_number'], 'SMEC-2026-001')
        self.assertEqual(response.data['course_name'], 'Computer Science')

    def test_student_qr_card_payload(self):
        self.client.force_authenticate(user=self.student_user)
        response = self.client.get(f'/api/v1/students/{self.student_profile.id}/qr-card/')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIn('qr_card_payload', response.data)
        self.assertEqual(response.data['qr_card_payload']['roll_number'], 'SMEC-2026-001')

    def test_leave_request_submission_and_approval(self):
        # 1. Student submits leave request
        self.client.force_authenticate(user=self.student_user)
        response = self.client.post('/api/v1/students/leave-requests/', {
            'from_date': str(date.today()),
            'to_date': str(date.today()),
            'reason': 'Attending hackathon event.'
        })
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        leave_id = response.data['id']

        # 2. Trainer reviews and approves leave request
        self.client.force_authenticate(user=self.trainer_user)
        review_resp = self.client.patch(f'/api/v1/students/leave-requests/{leave_id}/', {
            'status': 'APPROVED',
            'remarks': 'Approved by class instructor.'
        })
        self.assertEqual(review_resp.status_code, status.HTTP_200_OK)
        self.assertEqual(review_resp.data['status'], 'APPROVED')
