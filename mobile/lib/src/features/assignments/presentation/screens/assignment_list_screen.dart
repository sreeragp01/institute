import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/glassmorphic_card.dart';
import '../../../../core/widgets/custom_button.dart';

class AssignmentListScreen extends StatelessWidget {
  const AssignmentListScreen({super.key});

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
                    Text('Assignments & Homework', style: AppTypography.header2()),
                  ],
                ),
                const SizedBox(height: 20),

                Text('Active Assignments', style: AppTypography.subtitle()),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView(
                    children: [
                      _assignmentCard(
                        context,
                        title: 'Assignment 3: Transformer & Attention Models',
                        subject: 'Python Data Science',
                        dueDate: 'Due: Aug 12, 2026 at 11:59 PM',
                        status: 'SUBMITTED',
                        statusColor: AppColors.emeraldGreen,
                        score: 'Grade: A (95/100)',
                      ),
                      const SizedBox(height: 12),
                      _assignmentCard(
                        context,
                        title: 'Assignment 4: Convolutional Neural Networks',
                        subject: 'Deep Learning CS-402',
                        dueDate: 'Due: Aug 16, 2026 at 11:59 PM',
                        status: 'PENDING',
                        statusColor: AppColors.amberGold,
                        score: null,
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

  Widget _assignmentCard(
    BuildContext context, {
    required String title,
    required String subject,
    required String dueDate,
    required String status,
    required Color statusColor,
    String? score,
  }) {
    return GlassmorphicCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(subject, style: AppTypography.microTag(color: AppColors.cyberCyan)),
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
          const SizedBox(height: 8),
          Text(title, style: AppTypography.subtitle()),
          const SizedBox(height: 4),
          Text(dueDate, style: AppTypography.caption(color: AppColors.textMuted)),
          if (score != null) ...[
            const SizedBox(height: 8),
            Text(score, style: AppTypography.caption(color: AppColors.emeraldGreen)),
          ],
          const SizedBox(height: 16),
          CustomButton(
            text: status == 'SUBMITTED' ? 'View Submitted File' : 'Upload Submission PDF',
            gradient: status == 'SUBMITTED' ? AppColors.primaryGradient : AppColors.aiGradient,
            isOutlined: status == 'SUBMITTED',
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
