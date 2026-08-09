import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/glassmorphic_card.dart';

class SuperAdminConsoleScreen extends StatefulWidget {
  const SuperAdminConsoleScreen({super.key});

  @override
  State<SuperAdminConsoleScreen> createState() => _SuperAdminConsoleScreenState();
}

class _SuperAdminConsoleScreenState extends State<SuperAdminConsoleScreen> {
  final List<Map<String, dynamic>> _institutes = [
    {
      'name': 'SMEC Institute of Technology',
      'code': 'SMEC',
      'color': '#1E40AF',
      'status': 'ACTIVE',
      'students': 480,
      'courses': 12,
    },
    {
      'name': 'Apex Learning Academy',
      'code': 'APEX',
      'color': '#7C3AED',
      'status': 'ACTIVE',
      'students': 210,
      'courses': 6,
    },
  ];

  void _showOnboardDialog() {
    final nameCtrl = TextEditingController();
    final codeCtrl = TextEditingController();
    final colorCtrl = TextEditingController(text: '#10B981');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.darkCardSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: AppColors.cyberCyan)),
        title: Text('Onboard New Institute Tenant', style: AppTypography.header2()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Institute Name', style: AppTypography.subtitle()),
            const SizedBox(height: 6),
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(hintText: 'e.g. MIT Institute of Science'),
            ),
            const SizedBox(height: 14),
            Text('Institute Code (Subdomain Slug)', style: AppTypography.subtitle()),
            const SizedBox(height: 6),
            TextField(
              controller: codeCtrl,
              decoration: const InputDecoration(hintText: 'e.g. MIT'),
            ),
            const SizedBox(height: 14),
            Text('Primary Brand Color Hex', style: AppTypography.subtitle()),
            const SizedBox(height: 6),
            TextField(
              controller: colorCtrl,
              decoration: const InputDecoration(hintText: '#10B981'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cancel', style: AppTypography.caption(color: AppColors.textMuted)),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.isNotEmpty && codeCtrl.text.isNotEmpty) {
                setState(() {
                  _institutes.add({
                    'name': nameCtrl.text,
                    'code': codeCtrl.text.toUpperCase(),
                    'color': colorCtrl.text,
                    'status': 'ACTIVE',
                    'students': 0,
                    'courses': 0,
                  });
                });
                Navigator.of(ctx).pop();
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryBlue),
            child: const Text('Provision Tenant'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                          onPressed: () => context.pop(),
                        ),
                        const SizedBox(width: 8),
                        Text('Super Admin Platform Console', style: AppTypography.header2()),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_business_rounded, color: AppColors.cyberCyan),
                      onPressed: _showOnboardDialog,
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Platform Summary Card
                GlassmorphicCard(
                  borderColor: AppColors.cyberCyan.withValues(alpha: 0.4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _platformStat('${_institutes.length}', 'Active Institutes', AppColors.cyberCyan),
                      _platformStat('690', 'Total Students', AppColors.emeraldGreen),
                      _platformStat('100%', 'Data Isolation', AppColors.amberGold),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Onboarded Institutes', style: AppTypography.subtitle()),
                    GestureDetector(
                      onTap: _showOnboardDialog,
                      child: Text('+ Onboard Tenant', style: AppTypography.caption(color: AppColors.cyberCyan)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                Expanded(
                  child: ListView.builder(
                    itemCount: _institutes.length,
                    itemBuilder: (context, index) {
                      final inst = _institutes[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: GlassmorphicCard(
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.cyberCyan.withValues(alpha: 0.15),
                                  border: Border.all(color: AppColors.cyberCyan),
                                ),
                                child: Center(
                                  child: Text(
                                    inst['code'] as String,
                                    style: AppTypography.caption(color: AppColors.cyberCyan),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(inst['name'] as String, style: AppTypography.subtitle()),
                                    Text(
                                      'Code: ${inst['code']} • ${inst['students']} Enrolled Students',
                                      style: AppTypography.caption(color: AppColors.textSecondary),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.emeraldGreen.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text('ACTIVE', style: AppTypography.microTag(color: AppColors.emeraldGreen)),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _platformStat(String val, String label, Color color) {
    return Column(
      children: [
        Text(val, style: AppTypography.header2(color: color)),
        const SizedBox(height: 2),
        Text(label, style: AppTypography.microTag(color: AppColors.textMuted)),
      ],
    );
  }
}
