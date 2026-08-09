from django.test import TestCase
from rest_framework.test import APIClient
from rest_framework import status
from accounts.models import User, Institute
from courses.models import Course
from students.models import StudentProfile, ParentProfile

class ParentModuleTestCase(TestCase):
    def setUp(self):
        self.client = APIClient()
        self.institute = Institute.objects.create(code='SMEC', name='SMEC Tech')
        self.course = Course.objects.create(institute=self.institute, code='CS-101', name='Computer Science')

        self.student_user = User.objects.create_user(
            email='student@smec.edu', password='password123',
            first_name='Ananya', last_name='Sharma',
            role=User.Role.STUDENT, institute=self.institute
        )
        self.student_profile = StudentProfile.objects.create(
            user=self.student_user, roll_number='SMEC-2026-001', course=self.course
        )

        self.parent_user = User.objects.create_user(
            email='parent@smec.edu', password='password123',
            first_name='Rajesh', last_name='Sharma',
            role=User.Role.PARENT, institute=self.institute
        )
        self.parent_profile = ParentProfile.objects.create(
            user=self.parent_user, relationship='Father'
        )
        self.parent_profile.students.add(self.student_profile)

    def test_get_my_parent_profile(self):
        self.client.force_authenticate(user=self.parent_user)
        response = self.client.get('/api/v1/students/parent-profile/')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['relationship'], 'Father')
        self.assertGreaterEqual(len(response.data['students']), 1)
