import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/glassmorphic_card.dart';
import '../../../../core/widgets/custom_button.dart';

class AIStudyAssistantScreen extends StatefulWidget {
  const AIStudyAssistantScreen({super.key});

  @override
  State<AIStudyAssistantScreen> createState() => _AIStudyAssistantScreenState();
}

class _AIStudyAssistantScreenState extends State<AIStudyAssistantScreen> {
  final _notesController = TextEditingController();
  bool _isProcessing = false;
  Map<String, dynamic>? _aiResults;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _processNotes() async {
    setState(() => _isProcessing = true);
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isProcessing = false;
      _aiResults = {
        'summary': 'Machine Learning is a subset of AI enabling systems to learn patterns autonomously from data. Key methods include Supervised, Unsupervised, and Reinforcement Learning.',
        'flashcards': [
          {'front': 'Supervised Learning', 'back': 'Learning with labeled inputs & ground truth targets.'},
          {'front': 'Overfitting', 'back': 'Model memorizing noise; fix with regularization & dropout.'},
          {'front': 'Cross Validation', 'back': 'Evaluating generalization across k-folds of training data.'}
        ],
        'interview_questions': [
          'What is the difference between classification and regression?',
          'How do decision trees select split nodes?'
        ]
      };
    });
  }

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
                      icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                      onPressed: () => context.pop(),
                    ),
                    Text('AI Study Assistant', style: AppTypography.header2(color: AppColors.cyberCyan)),
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
                            Text('Paste Course Notes or Topics', style: AppTypography.subtitle(color: Colors.white)),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _notesController,
                              maxLines: 4,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'Paste lecture text, notes, or chapter concepts here...',
                                hintStyle: const TextStyle(color: Colors.white30),
                                filled: true,
                                fillColor: Colors.white.withValues(alpha: 0.06),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                              ),
                            ),
                            const SizedBox(height: 12),
                            CustomButton(
                              text: _isProcessing ? 'Analyzing Notes...' : 'Synthesize Study Pack',
                              onPressed: _isProcessing ? null : _processNotes,
                            ),

                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      if (_aiResults != null) ...[
                        Text('AI Summary', style: AppTypography.header2(color: AppColors.cyberCyan)),
                        const SizedBox(height: 8),
                        GlassmorphicCard(
                          child: Text(
                            _aiResults!['summary'],
                            style: AppTypography.bodyStandard(color: Colors.white70),
                          ),
                        ),
                        const SizedBox(height: 20),

                        Text('Generated Flashcards', style: AppTypography.header2(color: AppColors.amberGold)),
                        const SizedBox(height: 8),
                        ...(_aiResults!['flashcards'] as List).map((fc) => Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: GlassmorphicCard(
                            borderColor: AppColors.amberGold.withValues(alpha: 0.3),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Q: ${fc['front']}', style: AppTypography.subtitle(color: Colors.white)),
                                const SizedBox(height: 4),
                                Text('A: ${fc['back']}', style: AppTypography.caption(color: AppColors.cyberCyan)),
                              ],
                            ),
                          ),
                        )),
                        const SizedBox(height: 20),

                        Text('Interview Preparation Qs', style: AppTypography.header2(color: AppColors.emeraldGreen)),
                        const SizedBox(height: 8),
                        GlassmorphicCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: (_aiResults!['interview_questions'] as List)
                                .map((q) => Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 4),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.help_outline_rounded, size: 16, color: AppColors.emeraldGreen),
                                          const SizedBox(width: 8),
                                          Expanded(child: Text(q, style: AppTypography.caption(color: Colors.white))),
                                        ],
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
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
}
