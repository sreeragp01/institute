import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/glassmorphic_card.dart';
import '../../../../core/widgets/custom_button.dart';

class LeaveRequestScreen extends StatefulWidget {
  const LeaveRequestScreen({super.key});

  @override
  State<LeaveRequestScreen> createState() => _LeaveRequestScreenState();
}

class _LeaveRequestScreenState extends State<LeaveRequestScreen> {
  final _reasonController = TextEditingController();
  final _fromDateController = TextEditingController(text: '2026-08-10');
  final _toDateController = TextEditingController(text: '2026-08-12');

  void _submitLeave() {
    if (_reasonController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a reason for your leave request')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.darkCardSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: AppColors.emeraldGreen)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_rounded, size: 56, color: AppColors.emeraldGreen),
            const SizedBox(height: 16),
            Text('Leave Submitted', style: AppTypography.header2()),
            const SizedBox(height: 8),
            Text('Your leave application has been routed to your Faculty Trainer & Admin for approval.', textAlign: TextAlign.center, style: AppTypography.caption(color: AppColors.textSecondary)),
            const SizedBox(height: 20),
            CustomButton(
              text: 'OK',
              onPressed: () {
                Navigator.of(ctx).pop();
                context.pop();
              },
            ),
          ],
        ),
      ),
    );
  }

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
                    Text('Apply for Student Leave', style: AppTypography.header2()),
                  ],
                ),
                const SizedBox(height: 20),

                GlassmorphicCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('From Date', style: AppTypography.subtitle()),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _fromDateController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.calendar_today_rounded, color: AppColors.cyberCyan),
                        ),
                      ),
                      const SizedBox(height: 16),

                      Text('To Date', style: AppTypography.subtitle()),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _toDateController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.calendar_today_rounded, color: AppColors.cyberCyan),
                        ),
                      ),
                      const SizedBox(height: 16),

                      Text('Reason for Absence', style: AppTypography.subtitle()),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _reasonController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          hintText: 'e.g. Attending family emergency / Medical leave...',
                        ),
                      ),
                      const SizedBox(height: 24),

                      CustomButton(
                        text: 'Submit Application',
                        gradient: AppColors.aiGradient,
                        onPressed: _submitLeave,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                Text('Previous Leave Requests', style: AppTypography.subtitle()),
                const SizedBox(height: 12),
                _pastLeaveCard('Medical Absence', 'July 14 - July 15, 2024', 'APPROVED', AppColors.emeraldGreen),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _pastLeaveCard(String title, String dates, String status, Color color) {
    return GlassmorphicCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTypography.subtitle()),
              Text(dates, style: AppTypography.caption(color: AppColors.textMuted)),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(status, style: AppTypography.microTag(color: color)),
          ),
        ],
      ),
    );
  }
}
