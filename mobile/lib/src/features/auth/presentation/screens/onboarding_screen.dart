import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/glassmorphic_card.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      'icon': Icons.psychology_rounded,
      'title': 'Meet Your 24/7 Personal AI Tutor',
      'description': 'Instantly resolve subject doubts, summarize complex course notes, and generate auto-quizzes tailored to your syllabus.',
      'bullets': ['Automated quiz generation', 'Real-time subject Q&A', 'Smart study schedule builder'],
    },
    {
      'icon': Icons.qr_code_scanner_rounded,
      'title': 'One-Tap QR Attendance & Job Placements',
      'description': 'Mark session attendance instantly via QR code scan and receive real-time placement drive alerts and resume recommendations.',
      'bullets': ['Instant parent/student notifications', 'Direct placement drive schedules', 'Digital fee receipts & history'],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.darkMeshGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Top Bar with Skip Button & Dots Indicator
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: List.generate(
                        _pages.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.only(right: 8),
                          width: _currentPage == index ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _currentPage == index ? AppColors.cyberCyan : AppColors.textMuted,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.go('/login'),
                      child: Text('Skip', style: AppTypography.subtitle(color: AppColors.textMuted)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) => setState(() => _currentPage = index),
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    final item = _pages[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GlassmorphicCard(
                            borderColor: AppColors.glassBorderActive,
                            padding: const EdgeInsets.all(40),
                            child: Icon(
                              item['icon'] as IconData,
                              size: 80,
                              color: AppColors.cyberCyan,
                            ),
                          ),
                          const SizedBox(height: 40),
                          Text(
                            item['title'] as String,
                            textAlign: TextAlign.center,
                            style: AppTypography.header1(),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            item['description'] as String,
                            textAlign: TextAlign.center,
                            style: AppTypography.bodyLarge(),
                          ),
                          const SizedBox(height: 24),
                          Column(
                            children: (item['bullets'] as List<String>)
                                .map(
                                  (b) => Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.check_circle_rounded, size: 18, color: AppColors.emeraldGreen),
                                        const SizedBox(width: 10),
                                        Text(b, style: AppTypography.bodyStandard(color: AppColors.textPrimary)),
                                      ],
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              // Bottom Action CTA Button
              Padding(
                padding: const EdgeInsets.all(24),
                child: CustomButton(
                  text: _currentPage == _pages.length - 1 ? 'Explore SMEC Connect' : 'Next →',
                  gradient: AppColors.aiGradient,
                  onPressed: () {
                    if (_currentPage < _pages.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      context.go('/login');
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
