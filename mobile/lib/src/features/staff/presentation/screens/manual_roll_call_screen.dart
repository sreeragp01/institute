import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/glassmorphic_card.dart';
import '../../../../core/widgets/custom_button.dart';

class StudentRollItem {
  final String id;
  final String name;
  final String rollNo;
  bool isPresent;

  StudentRollItem({required this.id, required this.name, required this.rollNo, required this.isPresent});
}

class ManualRollCallScreen extends StatefulWidget {
  const ManualRollCallScreen({super.key});

  @override
  State<ManualRollCallScreen> createState() => _ManualRollCallScreenState();
}

class _ManualRollCallScreenState extends State<ManualRollCallScreen> {
  final List<StudentRollItem> _students = [
    StudentRollItem(id: '1', name: 'Ananya Sharma', rollNo: 'SMEC-2026-0042', isPresent: true),
    StudentRollItem(id: '2', name: 'Vihan Verma', rollNo: 'SMEC-2026-0043', isPresent: true),
    StudentRollItem(id: '3', name: 'Rahul Patel', rollNo: 'SMEC-2026-0044', isPresent: false),
    StudentRollItem(id: '4', name: 'Priya Sundaram', rollNo: 'SMEC-2026-0045', isPresent: true),
    StudentRollItem(id: '5', name: 'Kiran Kumar', rollNo: 'SMEC-2026-0046', isPresent: false),
  ];

  void _saveRollCall() {
    final presentCount = _students.where((s) => s.isPresent).length;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.darkCardSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: AppColors.emeraldGreen)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_rounded, size: 56, color: AppColors.emeraldGreen),
            const SizedBox(height: 16),
            Text('Manual Roll Call Saved!', style: AppTypography.header2()),
            const SizedBox(height: 8),
            Text('Session: Python Data Science\n$presentCount of ${_students.length} Students Marked Present', textAlign: TextAlign.center, style: AppTypography.caption(color: AppColors.textSecondary)),
            const SizedBox(height: 20),
            CustomButton(
              text: 'OK',
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
  Widget build(BuildContext context) {
    final presentCount = _students.where((s) => s.isPresent).length;

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
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.cyberCyan, size: 20),
                      onPressed: () => context.pop(),
                    ),
                    const SizedBox(width: 8),
                    Text('Trainer Manual Roll Call', style: AppTypography.header2()),
                  ],
                ),
                const SizedBox(height: 20),

                // Session Summary Card
                GlassmorphicCard(
                  borderColor: AppColors.emeraldGreen.withValues(alpha: 0.4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Python Data Science (Session #42)', style: AppTypography.subtitle()),
                          Text('Batch 2026-A • Today 10:00 AM', style: AppTypography.caption(color: AppColors.textMuted)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.emeraldGreen.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text('$presentCount / ${_students.length} Present', style: AppTypography.caption(color: AppColors.emeraldGreen)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                Text('Student Class Roster', style: AppTypography.subtitle()),
                const SizedBox(height: 12),

                Expanded(
                  child: ListView.builder(
                    itemCount: _students.length,
                    itemBuilder: (context, idx) {
                      final s = _students[idx];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: GlassmorphicCard(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(s.name, style: AppTypography.subtitle()),
                                  Text(s.rollNo, style: AppTypography.caption(color: AppColors.textMuted)),
                                ],
                              ),
                              Switch(
                                value: s.isPresent,
                                activeThumbColor: AppColors.emeraldGreen,
                                inactiveThumbColor: AppColors.coralRed,
                                onChanged: (val) {
                                  setState(() => s.isPresent = val);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                CustomButton(
                  text: 'Submit Roll Call Attendance',
                  gradient: AppColors.primaryGradient,
                  onPressed: _saveRollCall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
