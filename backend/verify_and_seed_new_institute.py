import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'smec_backend.settings')
django.setup()

from datetime import date, timedelta
from rest_framework.test import APIClient
from accounts.models import User, Institute, SubscriptionPlan
from courses.models import Course, Batch
from students.models import StudentProfile
from payments.models import FeePayment

def run_verification():
    print("====================================================")
    print("[SUCCESS] SMEC Connect Multi-Tenant Verification & Seed")
    print("====================================================\n")

    # 1. Fetch or Create APEX Institute
    plan_pro, _ = SubscriptionPlan.objects.get_or_create(
        tier=SubscriptionPlan.Tier.PROFESSIONAL,
        defaults={'name': 'Professional Plan', 'price_per_month': 299.00, 'max_students': 500, 'max_staff': 50, 'ai_credits_monthly': 5000}
    )

    apex, created = Institute.objects.get_or_create(
        code='APEX',
        defaults={
            'name': 'Apex Learning Academy',
            'primary_color': '#7C3AED',
            'accent_color': '#F59E0B',
            'subscription_status': Institute.SubscriptionStatus.ACTIVE,
            'plan': plan_pro,
            'website': 'https://apexlearning.com',
            'contact_email': 'info@apexlearning.com',
            'contact_phone': '+91 9123456789',
            'address': 'Kochi Cyber Hub, Floor 4, Kochi'
        }
    )
    print(f"[INSTITUTE] {apex.name} (Code: {apex.code}) [{'Created' if created else 'Existing'}]")

    # 2. Create APEX Admin
    apex_admin, _ = User.objects.get_or_create(
        email='admin@apex.edu',
        defaults={'first_name': 'Apex', 'last_name': 'Admin', 'role': User.Role.ADMIN, 'institute': apex, 'is_staff': True}
    )
    apex_admin.set_password('admin123')
    apex_admin.save()
    print(f"[ADMIN] APEX Admin: {apex_admin.email} (Role: {apex_admin.role}, Institute: {apex.code})")

    # 3. Create APEX Trainer
    apex_trainer, _ = User.objects.get_or_create(
        email='trainer@apex.edu',
        defaults={'first_name': 'Vikram', 'last_name': 'Sethi', 'role': User.Role.TRAINER, 'institute': apex}
    )
    apex_trainer.set_password('trainer123')
    apex_trainer.save()
    print(f"[TRAINER] APEX Trainer: {apex_trainer.email} (Role: {apex_trainer.role}, Institute: {apex.code})")

    # 4. Create APEX Student
    apex_student, _ = User.objects.get_or_create(
        email='student@apex.edu',
        defaults={'first_name': 'Rohan', 'last_name': 'Verma', 'role': User.Role.STUDENT, 'institute': apex}
    )
    apex_student.set_password('student123')
    apex_student.save()
    print(f"[STUDENT] APEX Student: {apex_student.email} (Role: {apex_student.role}, Institute: {apex.code})")

    # 5. Create APEX Course, Batch & Student Profile
    apex_course, _ = Course.objects.get_or_create(
        institute=apex, code='AI-900',
        defaults={'name': 'Gen AI & Robotics Engineering', 'duration_months': 12}
    )

    apex_batch, _ = Batch.objects.get_or_create(
        course=apex_course, name='APEX Robotics Batch 2026-X',
        defaults={'start_date': date.today() - timedelta(days=30), 'end_date': date.today() + timedelta(days=330), 'trainer': apex_trainer}
    )

    apex_profile, _ = StudentProfile.objects.get_or_create(
        user=apex_student,
        defaults={'roll_number': 'APEX-2026-101', 'course': apex_course, 'batch': apex_batch, 'guardian_name': 'Suresh Verma', 'guardian_contact': '+91 9112233445'}
    )
    print(f"[PROFILE] APEX Student Profile: Roll {apex_profile.roll_number}, Course {apex_course.name}")

    # 6. Create APEX Fee Payment
    apex_fee, _ = FeePayment.objects.get_or_create(
        institute=apex,
        student=apex_student,
        amount=60000.00,
        due_date=date.today() + timedelta(days=30),
        defaults={'status': FeePayment.Status.PENDING}
    )
    print(f"[FEE] APEX Fee Record: Amount Rs.{apex_fee.amount} for {apex_student.email}")

    print("\n----------------------------------------------------")
    print("RUNNING AUTOMATED MULTI-TENANT ISOLATION CHECKS")
    print("----------------------------------------------------\n")

    client = APIClient()

    # TEST 1: Authenticate as APEX Admin -> GET /api/v1/students/
    client.force_authenticate(user=apex_admin)
    res_apex_admin = client.get('/api/v1/students/')
    print(f"[TEST 1] APEX Admin GET /api/v1/students/")
    print(f"   Status Code: {res_apex_admin.status_code}")
    print(f"   Count of students returned: {len(res_apex_admin.data)}")
    for st in res_apex_admin.data:
        print(f"   - Student: {st.get('user', {}).get('email')} | Roll: {st.get('roll_number')}")
    assert len(res_apex_admin.data) == 1, "APEX Admin should see exactly 1 APEX student!"
    assert res_apex_admin.data[0]['user']['email'] == 'student@apex.edu', "APEX Admin must only see student@apex.edu!"
    print("   STATUS: PASSED! Clean isolation verified for APEX Admin.")

    # TEST 2: Authenticate as SMEC Admin -> GET /api/v1/students/
    smec_admin = User.objects.get(email='admin@smec.edu')
    client.force_authenticate(user=smec_admin)
    res_smec_admin = client.get('/api/v1/students/')
    print(f"\n[TEST 2] SMEC Admin GET /api/v1/students/")
    print(f"   Status Code: {res_smec_admin.status_code}")
    print(f"   Count of students returned: {len(res_smec_admin.data)}")
    for st in res_smec_admin.data:
        print(f"   - Student: {st.get('user', {}).get('email')} | Roll: {st.get('roll_number')}")
    assert len(res_smec_admin.data) == 1, "SMEC Admin should see exactly 1 SMEC student!"
    assert res_smec_admin.data[0]['user']['email'] == 'student@smec.edu', "SMEC Admin must only see student@smec.edu!"
    print("   STATUS: PASSED! Clean isolation verified for SMEC Admin.")

    # TEST 3: Authenticate as APEX Student -> GET /api/v1/fees/
    client.force_authenticate(user=apex_student)
    res_apex_fee = client.get('/api/v1/fees/')
    print(f"\n[TEST 3] APEX Student GET /api/v1/fees/")
    print(f"   Status Code: {res_apex_fee.status_code}")
    print(f"   Fee payments returned: {len(res_apex_fee.data)}")
    for fee in res_apex_fee.data:
        print(f"   - Fee ID: {fee.get('id')} | Amount: Rs.{fee.get('amount')} | Student: {fee.get('student_name')}")
    assert len(res_apex_fee.data) >= 1, "APEX Student should see their APEX fee payments!"
    assert all(float(fee['amount']) == 60000.0 for fee in res_apex_fee.data), "All APEX student fees must be Rs.60000!"
    print("   STATUS: PASSED! Clean isolation verified for APEX Student.")

    # TEST 4: Authenticate as SMEC Student -> GET /api/v1/fees/
    smec_student = User.objects.get(email='student@smec.edu')
    client.force_authenticate(user=smec_student)
    res_smec_fee = client.get('/api/v1/fees/')
    print(f"\n[TEST 4] SMEC Student GET /api/v1/fees/")
    print(f"   Status Code: {res_smec_fee.status_code}")
    print(f"   Fee payments returned: {len(res_smec_fee.data)}")
    for fee in res_smec_fee.data:
        print(f"   - Fee ID: {fee.get('id')} | Amount: Rs.{fee.get('amount')} | Student: {fee.get('student_name')}")
    assert len(res_smec_fee.data) >= 1, "SMEC Student should see their SMEC fee payments!"
    assert all(float(fee['amount']) == 45000.0 for fee in res_smec_fee.data), "All SMEC student fees must be Rs.45000!"
    print("   STATUS: PASSED! Clean isolation verified for SMEC Student.")

    print("\n====================================================")
    print("ALL 4 MULTI-TENANT ISOLATION CHECKS PASSED 100%!")
    print("====================================================")

if __name__ == '__main__':
    run_verification()
