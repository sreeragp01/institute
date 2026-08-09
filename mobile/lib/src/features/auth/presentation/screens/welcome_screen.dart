import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/glassmorphic_card.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.darkMeshGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              children: [
                const Spacer(),
                // Hero 3D Artwork Glass Card Preview
                GlassmorphicCard(
                  borderColor: AppColors.glassBorderActive,
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryBlue.withValues(alpha: 0.2),
                          border: Border.all(color: AppColors.cyberCyan.withValues(alpha: 0.4)),
                        ),
                        child: const Icon(
                          Icons.auto_awesome_rounded,
                          size: 48,
                          color: AppColors.cyberCyan,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildFeatureChip(Icons.qr_code_scanner, 'QR Attendance'),
                          _buildFeatureChip(Icons.psychology, 'AI Tutor'),
                          _buildFeatureChip(Icons.work_outline, 'Placements'),
                        ],
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 600.ms).scale(begin: const Offset(0.9, 0.9)),
                const Spacer(),
                Text(
                  'Transform Your Academic Journey with AI',
                  textAlign: TextAlign.center,
                  style: AppTypography.header1(),
                ).animate().fadeIn(delay: 200.ms),
                const SizedBox(height: 12),
                Text(
                  'Real-time QR attendance, 24/7 AI tutor assistance, instant fee records, and direct career placement tracking in one unified app.',
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyStandard(color: AppColors.textSecondary),
                ).animate().fadeIn(delay: 400.ms),
                const SizedBox(height: 36),
                CustomButton(
                  text: 'Get Started',
                  gradient: AppColors.aiGradient,
                  icon: Icons.arrow_forward_rounded,
                  onPressed: () => context.push('/onboarding'),
                ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2, end: 0),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an account? ', style: AppTypography.bodyStandard()),
                    GestureDetector(
                      onTap: () => context.push('/login'),
                      child: Text(
                        'Log In',
                        style: AppTypography.subtitle(color: AppColors.cyberCyan),
                      ),
                    ),
                  ],
                ).animate().fadeIn(delay: 700.ms),
                const SizedBox(height: 16),
                TextButton.icon(
                  onPressed: () => context.push('/contact'),
                  icon: const Icon(Icons.headset_mic_rounded, color: AppColors.amberGold, size: 18),
                  label: Text(
                    'Contact Admissions & Campuses',
                    style: AppTypography.caption(color: AppColors.amberGold),
                  ),
                ).animate().fadeIn(delay: 800.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.darkCardSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.cyberCyan),
          const SizedBox(width: 4),
          Text(label, style: AppTypography.microTag(color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}
