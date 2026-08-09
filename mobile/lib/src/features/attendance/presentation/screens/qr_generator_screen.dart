import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/glassmorphic_card.dart';

class QRGeneratorScreen extends StatefulWidget {
  const QRGeneratorScreen({super.key});

  @override
  State<QRGeneratorScreen> createState() => _QRGeneratorScreenState();
}

class _QRGeneratorScreenState extends State<QRGeneratorScreen> {
  int _secondsLeft = 10;
  Timer? _timer;
  String _qrData = 'SMEC-ATTENDANCE-SESSION-884219';

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_secondsLeft > 1) {
          _secondsLeft--;
        } else {
          _secondsLeft = 10;
          _qrData = 'SMEC-ATTENDANCE-SESSION-${DateTime.now().millisecondsSinceEpoch}';
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.darkMeshGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                      onPressed: () => context.pop(),
                    ),
                    const SizedBox(width: 8),
                    Text('Dynamic Session QR Generator', style: AppTypography.header2()),
                  ],
                ),
                const SizedBox(height: 30),

                // Batch & Subject Banner Card
                GlassmorphicCard(
                  borderColor: AppColors.cyberCyan.withValues(alpha: 0.5),
                  child: Column(
                    children: [
                      Text('Batch 2026-A • Computer Science', style: AppTypography.caption(color: AppColors.cyberCyan)),
                      const SizedBox(height: 4),
                      Text('Python Data Science (Session #42)', style: AppTypography.subtitle()),
                      const SizedBox(height: 4),
                      Text('Trainer: Prof. Rahul Nair', style: AppTypography.microTag(color: AppColors.textMuted)),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Center QR Code Canvas with Glowing Cyber Cyan Border
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.cyberCyan.withValues(alpha: 0.4),
                        blurRadius: 30,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: QrImageView(
                    data: _qrData,
                    version: QrVersions.auto,
                    size: 230.0,
                    eyeStyle: const QrEyeStyle(
                      eyeShape: QrEyeShape.square,
                      color: AppColors.primaryBlue,
                    ),
                    dataModuleStyle: const QrDataModuleStyle(
                      dataModuleShape: QrDataModuleShape.square,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Dynamic Countdown Bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.timer_outlined, color: AppColors.cyberCyan, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Refreshing QR token in $_secondsLeft seconds',
                      style: AppTypography.subtitle(color: AppColors.cyberCyan),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: SizedBox(
                    width: 200,
                    child: LinearProgressIndicator(
                      value: _secondsLeft / 10.0,
                      backgroundColor: AppColors.darkCardSurface,
                      color: AppColors.cyberCyan,
                      minHeight: 6,
                    ),
                  ),
                ),
                const Spacer(),

                // Live Attendance Counter
                GlassmorphicCard(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.people_alt_rounded, color: AppColors.emeraldGreen),
                      const SizedBox(width: 12),
                      Text('18 / 24 Students Marked Present', style: AppTypography.subtitle(color: AppColors.emeraldGreen)),
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
}
