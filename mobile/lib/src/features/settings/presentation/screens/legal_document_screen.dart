import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/glassmorphic_card.dart';

class LegalDocumentScreen extends StatelessWidget {
  final String docType;

  const LegalDocumentScreen({super.key, required this.docType});

  @override
  Widget build(BuildContext context) {
    String title = 'Terms of Service';
    String content = '';

    if (docType == 'privacy') {
      title = 'Privacy & Data Protection Policy';
      content = '''
LUMINORA TECHNOLOGIES - PRIVACY POLICY
Last Updated: August 04, 2026

1. DATA CONTROLLER & TENANT ISOLATION
Luminora Technologies ("Company", "We", "Our") operates SMEC Connect as a multi-tenant Educational ERP SaaS platform. Each educational institution ("Tenant") maintains full control and ownership of their student, faculty, and operational records.

2. INFORMATION WE COLLECT
- Institutional Account Data: Admin email, institute address, subscription details, contact credentials.
- Student & Staff Data: Student roll numbers, attendance records, exam submissions, fee installment status.
- AI Interaction Data: Prompts submitted to AI Study Assistant and AI Chatbot (processed strictly for output generation and not shared with third-party model training pipelines).

3. SECURITY & ENCRYPTION
All data transmitted between mobile clients and Luminora Cloud infrastructure is encrypted using TLS 1.3. Tenant data stored in database clusters is strictly segregated via Tenant Key Identifiers.

4. COMPLIANCE WITH INTERNATIONAL LAWS
We comply with international data privacy standards including GDPR, FERPA, and India DPDP Act 2023.

5. CONTACT & DATA RIGHTS
For data deletion or compliance inquiries, contact privacy@luminoratech.com.
''';
    } else if (docType == 'agreement') {
      title = 'Master Institutional SaaS Agreement';
      content = '''
LUMINORA TECHNOLOGIES - MASTER SAAS AGREEMENT
Target Platform: SMEC Connect

1. SERVICE PROVISION
Luminora Technologies grants the subscribing Institution a non-exclusive, non-transferable right to access and utilize SMEC Connect ERP services according to the selected Subscription Tier (Trial, Basic, Professional, Enterprise).

2. SLA & UPTIME GUARANTEE
Luminora Technologies guarantees 99.9% platform availability across all tier deployments. Scheduled system maintenance window notices are dispatched 48 hours in advance.

3. TENANT DATA OWNERSHIP
The Institution retains exclusive intellectual property and data ownership rights for all student profiles, exam records, fee receipts, and course materials uploaded to the platform.

4. AI CREDITS & USAGE LIMITS
AI Study Assistant, Attendance Predictor, and Chatbot queries consume allocated monthly AI credits according to the Institution's active subscription plan.

5. GOVERNING LAW
This Master SaaS Agreement is governed by the laws of India.
''';
    } else {
      title = 'Terms of Service & AUP';
      content = '''
LUMINORA TECHNOLOGIES - TERMS OF SERVICE
Platform: SMEC Connect (One Platform. Every Institute.)

1. ACCEPTANCE OF TERMS
By accessing or using the SMEC Connect mobile application or web portal, you agree to be bound by these Terms of Service issued by Luminora Technologies.

2. USER ACCOUNTS & SECURITY
Users are responsible for maintaining confidentiality of login credentials (Email, OTP, Password) and for all activities occurring under their accounts.

3. PROHIBITED CONDUCT
Users shall not attempt unauthorized access to another institute's tenant data, reverse engineer platform source code, or submit malicious payloads to AI modules.

4. COPYRIGHT & TRADEMARKS
SMEC Connect, Luminora AI Engine, and associated logos are registered trademarks of Luminora Technologies © 2026. All rights reserved.
''';
    }

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
                      icon: const Icon(Icons.arrow_back_rounded, color: AppColors.primaryNavy),
                      onPressed: () => context.pop(),
                    ),
                    Expanded(
                      child: Text(
                        title,
                        style: AppTypography.header2(color: AppColors.textPrimary),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: GlassmorphicCard(
                    borderColor: AppColors.cyberCyan.withValues(alpha: 0.3),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.verified_user_rounded, color: AppColors.primaryNavy, size: 24),
                            const SizedBox(width: 8),
                            Text('SMEC Technologies Compliance', style: AppTypography.caption(color: AppColors.primaryNavy)),
                          ],
                        ),
                        const Divider(color: AppColors.glassBorder, height: 20),
                        SelectableText(
                          content,
                          style: AppTypography.caption(color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 24),
                        Center(
                          child: Text(
                            'Designed & Engineered by Luminora Technologies © 2026\nAll rights reserved.',
                            textAlign: TextAlign.center,
                            style: AppTypography.microTag(color: AppColors.textMuted),
                          ),
                        ),
                      ],
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
