import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../student/presentation/screens/student_dashboard_screen.dart';
import '../../../student/presentation/screens/student_profile_screen.dart';
import '../../../attendance/presentation/screens/attendance_dashboard_screen.dart';
import '../../../assignments/presentation/screens/assignment_list_screen.dart';
import '../../../fees/presentation/screens/fee_status_screen.dart';
import '../../../staff/presentation/screens/staff_dashboard_screen.dart';
import '../../../staff/presentation/screens/manual_roll_call_screen.dart';
import '../../../attendance/presentation/screens/qr_generator_screen.dart';
import '../../../admin/presentation/screens/admin_dashboard_screen.dart';
import '../../../admin/presentation/screens/super_admin_console_screen.dart';

class MainShellScreen extends ConsumerStatefulWidget {
  const MainShellScreen({super.key});

  @override
  ConsumerState<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends ConsumerState<MainShellScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final role = authState.role ?? 'STUDENT';

    final List<Widget> studentTabs = [
      const StudentDashboardScreen(),
      const AttendanceDashboardScreen(),
      const AssignmentListScreen(),
      const FeeStatusScreen(),
      const StudentProfileScreen(),
    ];

    final List<Widget> staffTabs = [
      const StaffDashboardScreen(),
      const QRGeneratorScreen(),
      const ManualRollCallScreen(),
      const AssignmentListScreen(),
    ];

    final List<Widget> adminTabs = [
      const AdminDashboardScreen(),
      const SuperAdminConsoleScreen(),
      const AttendanceDashboardScreen(),
      const FeeStatusScreen(),
    ];

    List<Widget> activeTabs = studentTabs;
    if (role == 'TRAINER') activeTabs = staffTabs;
    if (role == 'ADMIN' || role == 'SUPER_ADMIN') activeTabs = adminTabs;

    final safeIndex = _currentIndex < activeTabs.length ? _currentIndex : 0;

    return Scaffold(
      body: IndexedStack(
        index: safeIndex,
        children: activeTabs,
      ),
      floatingActionButton: (role == 'STUDENT')
          ? FloatingActionButton(
              backgroundColor: AppColors.cyberCyan,
              elevation: 8,
              onPressed: () => context.push('/qr-scanner'),
              child: const Icon(Icons.qr_code_scanner_rounded, color: Colors.black, size: 28),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.darkCardSurface,
          border: Border(top: BorderSide(color: AppColors.glassBorder, width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: safeIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: AppColors.darkCardSurface,
          selectedItemColor: AppColors.cyberCyan,
          unselectedItemColor: AppColors.textMuted,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: AppTypography.microTag(color: AppColors.cyberCyan),
          unselectedLabelStyle: AppTypography.microTag(color: AppColors.textMuted),
          items: _buildNavItems(role),
        ),
      ),
    );
  }

  List<BottomNavigationBarItem> _buildNavItems(String role) {
    if (role == 'TRAINER') {
      return const [
        BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.qr_code_2_rounded), label: 'QR Generator'),
        BottomNavigationBarItem(icon: Icon(Icons.how_to_reg_rounded), label: 'Manual Roll'),
        BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), label: 'Grading'),
      ];
    } else if (role == 'ADMIN' || role == 'SUPER_ADMIN') {
      return const [
        BottomNavigationBarItem(icon: Icon(Icons.dashboard_rounded), label: 'Overview'),
        BottomNavigationBarItem(icon: Icon(Icons.admin_panel_settings_rounded), label: 'Tenants'),
        BottomNavigationBarItem(icon: Icon(Icons.event_available_rounded), label: 'Attendance'),
        BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_rounded), label: 'Fees'),
      ];
    }

    // Default Student Navigation Items
    return const [
      BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
      BottomNavigationBarItem(icon: Icon(Icons.event_available_rounded), label: 'Attendance'),
      BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), label: 'Tasks'),
      BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_rounded), label: 'Fees'),
      BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
    ];
  }
}
