import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/glassmorphic_card.dart';
import '../../../../core/widgets/custom_button.dart';

class AttendanceDashboardScreen extends ConsumerWidget {
  const AttendanceDashboardScreen({super.key});

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
                // Top Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                            onPressed: () => context.pop(),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Attendance Dashboard',
                              style: AppTypography.header2(),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.calendar_month_rounded, color: AppColors.cyberCyan),
                      onPressed: () => context.push('/monthly-attendance'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Hero Circular Gauge Card
                GlassmorphicCard(
                  borderColor: AppColors.emeraldGreen.withValues(alpha: 0.5),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 110,
                            height: 110,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.emeraldGreen.withValues(alpha: 0.15),
                              border: Border.all(color: AppColors.emeraldGreen, width: 6),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.emeraldGreen.withValues(alpha: 0.3),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('92.0%', style: AppTypography.header1(color: AppColors.emeraldGreen)),
                                  Text('Overall', style: AppTypography.microTag(color: AppColors.textMuted)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.emeraldGreen.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.emeraldGreen.withValues(alpha: 0.4)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.verified_rounded, color: AppColors.emeraldGreen, size: 16),
                            const SizedBox(width: 6),
                            Text('Eligible for Final Exams (>75%)', style: AppTypography.caption(color: AppColors.emeraldGreen)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _statTile('Present', '46 Days', AppColors.emeraldGreen),
                          _statTile('Absent', '4 Days', AppColors.coralRed),
                          _statTile('Leave', '2 Days', AppColors.amberGold),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Subject Attendance Breakdown
                Text('Subject-wise Attendance', style: AppTypography.subtitle()),
                const SizedBox(height: 12),
                _subjectProgressCard('Python Data Science', 0.933, '93.3% (28/30 sessions)', AppColors.cyberCyan),
                const SizedBox(height: 10),
                _subjectProgressCard('Data Structures & Algorithms', 0.880, '88.0% (22/25 sessions)', AppColors.emeraldGreen),
                const SizedBox(height: 10),
                _subjectProgressCard('SQL & Database Systems', 0.950, '95.0% (19/20 sessions)', AppColors.amberGold),

                const SizedBox(height: 32),
                CustomButton(
                  text: 'Scan Classroom QR Code',
                  gradient: AppColors.aiGradient,
                  icon: Icons.qr_code_scanner_rounded,
                  onPressed: () => context.push('/qr-scanner'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _statTile(String label, String val, Color color) {
    return Column(
      children: [
        Text(val, style: AppTypography.subtitle(color: color)),
        const SizedBox(height: 2),
        Text(label, style: AppTypography.microTag(color: AppColors.textMuted)),
      ],
    );
  }

  Widget _subjectProgressCard(String title, double val, String subtitle, Color color) {
    return GlassmorphicCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.subtitle(),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(subtitle, style: AppTypography.caption(color: color)),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: val,
              minHeight: 8,
              backgroundColor: AppColors.darkCardSurface,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
