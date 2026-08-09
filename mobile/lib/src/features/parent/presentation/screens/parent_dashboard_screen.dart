import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/glassmorphic_card.dart';

class ParentDashboardScreen extends ConsumerWidget {
  const ParentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.darkMeshGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Parent Portal', style: AppTypography.header1(color: AppColors.cyberCyan)),
                        Text('Child: Ananya Sharma (Roll: SMEC-2026-001)', style: AppTypography.caption(color: AppColors.textMuted)),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.swap_horiz_rounded, color: AppColors.primaryNavy),
                      onPressed: () => context.go('/role-selection'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Attendance Status Card
                GlassmorphicCard(
                  borderColor: AppColors.cyberCyan,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.cyberCyan.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.verified_rounded, color: AppColors.cyberCyan, size: 32),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Overall Attendance', style: AppTypography.caption(color: AppColors.textMuted)),
                            Text('92.0%', style: AppTypography.header1(color: AppColors.textPrimary)),
                            Text('Status: Excellent • Eligible for Exams', style: AppTypography.microTag(color: AppColors.emeraldGreen)),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Quick Action Grid
                Row(
                  children: [
                    Expanded(
                      child: _buildActionTile(
                        context,
                        title: 'Fee Installments',
                        subtitle: '₹45,000 Pending',
                        icon: Icons.payments_rounded,
                        color: AppColors.amberGold,
                        route: '/fees',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildActionTile(
                        context,
                        title: 'Leave Request',
                        subtitle: 'Apply & Track',
                        icon: Icons.event_note_rounded,
                        color: AppColors.emeraldGreen,
                        route: '/leave-request',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Academic Progress Summary
                GlassmorphicCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Latest Exam Performance', style: AppTypography.subtitle(color: AppColors.textPrimary)),
                      const SizedBox(height: 12),
                      _buildSubjectScore('Python Data Science', '88/100', 'Grade A'),
                      const Divider(color: AppColors.glassBorder, height: 16),
                      _buildSubjectScore('Machine Learning Fundamentals', '92/100', 'Grade A+'),
                      const Divider(color: AppColors.glassBorder, height: 16),
                      _buildSubjectScore('Database Management Systems', '85/100', 'Grade A'),
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

  Widget _buildActionTile(BuildContext context, {required String title, required String subtitle, required IconData icon, required Color color, required String route}) {
    return GestureDetector(
      onTap: () => context.go(route),
      child: GlassmorphicCard(
        borderColor: color.withValues(alpha: 0.3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 12),
            Text(title, style: AppTypography.subtitle(color: AppColors.textPrimary)),
            const SizedBox(height: 2),
            Text(subtitle, style: AppTypography.microTag(color: AppColors.textMuted)),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectScore(String subject, String score, String grade) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(subject, style: AppTypography.subtitle(color: AppColors.textPrimary)),
              Text(grade, style: AppTypography.microTag(color: AppColors.cyberCyan)),
            ],
          ),
        ),
        Text(score, style: AppTypography.subtitle(color: AppColors.textPrimary)),
      ],
    );
  }
}
