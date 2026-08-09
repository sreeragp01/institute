import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/glassmorphic_card.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class StaffDashboardScreen extends ConsumerWidget {
  const StaffDashboardScreen({super.key});

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: AppColors.emeraldGreen.withValues(alpha: 0.2),
                          child: const Icon(Icons.psychology, color: AppColors.emeraldGreen),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(authState.fullName ?? 'Prof. Rahul Nair', style: AppTypography.subtitle()),
                            Text('Faculty • Computer Science', style: AppTypography.caption(color: AppColors.textMuted)),
                          ],
                        ),
                      ],
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
                const SizedBox(height: 24),

                // Quick Action Cards
                Row(
                  children: [
                    Expanded(
                      child: GlassmorphicCard(
                        borderColor: AppColors.cyberCyan.withValues(alpha: 0.4),
                        onTap: () => context.push('/qr-generator'),
                        child: Column(
                          children: [
                            const Icon(Icons.qr_code_2_rounded, size: 36, color: AppColors.cyberCyan),
                            const SizedBox(height: 10),
                            Text('Generate Session QR', style: AppTypography.caption(color: AppColors.textPrimary)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GlassmorphicCard(
                        borderColor: AppColors.emeraldGreen.withValues(alpha: 0.4),
                        onTap: () => context.push('/attendance'),
                        child: Column(
                          children: [
                            const Icon(Icons.how_to_reg_rounded, size: 36, color: AppColors.emeraldGreen),
                            const SizedBox(height: 10),
                            Text('Manual Roll Call', style: AppTypography.caption(color: AppColors.textPrimary)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                Text("Today's Assigned Sessions", style: AppTypography.subtitle()),
                const SizedBox(height: 12),
                _sessionCard(
                  context,
                  'Advanced Machine Learning',
                  'Batch A • 42 Enrolled',
                  '10:00 AM - 11:30 AM',
                  'Attendance Marked (39 Present)',
                  AppColors.emeraldGreen,
                ),
                const SizedBox(height: 12),
                _sessionCard(
                  context,
                  'Neural Networks & Deep Learning',
                  'Batch B • 38 Enrolled',
                  '02:00 PM - 03:30 PM',
                  'Pending Session Marking',
                  AppColors.amberGold,
                ),

                const SizedBox(height: 24),
                Text('Pending Submissions to Grade', style: AppTypography.subtitle()),
                const SizedBox(height: 12),
                GlassmorphicCard(
                  onTap: () => context.push('/assignments'),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Assignment 3: Transformer Models', style: AppTypography.subtitle()),
                          Text('14 submissions awaiting review', style: AppTypography.caption(color: AppColors.amberGold)),
                        ],
                      ),
                      const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColors.cyberCyan),
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

  Widget _sessionCard(BuildContext context, String title, String batch, String time, String status, Color statusColor) {
    return GlassmorphicCard(
      onTap: () => context.push('/qr-generator'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: AppTypography.subtitle()),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(status, style: AppTypography.microTag(color: statusColor)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('$batch • $time', style: AppTypography.caption(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
