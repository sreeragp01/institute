from django.test import TestCase
from rest_framework.test import APIClient
from rest_framework import status
from accounts.models import User, Institute
from attendance.models import AttendanceSession, AttendanceRecord

class AttendanceSecurityTestCase(TestCase):
    def setUp(self):
        self.client = APIClient()
        self.institute = Institute.objects.create(code='SMEC', name='SMEC Tech')
        self.student = User.objects.create_user(
            email='student@smec.edu', password='password123',
            role=User.Role.STUDENT, institute=self.institute
        )

    def test_gps_geofence_out_of_range(self):
        self.client.force_authenticate(user=self.student)
        # Scan from Paris coordinates (far away from campus)
        response = self.client.post('/api/v1/attendance/gps-mark/', {
            'latitude': 48.8566,
            'longitude': 2.3522
        })
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertIn('Geofence verification failed', response.data['detail'])

    def test_gps_geofence_valid(self):
        self.client.force_authenticate(user=self.student)
        # Scan from campus coordinates (Kochi)
        response = self.client.post('/api/v1/attendance/gps-mark/', {
            'latitude': 9.9312,
            'longitude': 76.2673
        })
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['status'], 'PRESENT')
