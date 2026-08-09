import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/glassmorphic_card.dart';
import '../../../../core/widgets/custom_button.dart';

class CertificateVerificationScreen extends StatefulWidget {
  const CertificateVerificationScreen({super.key});

  @override
  State<CertificateVerificationScreen> createState() => _CertificateVerificationScreenState();
}

class _CertificateVerificationScreenState extends State<CertificateVerificationScreen> {
  final _codeController = TextEditingController();
  bool _isVerifying = false;
  Map<String, dynamic>? _verifiedData;
  String? _errorMessage;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _verifyCertificate() async {
    final code = _codeController.text.trim();
    if (code.isEmpty) return;

    setState(() {
      _isVerifying = true;
      _errorMessage = null;
    });

    await Future.delayed(const Duration(seconds: 1));

    if (code.toUpperCase() == 'VERIFY-SMEC-2026' || code.toUpperCase() == 'CERT-1234') {
      setState(() {
        _isVerifying = false;
        _verifiedData = {
          'certificate_number': 'CERT-SMEC-8899',
          'certificate_type': 'Course Completion Certificate',
          'student_name': 'Ananya Sharma',
          'institute_name': 'SMEC Institute of Technology',
          'institute_code': 'SMEC',
          'course_name': 'Computer Science & AI',
          'issue_date': '2026-08-01',
          'status': 'VERIFIED_GENUINE'
        };
      });
    } else {
      setState(() {
        _isVerifying = false;
        _errorMessage = 'Invalid or non-existent certificate verification code.';
      });
    }
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
                    Text('QR Certificate Verification', style: AppTypography.header2(color: AppColors.cyberCyan)),
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
                            Text('Verify Credential Authenticity', style: AppTypography.subtitle(color: Colors.white)),
                            const SizedBox(height: 4),
                            Text('Enter verification code or scan QR from issued certificate.', style: AppTypography.caption(color: AppColors.textMuted)),
                            const SizedBox(height: 16),
                            TextField(
                              controller: _codeController,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'e.g. VERIFY-SMEC-2026',
                                hintStyle: const TextStyle(color: Colors.white30),
                                prefixIcon: const Icon(Icons.verified_rounded, color: AppColors.cyberCyan),
                                filled: true,
                                fillColor: Colors.white.withValues(alpha: 0.06),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                              ),
                            ),
                            const SizedBox(height: 16),
                            CustomButton(
                              text: _isVerifying ? 'Verifying on Ledger...' : 'Verify Certificate',
                              onPressed: _isVerifying ? null : _verifyCertificate,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      if (_errorMessage != null) ...[
                        GlassmorphicCard(
                          borderColor: AppColors.coralRed,
                          child: Row(
                            children: [
                              const Icon(Icons.error_outline_rounded, color: AppColors.coralRed, size: 28),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(_errorMessage!, style: AppTypography.caption(color: AppColors.coralRed)),
                              ),
                            ],
                          ),
                        ),
                      ],

                      if (_verifiedData != null) ...[
                        GlassmorphicCard(
                          borderColor: AppColors.emeraldGreen,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.verified_rounded, color: AppColors.emeraldGreen, size: 28),
                                  const SizedBox(width: 8),
                                  Text('GENUINE CERTIFICATE VERIFIED', style: AppTypography.subtitle(color: AppColors.emeraldGreen)),
                                ],
                              ),
                              const Divider(color: Colors.white12, height: 20),
                              _buildCertDetail('Recipient', _verifiedData!['student_name']),
                              _buildCertDetail('Certificate Type', _verifiedData!['certificate_type']),
                              _buildCertDetail('Institution', _verifiedData!['institute_name']),
                              _buildCertDetail('Course', _verifiedData!['course_name']),
                              _buildCertDetail('Cert Number', _verifiedData!['certificate_number']),
                              _buildCertDetail('Issued Date', _verifiedData!['issue_date']),
                            ],
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

  Widget _buildCertDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.caption(color: AppColors.textMuted)),
          Text(value, style: AppTypography.subtitle(color: Colors.white)),
        ],
      ),
    );
  }
}
