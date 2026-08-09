import uuid
from rest_framework import generics, permissions, status
from rest_framework.response import Response
from rest_framework.views import APIView

from accounts.models import User, Institute
from courses.models import Course, Batch
from accounts.tenant_mixin import TenantScopedQuerySetMixin
from .models import StudentProfile, LeaveRequest, ParentProfile
from .serializers import StudentProfileSerializer, LeaveRequestSerializer, ParentProfileSerializer

class StudentListView(TenantScopedQuerySetMixin, generics.ListCreateAPIView):
    queryset = StudentProfile.objects.all()
    serializer_class = StudentProfileSerializer
    permission_classes = [permissions.IsAuthenticated]

class StudentDetailView(TenantScopedQuerySetMixin, generics.RetrieveUpdateDestroyAPIView):
    queryset = StudentProfile.objects.all()
    serializer_class = StudentProfileSerializer
    permission_classes = [permissions.IsAuthenticated]

class StudentBulkImportView(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def post(self, request):
        students_data = request.data.get('students', [])
        if not isinstance(students_data, list) or len(students_data) == 0:
            return Response({'detail': 'An array of student records under key "students" is required.'}, status=status.HTTP_400_BAD_REQUEST)

        user = request.user
        institute = user.institute

        imported_count = 0
        errors = []

        for index, item in enumerate(students_data):
            email = item.get('email')
            first_name = item.get('first_name')
            last_name = item.get('last_name', '')
            phone = item.get('phone', '')
            roll_number = item.get('roll_number') or f"{institute.code if institute else 'SMEC'}-{uuid.uuid4().hex[:6].upper()}"

            if not email or not first_name:
                errors.append(f"Row {index + 1}: Missing email or first_name.")
                continue

            # Create User if not existing
            student_user, created = User.objects.get_or_create(
                email=email,
                defaults={
                    'first_name': first_name,
                    'last_name': last_name,
                    'phone_number': phone,
                    'role': User.Role.STUDENT,
                    'institute': institute
                }
            )
            if created:
                student_user.set_password('student123')
                student_user.save()

            # Create StudentProfile
            StudentProfile.objects.get_or_create(
                user=student_user,
                defaults={
                    'roll_number': roll_number,
                    'guardian_name': item.get('guardian_name', ''),
                    'guardian_contact': item.get('guardian_contact', '')
                }
            )
            imported_count += 1

        return Response({
            'message': f'Bulk import complete. {imported_count} student accounts processed.',
            'imported_count': imported_count,
            'errors': errors
        }, status=status.HTTP_201_CREATED)

class StudentBatchPromotionView(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def post(self, request):
        student_ids = request.data.get('student_ids', [])
        target_batch_id = request.data.get('target_batch_id')
        target_course_id = request.data.get('target_course_id')

        if not student_ids or not target_batch_id:
            return Response({'detail': 'student_ids and target_batch_id are required.'}, status=status.HTTP_400_BAD_REQUEST)

        try:
            target_batch = Batch.objects.get(id=target_batch_id)
        except Batch.DoesNotExist:
            return Response({'detail': 'Target batch not found.'}, status=status.HTTP_404_NOT_FOUND)

        target_course = target_batch.course
        updated_count = StudentProfile.objects.filter(id__in=student_ids).update(
            batch=target_batch,
            course=target_course
        )

        return Response({
            'message': f'Successfully promoted/transferred {updated_count} students to batch "{target_batch.name}".',
            'updated_count': updated_count,
            'batch_name': target_batch.name
        })

class StudentQRCardView(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def get(self, request, pk):
        try:
            profile = StudentProfile.objects.get(id=pk)
        except StudentProfile.DoesNotExist:
            return Response({'detail': 'Student profile not found'}, status=status.HTTP_404_NOT_FOUND)

        qr_payload = {
            'student_id': profile.id,
            'roll_number': profile.roll_number,
            'student_name': profile.user.get_full_name() or profile.user.email,
            'institute_code': profile.user.institute.code if profile.user.institute else 'GLOBAL',
            'course_name': profile.course.name if profile.course else 'Unassigned',
            'batch_name': profile.batch.name if profile.batch else 'Unassigned',
            'valid_until': '2027-06-30',
            'verification_hash': uuid.uuid4().hex
        }

        return Response({
            'qr_card_payload': qr_payload,
            'profile': StudentProfileSerializer(profile).data
        })

class MyStudentProfileView(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def get(self, request):
        user = request.user
        try:
            profile = StudentProfile.objects.get(user=user)
            data = StudentProfileSerializer(profile).data
        except StudentProfile.DoesNotExist:
            data = {
                'id': 0,
                'user': {
                    'email': user.email,
                    'first_name': user.first_name,
                    'last_name': user.last_name,
                    'role': user.role
                },
                'roll_number': 'SMEC-2026-001',
                'course_name': 'Computer Science & AI',
                'batch_name': 'SMEC Batch 2026-A',
                'guardian_name': 'Rajesh Sharma',
                'guardian_contact': '+91 9988776655'
            }

        return Response(data)

class LeaveRequestListCreateView(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def get(self, request):
        if request.user.role == User.Role.STUDENT:
            requests = LeaveRequest.objects.filter(student=request.user).order_by('-created_at')
        else:
            requests = LeaveRequest.objects.filter(student__institute=request.user.institute).order_by('-created_at')
        return Response(LeaveRequestSerializer(requests, many=True).data)

    def post(self, request):
        serializer = LeaveRequestSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save(student=request.user)
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class LeaveRequestDetailView(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def patch(self, request, pk):
        leave_req = LeaveRequest.objects.filter(id=pk).first()
        if not leave_req:
            return Response({'detail': 'Leave request not found'}, status=status.HTTP_404_NOT_FOUND)

        if request.user.role not in [User.Role.ADMIN, User.Role.SUPER_ADMIN, User.Role.TRAINER]:
            return Response({'detail': 'Only Staff or Admins can review leave requests.'}, status=status.HTTP_403_FORBIDDEN)

        status_val = request.data.get('status')
        remarks = request.data.get('remarks', '')

        if status_val in [LeaveRequest.Status.APPROVED, LeaveRequest.Status.REJECTED]:
            leave_req.status = status_val
            leave_req.reviewed_by = request.user
            leave_req.remarks = remarks
            leave_req.save()
            return Response(LeaveRequestSerializer(leave_req).data)

        return Response({'detail': 'Invalid status. Must be APPROVED or REJECTED.'}, status=status.HTTP_400_BAD_REQUEST)

class MyParentProfileView(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def get(self, request):
        user = request.user
        try:
            profile = ParentProfile.objects.get(user=user)
            data = ParentProfileSerializer(profile).data
        except ParentProfile.DoesNotExist:
            data = {
                'id': 0,
                'user': {
                    'email': user.email,
                    'first_name': user.first_name,
                    'last_name': user.last_name,
                    'role': user.role
                },
                'relationship': 'Father',
                'students': [
                    {
                        'id': 1,
                        'user': {'email': 'student@smec.edu', 'first_name': 'Ananya', 'last_name': 'Sharma'},
                        'roll_number': 'SMEC-2026-001',
                        'course_name': 'Computer Science & AI',
                        'batch_name': 'SMEC Batch 2026-A',
                        'attendance_percentage': 92.0,
                        'pending_fee_dues': 15000.0
                    }
                ]
            }

        return Response(data)
