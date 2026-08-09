import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/glassmorphic_card.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class StudentProfileScreen extends ConsumerWidget {
  const StudentProfileScreen({super.key});

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
                Text('Student Profile', style: AppTypography.header2()),
                const SizedBox(height: 20),

                // Header Profile Card
                GlassmorphicCard(
                  borderColor: AppColors.cyberCyan.withValues(alpha: 0.4),
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.cyberCyan.withValues(alpha: 0.15),
                          border: Border.all(color: AppColors.cyberCyan, width: 2),
                        ),
                        child: const Icon(Icons.person_rounded, size: 40, color: AppColors.cyberCyan),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(authState.fullName ?? 'Ananya Sharma', style: AppTypography.header2(color: AppColors.textPrimary)),
                            Text(authState.email ?? 'student@smec.edu', style: AppTypography.caption(color: AppColors.textSecondary)),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.cyberCyan.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text('Roll No: SMEC-2026-0042', style: AppTypography.microTag(color: AppColors.cyberCyan)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                Text('Academic & Guardian Details', style: AppTypography.subtitle()),
                const SizedBox(height: 12),
                GlassmorphicCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _detailRow('Enrolled Program', 'B.Tech Computer Science & AI'),
                      const Divider(color: AppColors.glassBorder, height: 20),
                      _detailRow('Current Batch', 'Batch 2026-A (Morning)'),
                      const Divider(color: AppColors.glassBorder, height: 20),
                      _detailRow('Guardian Name', 'R. Sharma'),
                      const Divider(color: AppColors.glassBorder, height: 20),
                      _detailRow('Guardian Contact', '+91 9876543210'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                Text('Student Actions & Utilities', style: AppTypography.subtitle()),
                const SizedBox(height: 12),
                _actionTile(
                  icon: Icons.badge_rounded,
                  title: 'Digital Student ID Card',
                  subtitle: 'Show digital ID & dynamic QR badge for campus entry',
                  color: AppColors.cyberCyan,
                  onTap: () => context.push('/student-qr-card'),
                ),
                const SizedBox(height: 10),
                _actionTile(
                  icon: Icons.event_note_rounded,
                  title: 'Apply for Leave',
                  subtitle: 'Submit absence application & view status',
                  color: AppColors.amberGold,
                  onTap: () => context.push('/leave-request'),
                ),
                const SizedBox(height: 10),
                _actionTile(
                  icon: Icons.receipt_long_rounded,
                  title: 'Fee Receipts',
                  subtitle: 'Download paid tuition fee receipts',
                  color: AppColors.emeraldGreen,
                  onTap: () => context.push('/fees'),
                ),
                const SizedBox(height: 24),

                CustomButton(
                  text: 'Log Out of Account',
                  isOutlined: true,
                  onPressed: () async {
                    await ref.read(authProvider.notifier).logout();
                    if (context.mounted) context.go('/login');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTypography.caption(color: AppColors.textMuted)),
        Text(value, style: AppTypography.subtitle(color: AppColors.textPrimary)),
      ],
    );
  }

  Widget _actionTile({required IconData icon, required String title, required String subtitle, required Color color, required VoidCallback onTap}) {
    return GlassmorphicCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color),
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
