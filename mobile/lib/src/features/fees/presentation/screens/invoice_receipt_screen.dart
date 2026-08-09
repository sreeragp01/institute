import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/glassmorphic_card.dart';

class InvoiceReceiptScreen extends StatelessWidget {
  const InvoiceReceiptScreen({super.key});

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
                    Text('Fee Invoice & Receipt', style: AppTypography.header2(color: AppColors.amberGold)),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: GlassmorphicCard(
                    borderColor: AppColors.amberGold,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('SMEC Connect Invoice', style: AppTypography.subtitle(color: AppColors.textPrimary)),
                                Text('INV-000451', style: AppTypography.caption(color: AppColors.amberGold)),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.emeraldGreen.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.emeraldGreen),
                              ),
                              child: Text('PAID', style: AppTypography.caption(color: AppColors.emeraldGreen)),
                            )
                          ],
                        ),
                        const Divider(color: AppColors.glassBorder, height: 24),

                        Text('Billed To:', style: AppTypography.caption(color: AppColors.textMuted)),
                        Text('Ananya Sharma (SMEC-2026-001)', style: AppTypography.subtitle(color: AppColors.textPrimary)),
                        Text('Course: Computer Science & AI', style: AppTypography.caption(color: AppColors.textSecondary)),
                        Text('Institution: SMEC Institute of Technology', style: AppTypography.caption(color: AppColors.textSecondary)),
                        const SizedBox(height: 16),

                        Text('Payment Breakdown', style: AppTypography.subtitle(color: AppColors.primaryNavy)),
                        const SizedBox(height: 8),
                        _buildLineItem('Tuition & Academic Training', '₹38,250.00'),
                        _buildLineItem('Lab Workstation & AI Cloud Access', '₹4,500.00'),
                        _buildLineItem('Library & Examination Fee', '₹2,250.00'),
                        const Divider(color: AppColors.glassBorder, height: 20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total Amount Paid', style: AppTypography.header2(color: AppColors.textPrimary)),
                            Text('₹45,000.00', style: AppTypography.header1(color: AppColors.amberGold)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text('Transaction ID: TXN-89A02B19CF', style: AppTypography.microTag(color: AppColors.textMuted)),
                        Text('Paid Date: August 04, 2026', style: AppTypography.microTag(color: AppColors.textMuted)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLineItem(String desc, String amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(desc, style: AppTypography.caption(color: AppColors.textSecondary)),
          Text(amount, style: AppTypography.subtitle(color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}
