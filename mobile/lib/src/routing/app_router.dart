import 'package:go_router/go_router.dart';
import '../features/auth/presentation/screens/splash_screen.dart';
import '../features/auth/presentation/screens/welcome_screen.dart';
import '../features/auth/presentation/screens/onboarding_screen.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/role_selection_screen.dart';
import '../features/auth/presentation/screens/institute_registration_screen.dart';
import '../features/main_shell/presentation/screens/main_shell_screen.dart';
import '../features/student/presentation/screens/student_dashboard_screen.dart';
import '../features/student/presentation/screens/student_profile_screen.dart';
import '../features/staff/presentation/screens/staff_dashboard_screen.dart';
import '../features/staff/presentation/screens/manual_roll_call_screen.dart';
import '../features/admin/presentation/screens/admin_dashboard_screen.dart';
import '../features/admin/presentation/screens/super_admin_console_screen.dart';
import '../features/parent/presentation/screens/parent_dashboard_screen.dart';
import '../features/attendance/presentation/screens/attendance_dashboard_screen.dart';
import '../features/attendance/presentation/screens/monthly_attendance_screen.dart';
import '../features/attendance/presentation/screens/qr_generator_screen.dart';
import '../features/attendance/presentation/screens/qr_scanner_screen.dart';
import '../features/ai_assistant/presentation/screens/ai_chatbot_screen.dart';
import '../features/ai_assistant/presentation/screens/ai_quiz_screen.dart';
import '../features/ai_assistant/presentation/screens/ai_study_assistant_screen.dart';
import '../features/fees/presentation/screens/fee_status_screen.dart';
import '../features/assignments/presentation/screens/assignment_list_screen.dart';
import '../features/analytics/presentation/screens/placement_drives_screen.dart';
import '../features/student/presentation/screens/leave_request_screen.dart';
import '../features/student/presentation/screens/student_qr_card_screen.dart';
import '../features/certificates/presentation/screens/certificate_verification_screen.dart';
import '../features/examinations/presentation/screens/exam_take_screen.dart';


import '../features/notifications/presentation/screens/notification_center_screen.dart';
import '../features/settings/presentation/screens/settings_screen.dart';
import '../features/settings/presentation/screens/legal_document_screen.dart';
import '../features/fees/presentation/screens/invoice_receipt_screen.dart';
import '../features/settings/presentation/screens/contact_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/contact',
      builder: (context, state) => const ContactScreen(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register-institute',
      builder: (context, state) => const InstituteRegistrationScreen(),
    ),
    GoRoute(
      path: '/main-shell',
      builder: (context, state) => const MainShellScreen(),
    ),
    GoRoute(
      path: '/role-selection',
      builder: (context, state) => const RoleSelectionScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/legal-document',
      builder: (context, state) {
        final type = state.uri.queryParameters['type'] ?? 'terms';
        return LegalDocumentScreen(docType: type);
      },
    ),
    GoRoute(
      path: '/student-dashboard',
      builder: (context, state) => const StudentDashboardScreen(),
    ),
    GoRoute(
      path: '/student-profile',
      builder: (context, state) => const StudentProfileScreen(),
    ),
    GoRoute(
      path: '/student-qr-card',
      builder: (context, state) => const StudentQRCardScreen(),
    ),
    GoRoute(
      path: '/staff-dashboard',
      builder: (context, state) => const StaffDashboardScreen(),
    ),
    GoRoute(
      path: '/manual-roll-call',
      builder: (context, state) => const ManualRollCallScreen(),
    ),
    GoRoute(
      path: '/admin-dashboard',
      builder: (context, state) => const AdminDashboardScreen(),
    ),
    GoRoute(
      path: '/super-admin',
      builder: (context, state) => const SuperAdminConsoleScreen(),
    ),
    GoRoute(
      path: '/parent-dashboard',
      builder: (context, state) => const ParentDashboardScreen(),
    ),
    GoRoute(
      path: '/attendance',
      builder: (context, state) => const AttendanceDashboardScreen(),
    ),
    GoRoute(
      path: '/monthly-attendance',
      builder: (context, state) => const MonthlyAttendanceScreen(),
    ),
    GoRoute(
      path: '/qr-generator',
      builder: (context, state) => const QRGeneratorScreen(),
    ),
    GoRoute(
      path: '/qr-scanner',
      builder: (context, state) => const QRScannerScreen(),
    ),
    GoRoute(
      path: '/ai-chatbot',
      builder: (context, state) => const AIChatbotScreen(),
    ),
    GoRoute(
      path: '/ai-quiz',
      builder: (context, state) => const AIQuizScreen(),
    ),
    GoRoute(
      path: '/ai-study-assistant',
      builder: (context, state) => const AIStudyAssistantScreen(),
    ),
    GoRoute(
      path: '/certificate-verify',
      builder: (context, state) => const CertificateVerificationScreen(),
    ),
    GoRoute(
      path: '/exam-take',
      builder: (context, state) => const ExamTakeScreen(),
    ),
    GoRoute(
      path: '/fees',
      builder: (context, state) => const FeeStatusScreen(),
    ),
    GoRoute(
      path: '/invoice-receipt',
      builder: (context, state) => const InvoiceReceiptScreen(),
    ),
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationCenterScreen(),
    ),
    GoRoute(
      path: '/assignments',
      builder: (context, state) => const AssignmentListScreen(),
    ),
    GoRoute(
      path: '/placements',
      builder: (context, state) => const PlacementDrivesScreen(),
    ),
    GoRoute(
      path: '/leave-request',
      builder: (context, state) => const LeaveRequestScreen(),
    ),
  ],
);





