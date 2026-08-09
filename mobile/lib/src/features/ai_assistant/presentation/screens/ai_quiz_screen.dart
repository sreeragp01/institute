import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/glassmorphic_card.dart';
import '../../../../core/widgets/custom_button.dart';

class AIQuizScreen extends StatefulWidget {
  const AIQuizScreen({super.key});

  @override
  State<AIQuizScreen> createState() => _AIQuizScreenState();
}

class _AIQuizScreenState extends State<AIQuizScreen> {
  int _currentIndex = 0;
  int? _selectedOption;
  bool _isSubmitted = false;
  int _score = 0;

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'Which algorithm is typically used for supervised classification tasks?',
      'options': ['Random Forest Classifier', 'K-Means Clustering', 'Apriori Algorithm', 'DBSCAN'],
      'correct': 0,
      'explanation': 'Random Forest is a supervised learning ensemble method suitable for classification.',
    },
    {
      'question': 'What is the primary function of a Convolutional Layer in CNNs?',
      'options': ['Feature Extraction', 'Dimensionality Reduction', 'Softmax Normalization', 'Gradient Clipping'],
      'correct': 0,
      'explanation': 'Convolutional layers extract local spatial features such as edges and textures.',
    },
    {
      'question': 'Which loss function is commonly used for binary classification in PyTorch/TensorFlow?',
      'options': ['Binary Cross-Entropy (BCE)', 'Mean Squared Error (MSE)', 'Categorical Cross-Entropy', 'Hinge Loss'],
      'correct': 0,
      'explanation': 'Binary Cross-Entropy measures the performance of a classification model whose output is a probability value between 0 and 1.',
    },
  ];

  void _submitAnswer() {
    if (_selectedOption == null) return;
    setState(() {
      _isSubmitted = true;
      if (_selectedOption == _questions[_currentIndex]['correct']) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedOption = null;
        _isSubmitted = false;
      });
    } else {
      _showResultDialog();
    }
  }

  void _showResultDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.darkCardSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: AppColors.cyberCyan)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.cyberCyan.withValues(alpha: 0.2)),
              child: const Icon(Icons.emoji_events_rounded, size: 56, color: AppColors.amberGold),
            ),
            const SizedBox(height: 16),
            Text('Quiz Completed!', style: AppTypography.header2()),
            const SizedBox(height: 8),
            Text('You scored $_score / ${_questions.length}', style: AppTypography.header1(color: AppColors.cyberCyan)),
            const SizedBox(height: 8),
            Text('Great job! Practice quiz results have been recorded in your AI Tutor profile.', textAlign: TextAlign.center, style: AppTypography.caption(color: AppColors.textSecondary)),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Done',
              gradient: AppColors.primaryGradient,
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
    final currentQ = _questions[_currentIndex];

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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                      onPressed: () => context.pop(),
                    ),
                    Text('AI Practice Quiz', style: AppTypography.header2()),
                    Text('${_currentIndex + 1}/${_questions.length}', style: AppTypography.subtitle(color: AppColors.cyberCyan)),
                  ],
                ),
                const SizedBox(height: 16),

                // Progress Bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (_currentIndex + 1) / _questions.length,
                    minHeight: 6,
                    backgroundColor: AppColors.darkCardSurface,
                    color: AppColors.cyberCyan,
                  ),
                ),
                const SizedBox(height: 24),

                // Question Card
                GlassmorphicCard(
                  borderColor: AppColors.cyberCyan.withValues(alpha: 0.4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Question ${_currentIndex + 1}', style: AppTypography.microTag(color: AppColors.cyberCyan)),
                      const SizedBox(height: 8),
                      Text(currentQ['question'] as String, style: AppTypography.subtitle()),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Options List
                Expanded(
                  child: ListView.builder(
                    itemCount: (currentQ['options'] as List).length,
                    itemBuilder: (context, idx) {
                      final optionText = (currentQ['options'] as List)[idx] as String;
                      final isSelected = _selectedOption == idx;
                      final isCorrect = idx == currentQ['correct'];

                      Color borderColor = AppColors.glassBorder;
                      Color bgColor = AppColors.darkCardSurface;

                      if (_isSubmitted) {
                        if (isCorrect) {
                          borderColor = AppColors.emeraldGreen;
                          bgColor = AppColors.emeraldGreen.withValues(alpha: 0.2);
                        } else if (isSelected && !isCorrect) {
                          borderColor = AppColors.coralRed;
                          bgColor = AppColors.coralRed.withValues(alpha: 0.2);
                        }
                      } else if (isSelected) {
                        borderColor = AppColors.cyberCyan;
                        bgColor = AppColors.cyberCyan.withValues(alpha: 0.15);
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: InkWell(
                          onTap: _isSubmitted ? null : () => setState(() => _selectedOption = idx),
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: borderColor, width: 1.5),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isSelected ? AppColors.cyberCyan : Colors.transparent,
                                    border: Border.all(color: isSelected ? AppColors.cyberCyan : AppColors.textMuted),
                                  ),
                                  child: Center(
                                    child: Text(
                                      String.fromCharCode(65 + idx),
                                      style: AppTypography.caption(color: isSelected ? Colors.black : Colors.white),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(child: Text(optionText, style: AppTypography.bodyStandard())),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                if (_isSubmitted) ...[
                  GlassmorphicCard(
                    padding: const EdgeInsets.all(14),
                    borderColor: AppColors.cyberCyan.withValues(alpha: 0.3),
                    child: Text('💡 Explanation: ${currentQ['explanation']}', style: AppTypography.caption(color: AppColors.cyberCyan)),
                  ),
                  const SizedBox(height: 16),
                ],

                CustomButton(
                  text: _isSubmitted ? (_currentIndex < _questions.length - 1 ? 'Next Question →' : 'Finish Quiz') : 'Submit Answer',
                  gradient: AppColors.aiGradient,
                  onPressed: _isSubmitted ? _nextQuestion : (_selectedOption != null ? _submitAnswer : null),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
