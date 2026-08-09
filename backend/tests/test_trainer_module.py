from django.test import TestCase
from rest_framework.test import APIClient
from rest_framework import status
from datetime import date
from accounts.models import User, Institute
from courses.models import Course, Batch, Subject
from staff.models import TrainerProfile
from attendance.models import AttendanceSession
from assignments.models import Assignment, Submission

class TrainerModuleTestCase(TestCase):
    def setUp(self):
        self.client = APIClient()
        self.institute = Institute.objects.create(code='SMEC', name='SMEC Tech')
        self.course = Course.objects.create(institute=self.institute, code='CS-101', name='Computer Science')
        self.batch = Batch.objects.create(course=self.course, name='Batch 2026', start_date=date.today(), end_date=date.today())
        self.subject = Subject.objects.create(course=self.course, code='PY-201', name='Python Programming')

        self.trainer_user = User.objects.create_user(
            email='trainer@smec.edu', password='password123',
            first_name='Rahul', last_name='Nair',
            role=User.Role.TRAINER, institute=self.institute
        )
        self.trainer_profile = TrainerProfile.objects.create(
            user=self.trainer_user, employee_id='EMP-FAC-1002',
            specialization='Computer Science'
        )

        self.student_user = User.objects.create_user(
            email='student@smec.edu', password='password123',
            first_name='Ananya', last_name='Sharma',
            role=User.Role.STUDENT, institute=self.institute
        )

    def test_get_my_trainer_profile(self):
        self.client.force_authenticate(user=self.trainer_user)
        response = self.client.get('/api/v1/staff/my-profile/')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['employee_id'], 'EMP-FAC-1002')

    def test_trainer_generate_qr_session(self):
        self.client.force_authenticate(user=self.trainer_user)
        response = self.client.post('/api/v1/attendance/qr-session/', {
            'subject_id': self.subject.id,
            'latitude': 9.9312,
            'longitude': 76.2673
        })
        self.assertIn(response.status_code, [status.HTTP_200_OK, status.HTTP_201_CREATED])
        self.assertIn('qr_code_secret', response.data)
        self.assertIn('session_id', response.data)

    def test_trainer_manual_roll_call(self):
        self.client.force_authenticate(user=self.trainer_user)
        response = self.client.post('/api/v1/attendance/manual-roll-call/', {
            'session_id': 42,
            'records': [
                {'student_id': self.student_user.id, 'status': 'PRESENT'}
            ]
        }, format='json')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['marked_count'], 1)

    def test_trainer_grade_submission(self):
        assignment = Assignment.objects.create(
            batch=self.batch, subject=self.subject,
            trainer=self.trainer_user, title='Transformer Model Architecture',
            description='Build BERT encoder in PyTorch', due_date='2026-08-15T10:00:00Z'
        )
        submission = Submission.objects.create(
            assignment=assignment, student=self.student_user,
            file_url='https://github.com/student/bert-implementation'
        )

        self.client.force_authenticate(user=self.trainer_user)
        response = self.client.patch(f'/api/v1/assignments/submissions/{submission.id}/grade/', {
            'grade': 'A+',
            'feedback': 'Excellent clean implementation!'
        })
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['grade'], 'A+')
