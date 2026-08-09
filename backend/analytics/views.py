from rest_framework import views, permissions
from rest_framework.response import Response
from accounts.models import User
from attendance.models import AttendanceRecord
from payments.models import FeePayment
from placements.models import PlacementDrive, JobApplication

class DashboardAnalyticsView(views.APIView):
    permission_classes = [permissions.IsAuthenticated]

    def get(self, request):
        user = request.user
        inst = user.institute

        if user.role == 'SUPER_ADMIN':
            enrolled_students = User.objects.filter(role=User.Role.STUDENT).count()
            records = AttendanceRecord.objects.all()
            total_records = records.count()
            present_records = records.filter(status=AttendanceRecord.Status.PRESENT).count()
            avg_attendance = round((present_records / total_records * 100), 1) if total_records > 0 else 0.0

            paid_fees = sum([p.amount for p in FeePayment.objects.filter(status=FeePayment.Status.PAID)])
            pending_fees = sum([p.amount for p in FeePayment.objects.filter(status=FeePayment.Status.PENDING)])

            active_drives = PlacementDrive.objects.count()
            placed_students = JobApplication.objects.filter(status=JobApplication.ApplicationStatus.SELECTED).count()

            inst_name = "Global System Overview"
            inst_code = "GLOBAL"
            brand_color = "#1E40AF"
        else:
            enrolled_students = User.objects.filter(institute=inst, role=User.Role.STUDENT).count()
            records = AttendanceRecord.objects.filter(session__institute=inst)
            total_records = records.count()
            present_records = records.filter(status=AttendanceRecord.Status.PRESENT).count()
            avg_attendance = round((present_records / total_records * 100), 1) if total_records > 0 else 0.0

            paid_fees = sum([p.amount for p in FeePayment.objects.filter(institute=inst, status=FeePayment.Status.PAID)])
            pending_fees = sum([p.amount for p in FeePayment.objects.filter(institute=inst, status=FeePayment.Status.PENDING)])

            active_drives = PlacementDrive.objects.filter(institute=inst, status=PlacementDrive.Status.OPEN).count() if hasattr(PlacementDrive, 'Status') else PlacementDrive.objects.filter(institute=inst).count()
            placed_students = JobApplication.objects.filter(drive__institute=inst, status=JobApplication.ApplicationStatus.SELECTED).count()

            inst_name = inst.name if inst else "Institute"
            inst_code = inst.code if inst else "SMEC"
            brand_color = inst.primary_color if inst else "#1E40AF"

        return Response({
            'institute_name': inst_name,
            'institute_code': inst_code,
            'brand_color': brand_color,
            'enrolled_students': enrolled_students,
            'avg_attendance_percentage': avg_attendance,
            'total_fee_collected': float(paid_fees),
            'pending_fee_dues': float(pending_fees),
            'active_job_drives': active_drives,
            'placed_students_count': placed_students,
        })
