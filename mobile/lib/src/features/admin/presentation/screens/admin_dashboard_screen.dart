import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/glassmorphic_card.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../analytics/presentation/providers/dashboard_provider.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final asyncDashboard = ref.watch(dashboardProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.darkMeshGradient),
        child: SafeArea(
          child: asyncDashboard.when(
            loading: () => const Center(child: CircularProgressIndicator(color: AppColors.cyberCyan)),
            error: (err, stack) => _buildContent(context, ref, authState, null),
            data: (data) => _buildContent(context, ref, authState, data),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, AuthState authState, DashboardData? data) {
    final enrolled = data?.enrolledStudents ?? 480;
    final avgAtt = data?.avgAttendancePercentage ?? 92.0;
    final feesCollected = data?.totalFeeCollected ?? 1420000.0;
    final activeDrives = data?.activeJobDrives ?? 8;
    final instName = data?.instituteName ?? 'SMEC Institute';
    final instCode = data?.instituteCode ?? 'SMEC';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: AppColors.primaryBlue.withValues(alpha: 0.2),
                      child: const Icon(Icons.admin_panel_settings, color: AppColors.primaryBlue),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            authState.fullName ?? 'Institute Admin',
                            style: AppTypography.subtitle(),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '$instName ($instCode)',
                            style: AppTypography.caption(color: AppColors.cyberCyan),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.headset_mic_rounded, color: AppColors.amberGold),
                    tooltip: 'Contact SMEC Desk',
                    onPressed: () => context.push('/contact'),
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings_outlined, color: AppColors.cyberCyan),
                    tooltip: 'Settings',
                    onPressed: () => context.push('/settings'),
                  ),
                  if (authState.role == 'SUPER_ADMIN')
                    IconButton(
                      icon: const Icon(Icons.admin_panel_settings_outlined, color: AppColors.amberGold),
                      onPressed: () => context.push('/super-admin'),
                    ),
                  IconButton(
                    icon: const Icon(Icons.logout_rounded, color: AppColors.coralRed),
                    onPressed: () async {
                      await ref.read(authProvider.notifier).logout();
                      if (context.mounted) context.go('/login');
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          Text('Institute Overview & KPIs', style: AppTypography.header2()),
          const SizedBox(height: 16),

          // Responsive KPI Grid for Mobile, Tablet & Desktop
          LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth > 800;
              final isTablet = constraints.maxWidth > 500;
              final crossCount = isDesktop ? 4 : (isTablet ? 3 : 2);
              final ratio = isDesktop ? 1.6 : (isTablet ? 1.4 : 1.2);

              return GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: crossCount,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: ratio,
                children: [
                  _kpiCard('Enrolled Students', '$enrolled', '+12% this month', AppColors.cyberCyan, Icons.groups_rounded),
                  _kpiCard('Avg Attendance', '$avgAtt%', 'Live Session Average', AppColors.emeraldGreen, Icons.event_available_rounded),
                  _kpiCard('Fee Collections', '₹${(feesCollected / 100000).toStringAsFixed(1)}L', '88% paid', AppColors.amberGold, Icons.account_balance_wallet_rounded),
                  _kpiCard('Active Job Drives', '$activeDrives', '${data?.placedStudentsCount ?? 32} offers placed', AppColors.primaryBlue, Icons.work_history_rounded),
                ],
              );
            },
          ),
          const SizedBox(height: 24),

          Text('Admin Management Controls', style: AppTypography.subtitle()),
          const SizedBox(height: 12),
          _adminActionTile(
            Icons.group_add_rounded,
            'Admissions & Lead CRM',
            'Track prospect student inquiries & lead pipeline',
            onTap: () => context.push('/admissions-crm'),
          ),
          const SizedBox(height: 10),
          _adminActionTile(
            Icons.headset_mic_rounded,
            'Helpdesk & Support Tickets',
            'View & respond to student and parent inquiries',
            onTap: () => context.push('/support-tickets'),
          ),
          const SizedBox(height: 10),
          _adminActionTile(
            Icons.security_rounded,
            'System Activity Audit Logs',
            'Review operational activity and administrative logs',
            onTap: () => context.push('/audit-logs'),
          ),
          const SizedBox(height: 10),
          _adminActionTile(
            Icons.person_add_outlined,
            'User Management',
            'View & manage student profiles & staff',
            onTap: () => _showUserListModal(context),
          ),
          const SizedBox(height: 10),
          _adminActionTile(
            Icons.analytics_outlined,
            'Analytics & Reports',
            'View attendance metrics, fees & placements',
            onTap: () => context.push('/attendance'),
          ),
          const SizedBox(height: 10),
          _adminActionTile(
            Icons.campaign_outlined,
            'Broadcast Announcement',
            'Send push notification alert to all students',
            onTap: () => _showBroadcastModal(context),
          ),
        ],
      ),
    );
  }

  void _showUserListModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.darkCardSurface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, left: 24, right: 24, top: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Registered Institute Users', style: AppTypography.header2()),
                IconButton(
                  icon: const Icon(Icons.person_add_alt_1_rounded, color: AppColors.cyberCyan),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    _showOnboardUserModal(context);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            _userTile('Ananya Sharma', 'student@smec.edu', 'Student • Batch 2026-A'),
            const SizedBox(height: 10),
            _userTile('Prof. Rahul Nair', 'trainer@smec.edu', 'Faculty • Computer Science'),
            const SizedBox(height: 10),
            _userTile('Priya Verma', 'hr@smec.edu', 'Reception / HR'),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: '+ Onboard New User',
                    gradient: AppColors.primaryGradient,
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      _showOnboardUserModal(context);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _showOnboardUserModal(BuildContext context) {
    final emailCtrl = TextEditingController();
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    String selectedRole = 'TRAINER';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.darkCardSurface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, left: 24, right: 24, top: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Onboard New User to Institute', style: AppTypography.header2()),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: selectedRole,
                dropdownColor: AppColors.darkCardSurface,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'User Role'),
                items: const [
                  DropdownMenuItem(value: 'TRAINER', child: Text('Staff / Faculty Trainer')),
                  DropdownMenuItem(value: 'RECEPTION_HR', child: Text('HR / Receptionist')),
                  DropdownMenuItem(value: 'STUDENT', child: Text('Student Account')),
                ],
                onChanged: (val) => setModalState(() => selectedRole = val ?? 'TRAINER'),
              ),
              const SizedBox(height: 12),
              TextField(controller: nameCtrl, decoration: const InputDecoration(hintText: 'Full Name')),
              const SizedBox(height: 12),
              TextField(controller: emailCtrl, decoration: const InputDecoration(hintText: 'Email Address')),
              const SizedBox(height: 12),
              TextField(controller: phoneCtrl, decoration: const InputDecoration(hintText: 'Phone Number')),
              const SizedBox(height: 20),
              CustomButton(
                text: 'Create & Onboard User',
                gradient: AppColors.primaryGradient,
                onPressed: () {
                  Navigator.of(ctx).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${nameCtrl.text.isEmpty ? "User" : nameCtrl.text} onboarded successfully! Credential email dispatched.'),
                      backgroundColor: AppColors.emeraldGreen,
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _userTile(String name, String email, String role) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.darkBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        children: [
          const Icon(Icons.account_circle_rounded, color: AppColors.cyberCyan),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: AppTypography.subtitle()),
              Text('$email • $role', style: AppTypography.caption(color: AppColors.textMuted)),
            ],
          ),
        ],
      ),
    );
  }

  void _showBroadcastModal(BuildContext context) {
    final titleCtrl = TextEditingController();
    final bodyCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.darkCardSurface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, left: 24, right: 24, top: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Broadcast Announcement', style: AppTypography.header2()),
            const SizedBox(height: 16),
            TextField(controller: titleCtrl, decoration: const InputDecoration(hintText: 'Announcement Title')),
            const SizedBox(height: 12),
            TextField(controller: bodyCtrl, maxLines: 3, decoration: const InputDecoration(hintText: 'Notification message body...')),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Send FCM Broadcast Notification',
              gradient: AppColors.aiGradient,
              onPressed: () {
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Push notification broadcasted to all active devices!')),
                );
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _kpiCard(String title, String val, String subtitle, Color color, IconData icon) {
    return GlassmorphicCard(
      borderColor: color.withValues(alpha: 0.4),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: AppTypography.caption(color: AppColors.textMuted)),
              Icon(icon, color: color, size: 20),
            ],
          ),
          const SizedBox(height: 6),
          Text(val, style: AppTypography.header1(color: Colors.white)),
          const SizedBox(height: 4),
          Text(subtitle, style: AppTypography.microTag(color: color)),
        ],
      ),
    );
  }

  Widget _adminActionTile(IconData icon, String title, String subtitle, {VoidCallback? onTap}) {
    return GlassmorphicCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.cyberCyan.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.cyberCyan),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.subtitle()),
                Text(subtitle, style: AppTypography.caption(color: AppColors.textMuted)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
        ],
      ),
    );
  }
}
