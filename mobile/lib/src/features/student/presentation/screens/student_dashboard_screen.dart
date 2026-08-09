import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/glassmorphic_card.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/placement_carousel.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class StudentDashboardScreen extends ConsumerWidget {
  const StudentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.darkMeshGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Navigation Bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => _showProfileModal(context, authState),
                        borderRadius: BorderRadius.circular(22),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 22,
                              backgroundColor: AppColors.cyberCyan.withValues(alpha: 0.2),
                              child: const Icon(Icons.person, color: AppColors.cyberCyan),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    authState.fullName ?? 'Ananya Sharma',
                                    style: AppTypography.subtitle(),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    'Batch: B.Tech CS 2026',
                                    style: AppTypography.caption(color: AppColors.textMuted),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
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
                        IconButton(
                          icon: const Icon(Icons.notifications_outlined, color: AppColors.primaryNavy),
                          onPressed: () => _showNotificationsModal(context),
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

                // Attendance Summary Card
                GlassmorphicCard(
                  borderColor: AppColors.emeraldGreen.withValues(alpha: 0.4),
                  onTap: () => context.push('/attendance'),
                  child: Row(
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.emeraldGreen.withValues(alpha: 0.15),
                          border: Border.all(color: AppColors.emeraldGreen, width: 3),
                        ),
                        child: Center(
                          child: Text(
                            '92%',
                            style: AppTypography.header2(color: AppColors.emeraldGreen),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Overall Attendance', style: AppTypography.subtitle()),
                            const SizedBox(height: 4),
                            Text('46 of 50 sessions attended', style: AppTypography.caption(color: AppColors.textSecondary)),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.emeraldGreen.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text('Eligible for Exams', style: AppTypography.microTag(color: AppColors.emeraldGreen)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Quick Action Buttons
                Text('Quick Actions', style: AppTypography.subtitle()),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _quickActionButton(
                        context,
                        icon: Icons.qr_code_scanner_rounded,
                        label: 'Scan QR',
                        color: AppColors.cyberCyan,
                        onTap: () => context.push('/qr-scanner'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _quickActionButton(
                        context,
                        icon: Icons.psychology_rounded,
                        label: 'AI Tutor',
                        color: AppColors.primaryBlue,
                        onTap: () => context.push('/ai-chatbot'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _quickActionButton(
                        context,
                        icon: Icons.receipt_long_rounded,
                        label: 'Fees',
                        color: AppColors.amberGold,
                        onTap: () => context.push('/fees'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _quickActionButton(
                        context,
                        icon: Icons.assignment_outlined,
                        label: 'Assignments',
                        color: AppColors.emeraldGreen,
                        onTap: () => context.push('/assignments'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _quickActionButton(
                        context,
                        icon: Icons.work_history_rounded,
                        label: 'Placements',
                        color: AppColors.cyberCyan,
                        onTap: () => context.push('/placements'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _quickActionButton(
                        context,
                        icon: Icons.event_note_rounded,
                        label: 'Leave App',
                        color: AppColors.amberGold,
                        onTap: () => context.push('/leave-request'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Today's Classes
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Today's Schedule", style: AppTypography.subtitle()),
                    GestureDetector(
                      onTap: () => _showFullTimetable(context),
                      child: Text('View Full Week', style: AppTypography.caption(color: AppColors.cyberCyan)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _classTile('Advanced Machine Learning', '10:00 AM - 11:30 AM', 'Lab 3', 'Prof. Rahul Nair'),
                const SizedBox(height: 10),
                _classTile('Cloud Computing Systems', '01:30 PM - 03:00 PM', 'Hall B', 'Dr. S. K. Roy'),

                const SizedBox(height: 24),
                const PlacementCarouselWidget(),
                const SizedBox(height: 24),

                // Recent Announcements
                Text('Latest Announcements', style: AppTypography.subtitle()),
                const SizedBox(height: 12),
                GlassmorphicCard(
                  onTap: () => context.push('/placements'),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.campaign_rounded, color: AppColors.amberGold, size: 20),
                          const SizedBox(width: 8),
                          Text('Placement Drive: TechCorp India', style: AppTypography.subtitle(color: AppColors.amberGold)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Registration for TechCorp India placement drive closes tomorrow at 5:00 PM. Submit your updated resume.',
                        style: AppTypography.bodyStandard(),
                      ),
                      const SizedBox(height: 8),
                      Text('Posted 2 hours ago by Placement Cell', style: AppTypography.caption(color: AppColors.textMuted)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showProfileModal(BuildContext context, AuthState authState) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.darkCardSurface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.cyberCyan.withValues(alpha: 0.2),
                  child: const Icon(Icons.person, size: 36, color: AppColors.cyberCyan),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(authState.fullName ?? 'Ananya Sharma', style: AppTypography.header2()),
                    Text(authState.email ?? 'student@smec.edu', style: AppTypography.caption(color: AppColors.textSecondary)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            _infoRow('Roll Number', 'SMEC-2026-0042'),
            _infoRow('Course Track', 'B.Tech Computer Science & AI'),
            _infoRow('Batch Session', '2026-A (Morning Session)'),
            _infoRow('Guardian Contact', 'R. Sharma (+91 9876543210)'),
            const SizedBox(height: 20),
            CustomButton(text: 'Close Profile', onPressed: () => Navigator.of(ctx).pop()),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String val) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.caption(color: AppColors.textMuted)),
          Text(val, style: AppTypography.subtitle(color: AppColors.textPrimary)),
        ],
      ),
    );
  }

  void _showNotificationsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.darkCardSurface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('In-App Notifications', style: AppTypography.header2()),
            const SizedBox(height: 16),
            _notifTile('Assignment 3 Graded', 'Your Python ML assignment was graded A (95/100)', '10 mins ago'),
            const SizedBox(height: 10),
            _notifTile('Fee Due Reminder', 'Installment 1 of ₹15,000 due on Aug 18', '2 hours ago'),
            const SizedBox(height: 20),
            CustomButton(text: 'Close', onPressed: () => Navigator.of(ctx).pop()),
          ],
        ),
      ),
    );
  }

  Widget _notifTile(String title, String body, String time) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.darkBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        children: [
          const Icon(Icons.notifications_active_rounded, color: AppColors.cyberCyan),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.subtitle()),
                Text(body, style: AppTypography.caption(color: AppColors.textSecondary)),
                Text(time, style: AppTypography.microTag(color: AppColors.textMuted)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showFullTimetable(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.darkCardSurface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Weekly Timetable Schedule', style: AppTypography.header2()),
            const SizedBox(height: 16),
            Text('Monday: Python Data Science (10:00 - 11:30 AM)', style: AppTypography.bodyStandard()),
            Text('Tuesday: Data Structures & Algorithms (01:30 - 03:00 PM)', style: AppTypography.bodyStandard()),
            Text('Wednesday: SQL & Database Systems (10:00 - 11:30 AM)', style: AppTypography.bodyStandard()),
            Text('Thursday: Neural Networks Lab (02:00 - 04:00 PM)', style: AppTypography.bodyStandard()),
            Text('Friday: Placement Aptitude Session (11:00 - 12:30 PM)', style: AppTypography.bodyStandard()),
            const SizedBox(height: 20),
            CustomButton(text: 'Close Timetable', onPressed: () => Navigator.of(ctx).pop()),
          ],
        ),
      ),
    );
  }

  Widget _quickActionButton(BuildContext context, {required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return GlassmorphicCard(
      borderColor: color.withValues(alpha: 0.3),
      padding: const EdgeInsets.symmetric(vertical: 16),
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(label, style: AppTypography.caption(color: AppColors.textPrimary)),
        ],
      ),
    );
  }

  Widget _classTile(String title, String time, String room, String instructor) {
    return GlassmorphicCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.cyberCyan.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.schedule_rounded, color: AppColors.cyberCyan),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.subtitle()),
                Text('$time • $room', style: AppTypography.caption(color: AppColors.textSecondary)),
                Text(instructor, style: AppTypography.microTag(color: AppColors.textMuted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
