import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/glassmorphic_card.dart';

class AuditLogScreen extends StatelessWidget {
  const AuditLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final logs = [
      {
        'actor': 'admin@smec.edu',
        'action': 'UPDATED_INSTITUTE_SETTINGS',
        'details': 'Updated primary brand colors and contact phone number.',
        'time': '10 mins ago',
        'ip': '127.0.0.1'
      },
      {
        'actor': 'trainer@smec.edu',
        'action': 'GENERATED_HMAC_QR_SESSION',
        'details': 'Created cryptographically signed session for Python (PY-201).',
        'time': '45 mins ago',
        'ip': '192.168.1.45'
      },
      {
        'actor': 'superadmin@smecconnect.com',
        'action': 'ALLOCATED_AI_CREDITS',
        'details': 'Allocated 5,000 monthly AI credits to SMEC Institute.',
        'time': '2 hours ago',
        'ip': '10.0.0.1'
      },
      {
        'actor': 'admin@smec.edu',
        'action': 'ONBOARDED_NEW_STUDENT',
        'details': 'Onboarded student Ananya Sharma (Roll: SMEC-2026-001).',
        'time': 'Yesterday',
        'ip': '127.0.0.1'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('System Audit Activity Logs'),
        backgroundColor: AppColors.darkCardSurface,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.darkMeshGradient),
        child: SafeArea(
          child: ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: logs.length,
            itemBuilder: (context, index) {
              final log = logs[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GlassmorphicCard(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.cyberCyan.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.security_rounded, color: AppColors.cyberCyan, size: 20),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(log['action']!, style: AppTypography.subtitle(color: AppColors.amberGold)),
                                Text(log['time']!, style: AppTypography.microTag(color: AppColors.textMuted)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text('Actor: ${log['actor']!}', style: AppTypography.caption(color: AppColors.cyberCyan)),
                            const SizedBox(height: 6),
                            Text(log['details']!, style: AppTypography.bodyStandard(color: AppColors.textSecondary)),
                            const SizedBox(height: 6),
                            Text('IP Address: ${log['ip']!}', style: AppTypography.microTag(color: AppColors.textMuted)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
