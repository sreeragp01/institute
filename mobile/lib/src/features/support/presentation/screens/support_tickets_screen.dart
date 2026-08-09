import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/glassmorphic_card.dart';
import '../../../../core/widgets/custom_button.dart';

class SupportTicketsScreen extends StatefulWidget {
  const SupportTicketsScreen({super.key});

  @override
  State<SupportTicketsScreen> createState() => _SupportTicketsScreenState();
}

class _SupportTicketsScreenState extends State<SupportTicketsScreen> {
  final List<Map<String, dynamic>> _tickets = [
    {
      'id': 101,
      'subject': 'Fee Receipt Verification Request',
      'category': 'Fee & Billing',
      'priority': 'Medium',
      'status': 'OPEN',
      'description': 'Requesting official digital stamp on Installment 1 receipt.',
      'time': '2 hours ago',
      'replies': [
        {'sender': 'SMEC Admin', 'msg': 'We are reviewing your payment record. Invoice will be emailed shorty.'}
      ]
    },
    {
      'id': 102,
      'subject': 'Lab 2 Workstation Account Access',
      'category': 'Technical & App Support',
      'priority': 'High',
      'status': 'IN_PROGRESS',
      'description': 'Unable to log into GPU Workstation 4 in AI Lab.',
      'time': 'Yesterday',
      'replies': [
        {'sender': 'IT Support', 'msg': 'System password reset initiated for workstation 4.'}
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Helpdesk & Support Tickets'),
        backgroundColor: AppColors.darkCardSurface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_comment_rounded, color: AppColors.cyberCyan),
            onPressed: _showNewTicketModal,
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.darkMeshGradient),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              GlassmorphicCard(
                borderColor: AppColors.cyberCyan.withValues(alpha: 0.3),
                child: Row(
                  children: [
                    const Icon(Icons.headset_mic_rounded, size: 36, color: AppColors.amberGold),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('SMEC Helpdesk & Resolution SLA', style: AppTypography.subtitle()),
                          const SizedBox(height: 4),
                          Text('Average response time: 4 hours • 24/7 Support', style: AppTypography.caption(color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Text('Your Active Tickets', style: AppTypography.subtitle()),
              const SizedBox(height: 12),

              ..._tickets.map((t) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GlassmorphicCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('#TICK-${t['id']}', style: AppTypography.caption(color: AppColors.cyberCyan)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.emeraldGreen.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(t['status'], style: AppTypography.microTag(color: AppColors.emeraldGreen)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(t['subject'], style: AppTypography.subtitle(color: Colors.white)),
                      const SizedBox(height: 4),
                      Text('${t['category']} • Priority: ${t['priority']}', style: AppTypography.caption(color: AppColors.textMuted)),
                      const SizedBox(height: 8),
                      Text(t['description'], style: AppTypography.bodyStandard(color: AppColors.textSecondary)),
                      const SizedBox(height: 12),

                      if ((t['replies'] as List).isNotEmpty)
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.darkBackground,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.glassBorder),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Latest Reply from ${t['replies'][0]['sender']}:', style: AppTypography.microTag(color: AppColors.amberGold)),
                              const SizedBox(height: 2),
                              Text(t['replies'][0]['msg'], style: AppTypography.caption(color: Colors.white)),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  void _showNewTicketModal() {
    final subjectCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    String category = 'Fee & Billing';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.darkCardSurface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, left: 24, right: 24, top: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Submit Support Ticket', style: AppTypography.header2()),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: category,
              dropdownColor: AppColors.darkCardSurface,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: 'Ticket Category'),
              items: const [
                DropdownMenuItem(value: 'Academic & Courses', child: Text('Academic & Courses')),
                DropdownMenuItem(value: 'Fee & Billing', child: Text('Fee & Billing')),
                DropdownMenuItem(value: 'Attendance Query', child: Text('Attendance Query')),
                DropdownMenuItem(value: 'Technical & App Support', child: Text('Technical & App Support')),
              ],
              onChanged: (val) => category = val ?? 'Fee & Billing',
            ),
            const SizedBox(height: 12),
            TextField(controller: subjectCtrl, decoration: const InputDecoration(hintText: 'Ticket Subject')),
            const SizedBox(height: 12),
            TextField(controller: descCtrl, maxLines: 3, decoration: const InputDecoration(hintText: 'Describe issue details...')),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Submit Ticket',
              gradient: AppColors.primaryGradient,
              onPressed: () {
                if (subjectCtrl.text.isNotEmpty) {
                  setState(() {
                    _tickets.insert(0, {
                      'id': 100 + _tickets.length + 1,
                      'subject': subjectCtrl.text,
                      'category': category,
                      'priority': 'Medium',
                      'status': 'OPEN',
                      'description': descCtrl.text,
                      'time': 'Just now',
                      'replies': []
                    });
                  });
                }
                Navigator.of(ctx).pop();
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
