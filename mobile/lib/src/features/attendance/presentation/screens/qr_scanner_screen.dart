import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/custom_button.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final MobileScannerController _cameraController = MobileScannerController();
  bool _isScanned = false;

  void _onDetect(BarcodeCapture capture) {
    if (_isScanned) return;
    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
      setState(() => _isScanned = true);
      _showSuccessModal(barcodes.first.rawValue!);
    }
  }

  void _showSuccessModal(String codeData) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.darkCardSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.emeraldGreen, width: 1.5),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.emeraldGreen.withValues(alpha: 0.2),
              ),
              child: const Icon(Icons.check_circle_rounded, size: 56, color: AppColors.emeraldGreen),
            ),
            const SizedBox(height: 20),
            Text('Attendance Marked Present!', style: AppTypography.header2(color: Colors.white)),
            const SizedBox(height: 8),
            Text(
              'Session: Python Data Science\nTime: 10:04 AM • Room Lab 3',
              textAlign: TextAlign.center,
              style: AppTypography.bodyStandard(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
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
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Live Camera Stream
          MobileScanner(
            controller: _cameraController,
            onDetect: _onDetect,
          ),

          // Dark Overlay with Cutout Bounding Box
          Center(
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.cyberCyan, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.cyberCyan.withValues(alpha: 0.3),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ),

          // Header Controls
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                    onPressed: () => context.pop(),
                  ),
                  Text('Scan Session QR', style: AppTypography.subtitle(color: Colors.white)),
                  IconButton(
                    icon: ValueListenableBuilder(
                      valueListenable: _cameraController,
                      builder: (context, state, child) {
                        return Icon(
                          state.torchState == TorchState.on ? Icons.flash_on_rounded : Icons.flash_off_rounded,
                          color: AppColors.cyberCyan,
                        );
                      },
                    ),
                    onPressed: () => _cameraController.toggleTorch(),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Instruction Banner
          Positioned(
            bottom: 48,
            left: 24,
            right: 24,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.darkCardSurface.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.glassBorder),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.qr_code_scanner_rounded, color: AppColors.cyberCyan, size: 20),
                  const SizedBox(width: 10),
                  Text('Align trainer QR code inside the box frame', style: AppTypography.caption(color: Colors.white)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
