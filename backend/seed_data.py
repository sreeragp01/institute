import os
import django
from datetime import date, timedelta

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'smec_backend.settings')
django.setup()

from accounts.models import User, Institute, SubscriptionPlan
from courses.models import Course, Batch, Subject, Timetable
from students.models import StudentProfile, ParentProfile
from payments.models import FeePayment
from notifications.models import Announcement

from certificates.models import IssuedCertificate
from placements.models import Company, PlacementDrive
from examinations.models import Exam, Question
from datetime import datetime

def seed():
    # 0. Create Subscription Plans
    plan_trial, _ = SubscriptionPlan.objects.get_or_create(
        tier=SubscriptionPlan.Tier.FREE_TRIAL,
        defaults={'name': '14-Day Free Trial', 'price_per_month': 0.00, 'max_students': 50, 'max_staff': 10, 'ai_credits_monthly': 100}
    )
    plan_pro, _ = SubscriptionPlan.objects.get_or_create(
        tier=SubscriptionPlan.Tier.PROFESSIONAL,
        defaults={'name': 'Professional Plan', 'price_per_month': 299.00, 'max_students': 500, 'max_staff': 50, 'ai_credits_monthly': 5000}
    )

    # 1. Create Institute 1: SMEC
    smec, _ = Institute.objects.get_or_create(
        code='SMEC',
        defaults={
            'name': 'SMEC Institute of Technology',
            'primary_color': '#1E40AF', # Deep Blue
            'accent_color': '#06B6D4', # Cyber Cyan
            'subscription_status': Institute.SubscriptionStatus.ACTIVE,
            'plan': plan_pro,
            'website': 'https://smec.edu',
            'contact_email': 'contact@smec.edu',
            'contact_phone': '+91 9876543210',
            'address': 'Main Campus, Tech Park Road, Ernakulam, Kerala'
        }
    )

    # 2. Create Institute 2: APEX
    apex, _ = Institute.objects.get_or_create(
        code='APEX',
        defaults={
            'name': 'Apex Learning Academy',
            'primary_color': '#7C3AED', # Electric Purple
            'accent_color': '#F59E0B', # Gold
            'subscription_status': Institute.SubscriptionStatus.ACTIVE,
            'plan': plan_pro,
            'website': 'https://apexlearning.com',
            'contact_email': 'info@apexlearning.com',
            'contact_phone': '+91 9123456789',
            'address': 'Kochi Cyber Hub, Floor 4, Kochi'
        }
    )

    # 3. Create Super Admin (Global Platform Admin)
    super_admin, _ = User.objects.get_or_create(
        email='superadmin@smecconnect.com',
        defaults={'first_name': 'Platform', 'last_name': 'SuperAdmin', 'role': User.Role.SUPER_ADMIN, 'is_staff': True, 'is_superuser': True}
    )
    super_admin.set_password('superadmin123')
    super_admin.save()

    # 4. Create SMEC Admin
    smec_admin, _ = User.objects.get_or_create(
        email='admin@smec.edu',
        defaults={'first_name': 'SMEC', 'last_name': 'Admin', 'role': User.Role.ADMIN, 'institute': smec, 'is_staff': True}
    )
    smec_admin.set_password('admin123')
    smec_admin.save()

    # 5. Create SMEC Student, Trainer & Parent
    smec_trainer, _ = User.objects.get_or_create(
        email='trainer@smec.edu',
        defaults={'first_name': 'Rahul', 'last_name': 'Nair', 'role': User.Role.TRAINER, 'institute': smec}
    )
    smec_trainer.set_password('trainer123')
    smec_trainer.save()

    smec_student, _ = User.objects.get_or_create(
        email='student@smec.edu',
        defaults={'first_name': 'Ananya', 'last_name': 'Sharma', 'role': User.Role.STUDENT, 'institute': smec}
    )
    smec_student.set_password('student123')
    smec_student.save()

    c_smec, _ = Course.objects.get_or_create(
        institute=smec, code='CS-101',
        defaults={'name': 'Computer Science & AI', 'duration_months': 6}
    )
    b_smec, _ = Batch.objects.get_or_create(
        course=c_smec, name='SMEC Batch 2026-A',
        defaults={'start_date': date.today() - timedelta(days=60), 'end_date': date.today() + timedelta(days=120), 'trainer': smec_trainer}
    )

    sub_python, _ = Subject.objects.get_or_create(
        course=c_smec, code='PY-201',
        defaults={'name': 'Python Programming & AI Basics'}
    )
    sub_ds, _ = Subject.objects.get_or_create(
        course=c_smec, code='DS-202',
        defaults={'name': 'Data Structures & Algorithms'}
    )

    st_prof, _ = StudentProfile.objects.get_or_create(
        user=smec_student,
        defaults={'roll_number': 'SMEC-2026-001', 'course': c_smec, 'batch': b_smec, 'guardian_name': 'Rajesh Sharma', 'guardian_contact': '+91 9988776655'}
    )

    smec_parent, _ = User.objects.get_or_create(
        email='parent@smec.edu',
        defaults={'first_name': 'Rajesh', 'last_name': 'Sharma', 'role': User.Role.PARENT, 'institute': smec}
    )
    smec_parent.set_password('parent123')
    smec_parent.save()

    p_prof, _ = ParentProfile.objects.get_or_create(user=smec_parent)
    p_prof.students.add(st_prof)

    # 6. Seed Attendance History across 10 days
    from attendance.models import AttendanceSession, AttendanceRecord
    for i in range(10):
        day = date.today() - timedelta(days=i)
        if day.weekday() < 5: # Weekdays only
            session, _ = AttendanceSession.objects.get_or_create(
                institute=smec, batch=b_smec, subject=sub_python, date=day,
                defaults={'trainer': smec_trainer, 'qr_code_secret': f'SESSION-QR-{i}'}
            )
            AttendanceRecord.objects.get_or_create(
                session=session, student=smec_student,
                defaults={'status': AttendanceRecord.Status.PRESENT if i % 4 != 0 else AttendanceRecord.Status.ABSENT}
            )

    # 7. Seed Assignments & Submissions
    from assignments.models import Assignment, Submission
    assign_1, _ = Assignment.objects.get_or_create(
        batch=b_smec, subject=sub_python, title='Neural Network Pipeline Implementation',
        defaults={
            'trainer': smec_trainer,
            'description': 'Build a simple multi-layer perceptron using NumPy and evaluate accuracy.',
            'due_date': datetime.now() + timedelta(days=5),
            'file_url': 'https://smec.edu/assignments/nn_pipeline.pdf'
        }
    )
    Submission.objects.get_or_create(
        assignment=assign_1, student=smec_student,
        defaults={'file_url': 'https://github.com/ananya/smec_nn_assignment', 'grade': 'A+', 'feedback': 'Outstanding code modularity and documentation.'}
    )

    # 8. Seed Announcements & Notifications
    from notifications.models import Announcement, Event, Notification
    Announcement.objects.get_or_create(
        institute=smec, title='Annual Tech Symposium & Hackathon 2026',
        defaults={'body': 'Join us on Friday for the SMEC Innovation Expo! Projects will be presented to industry leaders.', 'posted_by': smec_admin}
    )
    Event.objects.get_or_create(
        institute=smec, title='AI Career Guidance & Campus Recruitment Drive',
        defaults={'description': 'Top AI startups and MNCs will conduct interviews.', 'event_date': datetime.now() + timedelta(days=7), 'venue': 'SMEC Auditorium', 'organizer': 'Placement Cell'}
    )
    Notification.objects.get_or_create(
        user=smec_student, title='Attendance Alert: 92% Monthly Attendance',
        defaults={'message': 'Great job Ananya! Your attendance is above the required threshold of 85%.', 'channel': Notification.Channel.IN_APP}
    )

    # 9. Seed Payments & Certificates
    FeePayment.objects.get_or_create(
        institute=smec,
        student=smec_student,
        amount=45000.00,
        due_date=date.today() + timedelta(days=15),
        defaults={'status': FeePayment.Status.PENDING}
    )

    IssuedCertificate.objects.get_or_create(
        verification_code='VERIFY-SMEC-2026',
        defaults={
            'institute': smec,
            'student': smec_student,
            'course': c_smec,
            'certificate_number': 'CERT-SMEC-8899',
            'certificate_type': IssuedCertificate.CertType.COMPLETION
        }
    )

    comp, _ = Company.objects.get_or_create(institute=smec, name='TechCorp AI Labs', defaults={'location': 'Kochi Cyberpark'})
    PlacementDrive.objects.get_or_create(
        institute=smec,
        company=comp,
        title='Junior AI & Machine Learning Engineer',
        defaults={'package_lpa': 8.50, 'drive_date': date.today() + timedelta(days=20)}
    )

    exam, _ = Exam.objects.get_or_create(
        institute=smec,
        course=c_smec,
        title='Python & Data Science Mid-Term Exam',
        defaults={'scheduled_at': datetime.now(), 'duration_minutes': 60, 'total_marks': 100, 'pass_marks': 40}
    )

    # 10. Seed Admissions, Support Tickets & Audit Logs
    from admissions.models import Enquiry, LeadSource, EnquiryStatus
    from support.models import SupportTicket, TicketCategory, TicketPriority, TicketStatus
    from audit.models import AuditLog

    Enquiry.objects.get_or_create(
        institute=smec, candidate_name='Rohan Kumar', email='rohan@gmail.com', phone_number='+91 9876001122',
        defaults={'interested_course': 'Computer Science & AI', 'source': LeadSource.WEBSITE, 'status': EnquiryStatus.NEW, 'notes': 'Inquired about batch timings and scholarship eligibility.'}
    )

    SupportTicket.objects.get_or_create(
        institute=smec, created_by=smec_student, subject='Fee Payment Receipt Inquiry',
        defaults={'category': TicketCategory.FEE_BILLING, 'priority': TicketPriority.MEDIUM, 'status': TicketStatus.OPEN, 'description': 'Requesting digital invoice receipt for initial admission fee.'}
    )

    AuditLog.objects.get_or_create(
        institute=smec, actor=smec_admin, action='UPDATED_INSTITUTE_SETTINGS',
        defaults={'target_model': 'Institute', 'details': 'Updated primary brand colors and contact phone.', 'ip_address': '127.0.0.1'}
    )

    print("SaaS Modules Data (Admissions CRM, Support Tickets, Audit Logs, Multi-Role Attendance, Assignments, Exams) seeded successfully!")

if __name__ == '__main__':
    seed()


