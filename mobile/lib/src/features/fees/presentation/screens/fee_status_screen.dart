import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/glassmorphic_card.dart';
import '../../../../core/widgets/custom_button.dart';

class FeeStatusScreen extends StatefulWidget {
  const FeeStatusScreen({super.key});

  @override
  State<FeeStatusScreen> createState() => _FeeStatusScreenState();
}

class _FeeStatusScreenState extends State<FeeStatusScreen> {
  double _paidAmount = 15000.00;
  final double _totalAmount = 45000.00;
  final String _inst1Status = 'PAID';
  String _inst2Status = 'PENDING';

  void _processOnlinePayment() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.darkCardSurface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Online Payment Gateway', style: AppTypography.header2()),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: AppColors.cyberCyan.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(6)),
                  child: Text('Razorpay / UPI Secure', style: AppTypography.microTag(color: AppColors.cyberCyan)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            GlassmorphicCard(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Installment 2 Payment', style: AppTypography.subtitle()),
                      Text('₹15,000.00', style: AppTypography.header2(color: AppColors.emeraldGreen)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('Computer Science & AI • Due Date: Oct 18, 2026', style: AppTypography.caption(color: AppColors.textMuted)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text('Select Payment Mode', style: AppTypography.subtitle()),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.qr_code_2_rounded, color: AppColors.cyberCyan),
              title: Text('UPI / Google Pay / PhonePe', style: AppTypography.subtitle(color: Colors.white)),
              subtitle: Text('Instant zero-fee transfer', style: AppTypography.caption(color: AppColors.textMuted)),
              trailing: const Icon(Icons.radio_button_checked, color: AppColors.cyberCyan),
              tileColor: AppColors.darkBackground,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Pay ₹15,000 Now',
              gradient: AppColors.primaryGradient,
              onPressed: () {
                Navigator.of(ctx).pop();
                setState(() {
                  _paidAmount = 30000.00;
                  _inst2Status = 'PAID';
                });
                _showSuccessDialog();
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.darkCardSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: AppColors.emeraldGreen)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_rounded, size: 60, color: AppColors.emeraldGreen),
            const SizedBox(height: 16),
            Text('Payment Successful!', style: AppTypography.header2()),
            const SizedBox(height: 8),
            Text('Txn ID: TXN-SMEC-984102\nReceipt has been generated and emailed to your address.', textAlign: TextAlign.center, style: AppTypography.caption(color: AppColors.textSecondary)),
            const SizedBox(height: 20),
            CustomButton(
              text: 'View Official Digital Invoice',
              onPressed: () {
                Navigator.of(ctx).pop();
                context.push('/invoice-receipt');
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pendingDue = _totalAmount - _paidAmount;

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
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.cyberCyan, size: 20),
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
                              Text('₹${_paidAmount.toStringAsFixed(2)}', style: AppTypography.subtitle(color: AppColors.emeraldGreen)),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('Pending Due', style: AppTypography.microTag(color: AppColors.coralRed)),
                              Text('₹${pendingDue.toStringAsFixed(2)}', style: AppTypography.subtitle(color: AppColors.coralRed)),
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
                _installmentTile(
                  'Installment 1',
                  '₹15,000.00',
                  'Due: Aug 18, 2026',
                  _inst1Status,
                  _inst1Status == 'PAID' ? AppColors.emeraldGreen : AppColors.amberGold,
                  onTap: () => context.push('/invoice-receipt'),
                ),
                const SizedBox(height: 10),
                _installmentTile(
                  'Installment 2',
                  '₹15,000.00',
                  'Due: Oct 18, 2026',
                  _inst2Status,
                  _inst2Status == 'PAID' ? AppColors.emeraldGreen : AppColors.amberGold,
                  onTap: () => context.push('/invoice-receipt'),
                ),
                const SizedBox(height: 10),
                _installmentTile(
                  'Installment 3',
                  '₹15,000.00',
                  'Due: Dec 18, 2026',
                  'UPCOMING',
                  AppColors.textMuted,
                  onTap: null,
                ),

                const SizedBox(height: 24),
                Text('Downloadable Official Receipts', style: AppTypography.subtitle()),
                const SizedBox(height: 12),
                GlassmorphicCard(
                  onTap: () => context.push('/invoice-receipt'),
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
                            Text('Installment 1 Receipt', style: AppTypography.subtitle()),
                            Text('Receipt #SMEC-REC-99412 • Paid ₹15,000', style: AppTypography.caption(color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                      const Icon(Icons.download_rounded, color: AppColors.cyberCyan),
                    ],
                  ),
                ),

                const SizedBox(height: 32),
                if (pendingDue > 0)
                  CustomButton(
                    text: 'Pay Pending Installment Online',
                    gradient: AppColors.aiGradient,
                    icon: Icons.payment_rounded,
                    onPressed: _processOnlinePayment,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _installmentTile(String title, String amount, String due, String status, Color color, {VoidCallback? onTap}) {
    return GlassmorphicCard(
      onTap: onTap,
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
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: color),
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
