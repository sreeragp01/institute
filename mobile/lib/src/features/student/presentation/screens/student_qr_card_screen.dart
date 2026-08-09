import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/glassmorphic_card.dart';

class StudentQRCardScreen extends StatelessWidget {
  const StudentQRCardScreen({super.key});

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
                    Text('Digital Student ID Card', style: AppTypography.header2(color: AppColors.cyberCyan)),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: GlassmorphicCard(
                      borderColor: AppColors.cyberCyan,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: AppColors.aiGradient,
                            ),
                            child: const CircleAvatar(
                              radius: 40,
                              backgroundColor: AppColors.darkSurface,
                              child: Icon(Icons.person_rounded, size: 48, color: AppColors.cyberCyan),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text('Ananya Sharma', style: AppTypography.header1(color: Colors.white)),
                          const SizedBox(height: 4),
                          Text('Roll No: SMEC-2026-001', style: AppTypography.subtitle(color: AppColors.cyberCyan)),
                          Text('Course: Computer Science & AI', style: AppTypography.caption(color: AppColors.textMuted)),
                          Text('Institute: SMEC Institute of Technology', style: AppTypography.microTag(color: Colors.white60)),
                          const SizedBox(height: 24),

                          // QR Display Container
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(Icons.qr_code_2_rounded, size: 160, color: Colors.black),
                          ),
                          const SizedBox(height: 16),
                          Text('Scan for Instant Verification', style: AppTypography.caption(color: AppColors.emeraldGreen)),
                          Text('Valid Until: June 2027', style: AppTypography.microTag(color: AppColors.textMuted)),
                        ],
                      ),
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
}
