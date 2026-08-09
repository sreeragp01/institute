import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/glassmorphic_card.dart';

class NotificationCenterScreen extends StatelessWidget {
  const NotificationCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.darkMeshGradient),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_rounded, color: AppColors.primaryNavy),
                      onPressed: () => context.pop(),
                    ),
                    Text('Notification Center', style: AppTypography.header2(color: AppColors.textPrimary)),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    _buildNotificationTile(
                      title: 'Upcoming Fee Installment Due',
                      message: 'Your 2nd installment of ₹45,000 is due on August 18, 2026.',
                      time: '2 hours ago',
                      icon: Icons.notifications_active_rounded,
                      color: AppColors.amberGold,
                    ),
                    const SizedBox(height: 12),
                    _buildNotificationTile(
                      title: 'New Quiz Synthesized by AI',
                      message: 'AI Study Assistant has synthesized 5 new practice questions for Python Data Science.',
                      time: '5 hours ago',
                      icon: Icons.psychology_rounded,
                      color: AppColors.cyberCyan,
                    ),
                    const SizedBox(height: 12),
                    _buildNotificationTile(
                      title: 'Placement Drive Announcement',
                      message: 'TechCorp AI Labs is hosting a campus drive for Junior ML Engineers on August 24.',
                      time: 'Yesterday',
                      icon: Icons.business_center_rounded,
                      color: AppColors.emeraldGreen,
                    ),
                    const SizedBox(height: 12),
                    _buildNotificationTile(
                      title: 'Attendance Status Excellent',
                      message: 'Your overall attendance reached 92.0% for the current term.',
                      time: '2 days ago',
                      icon: Icons.verified_rounded,
                      color: AppColors.emeraldGreen,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationTile({required String title, required String message, required String time, required IconData icon, required Color color}) {
    return GlassmorphicCard(
      borderColor: color.withValues(alpha: 0.3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.subtitle(color: AppColors.textPrimary)),
                const SizedBox(height: 2),
                Text(message, style: AppTypography.caption(color: AppColors.textSecondary)),
                const SizedBox(height: 6),
                Text(time, style: AppTypography.microTag(color: AppColors.textMuted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
