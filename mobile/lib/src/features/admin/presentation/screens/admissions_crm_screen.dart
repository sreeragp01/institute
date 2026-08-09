import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/glassmorphic_card.dart';
import '../../../../core/widgets/custom_button.dart';

class AdmissionsCRMScreen extends StatefulWidget {
  const AdmissionsCRMScreen({super.key});

  @override
  State<AdmissionsCRMScreen> createState() => _AdmissionsCRMScreenState();
}

class _AdmissionsCRMScreenState extends State<AdmissionsCRMScreen> {
  final List<Map<String, dynamic>> _enquiries = [
    {
      'id': 1,
      'name': 'Rohan Kumar',
      'email': 'rohan@gmail.com',
      'phone': '+91 9876001122',
      'course': 'Computer Science & AI',
      'source': 'Website',
      'status': 'NEW',
      'notes': 'Inquired about batch timings and scholarship eligibility.'
    },
    {
      'id': 2,
      'name': 'Sneha Patel',
      'email': 'sneha.p@outlook.com',
      'phone': '+91 9123456789',
      'course': 'Python & Data Science',
      'source': 'Referral',
      'status': 'CONTACTED',
      'notes': 'Followed up via phone. Counseling scheduled for Friday.'
    },
    {
      'id': 3,
      'name': 'Arjun Menon',
      'email': 'arjun.m@gmail.com',
      'phone': '+91 9988776655',
      'course': 'Cloud Computing & DevOps',
      'source': 'Walk-in',
      'status': 'COUNSELED',
      'notes': 'Visited Ernakulam campus. Interested in morning batch.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admissions Lead CRM'),
        backgroundColor: AppColors.darkCardSurface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt_1_rounded, color: AppColors.cyberCyan),
            onPressed: _showAddEnquiryModal,
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.darkMeshGradient),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // Pipeline Summary Grid
              Row(
                children: [
                  Expanded(child: _statusBadge('New Leads', '${_enquiries.where((e) => e['status'] == 'NEW').length}', AppColors.cyberCyan)),
                  const SizedBox(width: 12),
                  Expanded(child: _statusBadge('Contacted', '${_enquiries.where((e) => e['status'] == 'CONTACTED').length}', AppColors.amberGold)),
                  const SizedBox(width: 12),
                  Expanded(child: _statusBadge('Counseled', '${_enquiries.where((e) => e['status'] == 'COUNSELED').length}', AppColors.emeraldGreen)),
                ],
              ),
              const SizedBox(height: 24),

              Text('Prospect Student Enquiries', style: AppTypography.subtitle()),
              const SizedBox(height: 12),

              ..._enquiries.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GlassmorphicCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(e['name'], style: AppTypography.subtitle(color: Colors.white)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getStatusColor(e['status']).withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: _getStatusColor(e['status'])),
                            ),
                            child: Text(e['status'], style: AppTypography.microTag(color: _getStatusColor(e['status']))),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text('${e['course']} • Source: ${e['source']}', style: AppTypography.caption(color: AppColors.cyberCyan)),
                      const SizedBox(height: 4),
                      Text('Contact: ${e['phone']} | ${e['email']}', style: AppTypography.caption(color: AppColors.textSecondary)),
                      const SizedBox(height: 8),
                      Text(e['notes'], style: AppTypography.microTag(color: AppColors.textMuted)),
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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'NEW':
        return AppColors.cyberCyan;
      case 'CONTACTED':
        return AppColors.amberGold;
      case 'COUNSELED':
        return AppColors.emeraldGreen;
      default:
        return AppColors.textMuted;
    }
  }

  Widget _statusBadge(String title, String count, Color color) {
    return GlassmorphicCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Text(count, style: AppTypography.header1(color: color)),
          const SizedBox(height: 4),
          Text(title, style: AppTypography.caption(color: AppColors.textMuted)),
        ],
      ),
    );
  }

  void _showAddEnquiryModal() {
    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final courseCtrl = TextEditingController(text: 'Computer Science & AI');

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
            Text('Add Prospective Student Enquiry', style: AppTypography.header2()),
            const SizedBox(height: 16),
            TextField(controller: nameCtrl, decoration: const InputDecoration(hintText: 'Candidate Full Name')),
            const SizedBox(height: 12),
            TextField(controller: emailCtrl, decoration: const InputDecoration(hintText: 'Email Address')),
            const SizedBox(height: 12),
            TextField(controller: phoneCtrl, decoration: const InputDecoration(hintText: 'Phone Number')),
            const SizedBox(height: 12),
            TextField(controller: courseCtrl, decoration: const InputDecoration(hintText: 'Interested Course')),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Save Lead to CRM',
              onPressed: () {
                if (nameCtrl.text.isNotEmpty) {
                  setState(() {
                    _enquiries.insert(0, {
                      'id': _enquiries.length + 1,
                      'name': nameCtrl.text,
                      'email': emailCtrl.text,
                      'phone': phoneCtrl.text,
                      'course': courseCtrl.text,
                      'source': 'Direct Walk-in',
                      'status': 'NEW',
                      'notes': 'Added via Admissions CRM Mobile Lead Capture.',
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
