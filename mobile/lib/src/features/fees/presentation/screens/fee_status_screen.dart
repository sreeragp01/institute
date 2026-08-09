import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/glassmorphic_card.dart';
import '../../../../core/widgets/custom_button.dart';

class FeeStatusScreen extends StatelessWidget {
  const FeeStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.primaryNavy, size: 20),
                      onPressed: () => context.pop(),
                    ),
                    const SizedBox(width: 8),
                    Text('Fee & Payment Portal', style: AppTypography.header2()),
                  ],
                ),
                const SizedBox(height: 24),

                // Total Fee Summary Card
                GlassmorphicCard(
                  borderColor: AppColors.amberGold.withValues(alpha: 0.5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Computer Science & AI (6 Months)', style: AppTypography.caption(color: AppColors.textMuted)),
                      const SizedBox(height: 4),
                      Text('Total Tuition Fee: ₹45,000', style: AppTypography.header1(color: AppColors.textPrimary)),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Paid Amount', style: AppTypography.microTag(color: AppColors.emeraldGreen)),
                              Text('₹0.00', style: AppTypography.subtitle(color: AppColors.emeraldGreen)),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('Pending Due', style: AppTypography.microTag(color: AppColors.coralRed)),
                              Text('₹45,000.00', style: AppTypography.subtitle(color: AppColors.coralRed)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                Text('Installment Breakdown', style: AppTypography.subtitle()),
                const SizedBox(height: 12),
                _installmentTile('Installment 1', '₹15,000.00', 'Due: Aug 18, 2026', 'PENDING', AppColors.amberGold),
                const SizedBox(height: 10),
                _installmentTile('Installment 2', '₹15,000.00', 'Due: Oct 18, 2026', 'UPCOMING', AppColors.textMuted),
                const SizedBox(height: 10),
                _installmentTile('Installment 3', '₹15,000.00', 'Due: Dec 18, 2026', 'UPCOMING', AppColors.textMuted),

                const SizedBox(height: 24),
                Text('Downloadable Official Receipts', style: AppTypography.subtitle()),
                const SizedBox(height: 12),
                GlassmorphicCard(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.picture_as_pdf_rounded, color: AppColors.primaryBlue),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Admission Token Receipt', style: AppTypography.subtitle()),
                            Text('Receipt #SMEC-REC-99412 • Paid ₹5,000', style: AppTypography.caption(color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                      const Icon(Icons.download_rounded, color: AppColors.cyberCyan),
                    ],
                  ),
                ),

                const SizedBox(height: 32),
                CustomButton(
                  text: 'Pay Pending Fee Online',
                  gradient: AppColors.aiGradient,
                  icon: Icons.payment_rounded,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _installmentTile(String title, String amount, String due, String status, Color color) {
    return GlassmorphicCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTypography.subtitle()),
              Text(due, style: AppTypography.caption(color: AppColors.textMuted)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(amount, style: AppTypography.subtitle(color: AppColors.textPrimary)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(status, style: AppTypography.microTag(color: color)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
