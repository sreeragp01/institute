import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/glassmorphic_card.dart';
import '../../../../core/widgets/custom_button.dart';

class ExamTakeScreen extends StatefulWidget {
  const ExamTakeScreen({super.key});

  @override
  State<ExamTakeScreen> createState() => _ExamTakeScreenState();
}

class _ExamTakeScreenState extends State<ExamTakeScreen> {
  int _selectedOption = -1;
  bool _submitted = false;

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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                          onPressed: () => context.pop(),
                        ),
                        Text('Mid-Term Exam', style: AppTypography.header2(color: AppColors.cyberCyan)),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.amberGold.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.amberGold),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.timer_rounded, size: 16, color: AppColors.amberGold),
                          const SizedBox(width: 4),
                          Text('45:00', style: AppTypography.caption(color: AppColors.amberGold)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GlassmorphicCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Question 1 of 5', style: AppTypography.caption(color: AppColors.cyberCyan)),
                            const SizedBox(height: 8),
                            Text(
                              'What is the output of len([1, 2, 3, 4]) in Python?',
                              style: AppTypography.subtitle(color: Colors.white),
                            ),
                            const SizedBox(height: 16),
                            _buildOption(0, '3'),
                            _buildOption(1, '4'),
                            _buildOption(2, '5'),
                            _buildOption(3, 'Error'),
                            const SizedBox(height: 20),
                            CustomButton(
                              text: _submitted ? 'Submitted!' : 'Submit Answer & Evaluate',
                              onPressed: _submitted ? null : () => setState(() => _submitted = true),
                            ),
                          ],
                        ),
                      ),
                      if (_submitted) ...[
                        const SizedBox(height: 20),
                        GlassmorphicCard(
                          borderColor: AppColors.emeraldGreen,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Evaluation Result: PASSED! 🎉', style: AppTypography.header2(color: AppColors.emeraldGreen)),
                              const SizedBox(height: 8),
                              Text('Marks Obtained: 50 / 50', style: AppTypography.subtitle(color: Colors.white)),
                              Text('Class Rank: #1', style: AppTypography.caption(color: AppColors.amberGold)),
                            ],
                          ),
                        )
                      ]
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOption(int index, String optionText) {
    final isSelected = _selectedOption == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedOption = index),
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.cyberCyan.withValues(alpha: 0.15) : Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isSelected ? AppColors.cyberCyan : Colors.white12),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? AppColors.cyberCyan : Colors.white38,
            ),
            const SizedBox(width: 12),
            Text(optionText, style: AppTypography.subtitle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
