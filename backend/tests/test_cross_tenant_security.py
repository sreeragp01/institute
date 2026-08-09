from django.test import TestCase
from rest_framework.test import APIClient
from rest_framework import status
from datetime import date, timedelta
from accounts.models import User, Institute
from courses.models import Course, Batch, Subject
from students.models import StudentProfile, LeaveRequest
from payments.models import FeePayment
from assignments.models import Assignment, Submission

class CrossTenantSecurityAttackTestCase(TestCase):
    def setUp(self):
        self.client = APIClient()

        # Institute A Setup
        self.inst_a = Institute.objects.create(code='INST-A', name='Institute A')
        self.admin_a = User.objects.create_user(
            email='admin@inst-a.edu', password='password123',
            first_name='Admin', last_name='A', role=User.Role.ADMIN, institute=self.inst_a, is_staff=True
        )
        self.trainer_a = User.objects.create_user(
            email='trainer@inst-a.edu', password='password123',
            first_name='Trainer', last_name='A', role=User.Role.TRAINER, institute=self.inst_a
        )
        self.student_a = User.objects.create_user(
            email='student@inst-a.edu', password='password123',
            first_name='Student', last_name='A', role=User.Role.STUDENT, institute=self.inst_a
        )

        # Institute B Setup
        self.inst_b = Institute.objects.create(code='INST-B', name='Institute B')
        self.admin_b = User.objects.create_user(
            email='admin@inst-b.edu', password='password123',
            first_name='Admin', last_name='B', role=User.Role.ADMIN, institute=self.inst_b, is_staff=True
        )
        self.student_b = User.objects.create_user(
            email='student@inst-b.edu', password='password123',
            first_name='Student', last_name='B', role=User.Role.STUDENT, institute=self.inst_b
        )
        self.profile_b = StudentProfile.objects.create(user=self.student_b, roll_number='INST-B-001')

        # Objects belonging to Institute B
        self.payment_b = FeePayment.objects.create(
            institute=self.inst_b, student=self.student_b, amount=50000.00, due_date=date.today()
        )
        self.leave_b = LeaveRequest.objects.create(
            student=self.student_b, from_date=date.today(), to_date=date.today() + timedelta(days=2), reason='Medical'
        )
        self.course_b = Course.objects.create(institute=self.inst_b, code='CS-B', name='Course B')
        self.batch_b = Batch.objects.create(course=self.course_b, name='Batch B', start_date=date.today(), end_date=date.today() + timedelta(days=180))
        self.subject_b = Subject.objects.create(course=self.course_b, code='SUB-B', name='Subject B')
        self.assign_b = Assignment.objects.create(batch=self.batch_b, subject=self.subject_b, trainer=self.admin_b, title='Assign B', due_date=date.today() + timedelta(days=5))
        self.submission_b = Submission.objects.create(assignment=self.assign_b, student=self.student_b, file_url='https://b.com/sub.pdf')

    def test_cross_tenant_student_lookup_blocked(self):
        """Admin A requesting Student B's detail endpoint must return 404 NOT FOUND."""
        self.client.force_authenticate(user=self.admin_a)
        response = self.client.get(f'/api/v1/students/{self.profile_b.id}/')
        self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND, "Cross-tenant student lookup must return 404!")

    def test_cross_tenant_fee_payment_blocked(self):
        """Student A attempting to pay Student B's fee payment ID must return 404 NOT FOUND."""
        self.client.force_authenticate(user=self.student_a)
        response = self.client.post(f'/api/v1/fees/{self.payment_b.id}/pay/')
        self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND, "Cross-tenant fee payment must return 404!")

    def test_cross_tenant_fee_invoice_blocked(self):
        """Student A attempting to view Student B's fee invoice ID must return 404 NOT FOUND."""
        self.client.force_authenticate(user=self.student_a)
        response = self.client.get(f'/api/v1/fees/{self.payment_b.id}/invoice/')
        self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND, "Cross-tenant invoice lookup must return 404!")

    def test_cross_tenant_leave_review_blocked(self):
        """Trainer A attempting to review Student B's leave request must return 404 NOT FOUND."""
        self.client.force_authenticate(user=self.trainer_a)
        response = self.client.patch(f'/api/v1/students/leave-requests/{self.leave_b.id}/', {'status': 'APPROVED'})
        self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND, "Cross-tenant leave approval must return 404!")

    def test_cross_tenant_grade_submission_blocked(self):
        """Trainer A attempting to grade Student B's assignment submission must return 404 NOT FOUND."""
        self.client.force_authenticate(user=self.trainer_a)
        response = self.client.patch(f'/api/v1/assignments/submissions/{self.submission_b.id}/grade/', {'grade': 'A+'})
        self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND, "Cross-tenant assignment grading must return 404!")
