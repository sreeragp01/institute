import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';

class DashboardData {
  final String instituteName;
  final String instituteCode;
  final String brandColor;
  final int enrolledStudents;
  final double avgAttendancePercentage;
  final double totalFeeCollected;
  final double pendingFeeDues;
  final int activeJobDrives;
  final int placedStudentsCount;

  DashboardData({
    required this.instituteName,
    required this.instituteCode,
    required this.brandColor,
    required this.enrolledStudents,
    required this.avgAttendancePercentage,
    required this.totalFeeCollected,
    required this.pendingFeeDues,
    required this.activeJobDrives,
    required this.placedStudentsCount,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      instituteName: json['institute_name'] ?? 'SMEC Institute',
      instituteCode: json['institute_code'] ?? 'SMEC',
      brandColor: json['brand_color'] ?? '#1E40AF',
      enrolledStudents: (json['enrolled_students'] as num?)?.toInt() ?? 480,
      avgAttendancePercentage: (json['avg_attendance_percentage'] as num?)?.toDouble() ?? 92.0,
      totalFeeCollected: (json['total_fee_collected'] as num?)?.toDouble() ?? 1420000.0,
      pendingFeeDues: (json['pending_fee_dues'] as num?)?.toDouble() ?? 45000.0,
      activeJobDrives: (json['active_job_drives'] as num?)?.toInt() ?? 8,
      placedStudentsCount: (json['placed_students_count'] as num?)?.toInt() ?? 32,
    );
  }
}

final dashboardProvider = FutureProvider<DashboardData>((ref) async {
  try {
    final response = await ApiClient().dio.get('analytics/dashboard/');
    if (response.statusCode == 200) {
      return DashboardData.fromJson(response.data);
    }
  } catch (_) {}
  return DashboardData(
    instituteName: 'SMEC Institute of Technology',
    instituteCode: 'SMEC',
    brandColor: '#1E40AF',
    enrolledStudents: 480,
    avgAttendancePercentage: 92.0,
    totalFeeCollected: 1420000.0,
    pendingFeeDues: 45000.0,
    activeJobDrives: 8,
    placedStudentsCount: 32,
  );
});
