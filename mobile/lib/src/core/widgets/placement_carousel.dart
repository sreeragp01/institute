import 'dart:async';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_typography.dart';
import 'glassmorphic_card.dart';

class PlacementCarouselWidget extends StatefulWidget {
  const PlacementCarouselWidget({super.key});

  @override
  State<PlacementCarouselWidget> createState() => _PlacementCarouselWidgetState();
}

class _PlacementCarouselWidgetState extends State<PlacementCarouselWidget> {
  final PageController _pageController = PageController(viewportFraction: 0.9);
  int _currentIndex = 0;
  Timer? _autoScrollTimer;

  final List<Map<String, dynamic>> _placementsData = [
    {
      'student_name': 'Rohan Varma',
      'role': 'SDE-II (Cloud Systems)',
      'company': 'Google India',
      'package': '₹24.5 LPA',
      'batch': 'CS-AI Batch 2026',
      'badge_color': AppColors.emeraldGreen,
      'avatar_icon': Icons.person_pin_rounded,
      'quote': '"SMEC mock interviews & AI tutor helped me crack Google SDE round!"',
    },
    {
      'student_name': 'Ananya Nair',
      'role': 'AI Research Engineer',
      'company': 'Microsoft Research',
      'package': '₹18.0 LPA',
      'batch': 'Data Science 2026',
      'badge_color': AppColors.cyberCyan,
      'avatar_icon': Icons.face_retouching_natural_rounded,
      'quote': '"From campus training to 18 LPA offer, grateful for the guidance."',
    },
    {
      'student_name': 'Adithya K. Sharma',
      'role': 'Full Stack Developer',
      'company': 'TechCorp AI Labs',
      'package': '₹14.5 LPA',
      'batch': 'B.Tech CS 2026',
      'badge_color': AppColors.amberGold,
      'avatar_icon': Icons.face_6_rounded,
      'quote': '"Secured placement before 7th semester thanks to early drives."',
    },
    {
      'student_name': 'Sneha Patel',
      'role': 'Cloud Solutions Architect',
      'company': 'Amazon AWS',
      'package': '₹16.0 LPA',
      'batch': 'DevOps Batch 2026',
      'badge_color': AppColors.electricPurple,
      'avatar_icon': Icons.face_3_rounded,
      'quote': '"Practical lab projects in SMEC gave me an edge during AWS interview."',
    },
  ];

  @override
  void initState() {
    super.initState();
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        final nextIndex = (_currentIndex + 1) % _placementsData.length;
        _pageController.animateToPage(
          nextIndex,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.stars_rounded, color: AppColors.amberGold, size: 22),
                  const SizedBox(width: 8),
                  Text('Placement Hall of Fame 🌟', style: AppTypography.subtitle()),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.cyberCyan.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '100% Placed',
                  style: AppTypography.microTag(color: AppColors.cyberCyan),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 175,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemCount: _placementsData.length,
            itemBuilder: (context, index) {
              final item = _placementsData[index];
              final Color color = item['badge_color'];

              return Container(
                margin: const EdgeInsets.only(right: 12),
                child: GlassmorphicCard(
                  borderColor: color.withValues(alpha: 0.5),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: color.withValues(alpha: 0.2),
                                  child: Icon(item['avatar_icon'], color: color, size: 22),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['student_name'],
                                        style: AppTypography.subtitle(color: AppColors.textPrimary),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        item['batch'],
                                        style: AppTypography.caption(color: AppColors.textMuted),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: color.withValues(alpha: 0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              item['package'],
                              style: AppTypography.caption(color: Colors.white).copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.business_rounded, color: color, size: 16),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              item['company'],
                              style: AppTypography.subtitle(color: color),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Text(' • ', style: TextStyle(color: AppColors.textMuted)),
                          Expanded(
                            child: Text(
                              item['role'],
                              style: AppTypography.caption(color: AppColors.textSecondary),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item['quote'],
                        style: AppTypography.microTag(color: AppColors.textMuted).copyWith(fontStyle: FontStyle.italic),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _placementsData.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentIndex == index ? 24 : 8,
              height: 6,
              decoration: BoxDecoration(
                color: _currentIndex == index ? AppColors.cyberCyan : AppColors.glassBorder,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
