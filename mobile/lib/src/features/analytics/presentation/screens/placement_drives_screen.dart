import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/glassmorphic_card.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/placement_carousel.dart';

class PlacementDrivesScreen extends StatelessWidget {
  const PlacementDrivesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.darkMeshGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                      onPressed: () => context.pop(),
                    ),
                    const SizedBox(width: 8),
                    Text('Placement & Career Cell', style: AppTypography.header2()),
                  ],
                ),
                const SizedBox(height: 20),

                GlassmorphicCard(
                  borderColor: AppColors.cyberCyan.withValues(alpha: 0.4),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.cyberCyan.withValues(alpha: 0.15),
                        ),
                        child: const Icon(Icons.work_history_rounded, color: AppColors.cyberCyan, size: 28),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Active Campus Drives', style: AppTypography.subtitle()),
                            Text('8 Hiring Partners • 32 Placed This Month', style: AppTypography.caption(color: AppColors.emeraldGreen)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const PlacementCarouselWidget(),
                const SizedBox(height: 20),

                Text('Upcoming Recruitment Drives', style: AppTypography.subtitle()),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView(
                    children: [
                      _jobDriveCard(
                        context,
                        company: 'TechCorp Solutions',
                        role: 'Junior AI/ML Engineer',
                        package: '₹8.5 - 12.0 LPA',
                        eligibility: 'B.Tech / MCA (Min 75% Attendance)',
                        driveDate: 'Drive Date: Aug 20, 2026',
                        status: 'REGISTERED',
                        statusColor: AppColors.emeraldGreen,
                      ),
                      const SizedBox(height: 12),
                      _jobDriveCard(
                        context,
                        company: 'DataMetrics India',
                        role: 'Data Analyst & SQL Developer',
                        package: '₹6.5 - 9.0 LPA',
                        eligibility: 'All Enrolled CS Batches',
                        driveDate: 'Drive Date: Aug 25, 2026',
                        status: 'OPEN FOR REGISTRATION',
                        statusColor: AppColors.cyberCyan,
                      ),
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

  Widget _jobDriveCard(
    BuildContext context, {
    required String company,
    required String role,
    required String package,
    required String eligibility,
    required String driveDate,
    required String status,
    required Color statusColor,
  }) {
    return GlassmorphicCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(company, style: AppTypography.subtitle(color: AppColors.cyberCyan)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(status, style: AppTypography.microTag(color: statusColor)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(role, style: AppTypography.header2(color: Colors.white)),
          const SizedBox(height: 4),
          Text('Package: $package', style: AppTypography.subtitle(color: AppColors.emeraldGreen)),
          const SizedBox(height: 4),
          Text(eligibility, style: AppTypography.caption(color: AppColors.textSecondary)),
          Text(driveDate, style: AppTypography.microTag(color: AppColors.textMuted)),
          const SizedBox(height: 16),
          CustomButton(
            text: status == 'REGISTERED' ? 'Application Submitted ✅' : 'Apply for Drive',
            gradient: status == 'REGISTERED' ? AppColors.primaryGradient : AppColors.aiGradient,
            isOutlined: status == 'REGISTERED',
            onPressed: status == 'REGISTERED' ? null : () {},
          ),
        ],
      ),
    );
  }
}
