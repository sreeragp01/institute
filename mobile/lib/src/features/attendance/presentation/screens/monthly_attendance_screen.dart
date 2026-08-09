import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/glassmorphic_card.dart';
import '../../../../core/widgets/custom_button.dart';

class MonthlyAttendanceScreen extends StatefulWidget {
  const MonthlyAttendanceScreen({super.key});

  @override
  State<MonthlyAttendanceScreen> createState() => _MonthlyAttendanceScreenState();
}

class _MonthlyAttendanceScreenState extends State<MonthlyAttendanceScreen> {
  final Map<int, String> _attendanceMap = {
    1: 'PRESENT', 2: 'HOLIDAY', 3: 'PRESENT', 4: 'PRESENT', 5: 'PRESENT', 6: 'ABSENT', 7: 'PRESENT',
    8: 'PRESENT', 9: 'HOLIDAY', 10: 'PRESENT', 11: 'PRESENT', 12: 'LEAVE', 13: 'PRESENT', 14: 'PRESENT',
    15: 'HOLIDAY', 16: 'PRESENT', 17: 'PRESENT', 18: 'ABSENT', 19: 'PRESENT', 20: 'PRESENT', 21: 'PRESENT',
    22: 'HOLIDAY', 23: 'PRESENT', 24: 'PRESENT', 25: 'PRESENT', 26: 'PRESENT', 27: 'PRESENT', 28: 'PRESENT',
    29: 'HOLIDAY', 30: 'PRESENT', 31: 'PRESENT',
  };

  void _inspectDay(int day) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.darkCardSurface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          final currentStatus = _attendanceMap[day]!;
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('August $day, 2026 Log', style: AppTypography.header2()),
                    _statusBadge(currentStatus),
                  ],
                ),
                const SizedBox(height: 16),
                _infoItem('Class Session', 'Python Data Science (Session #42)'),
                _infoItem('Check-In Time', currentStatus == 'PRESENT' ? '09:04 AM' : 'N/A'),
                _infoItem('Verification Method', currentStatus == 'PRESENT' ? 'Classroom QR Code Scan' : 'Trainer Record'),
                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: currentStatus == 'PRESENT' ? 'Unmark (Set Absent)' : 'Mark Present',
                        gradient: currentStatus == 'PRESENT' ? null : AppColors.primaryGradient,
                        isOutlined: currentStatus == 'PRESENT',
                        onPressed: () {
                          setState(() {
                            _attendanceMap[day] = currentStatus == 'PRESENT' ? 'ABSENT' : 'PRESENT';
                          });
                          setModalState(() {});
                          Navigator.of(ctx).pop();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _statusBadge(String status) {
    Color color = AppColors.emeraldGreen;
    if (status == 'ABSENT') color = AppColors.coralRed;
    if (status == 'LEAVE') color = AppColors.amberGold;
    if (status == 'HOLIDAY') color = AppColors.cyberCyan;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Text(status, style: AppTypography.microTag(color: color)),
    );
  }

  Widget _infoItem(String title, String val) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTypography.caption(color: AppColors.textMuted)),
          Text(val, style: AppTypography.subtitle(color: Colors.white)),
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
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                      onPressed: () => context.pop(),
                    ),
                    const SizedBox(width: 8),
                    Text('Monthly Attendance Calendar', style: AppTypography.header2()),
                  ],
                ),
                const SizedBox(height: 20),

                // Month Switcher Header
                GlassmorphicCard(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.chevron_left_rounded, color: AppColors.cyberCyan),
                      Text('August 2026', style: AppTypography.header2(color: AppColors.cyberCyan)),
                      const Icon(Icons.chevron_right_rounded, color: AppColors.cyberCyan),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Legend Bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _legendItem('Present', AppColors.emeraldGreen),
                    _legendItem('Absent', AppColors.coralRed),
                    _legendItem('Leave', AppColors.amberGold),
                    _legendItem('Holiday', AppColors.cyberCyan),
                  ],
                ),
                const SizedBox(height: 16),

                // 31-Day Calendar Grid
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: 31,
                    itemBuilder: (context, index) {
                      final day = index + 1;
                      final status = _attendanceMap[day] ?? 'PRESENT';

                      Color tileColor = AppColors.emeraldGreen;
                      if (status == 'ABSENT') tileColor = AppColors.coralRed;
                      if (status == 'LEAVE') tileColor = AppColors.amberGold;
                      if (status == 'HOLIDAY') tileColor = AppColors.cyberCyan;

                      return InkWell(
                        onTap: () => _inspectDay(day),
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: tileColor.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: tileColor, width: 1.5),
                          ),
                          child: Center(
                            child: Text(
                              '$day',
                              style: AppTypography.subtitle(color: Colors.white),
                            ),
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

  Widget _legendItem(String label, Color color) {
    return Row(
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(shape: BoxShape.circle, color: color)),
        const SizedBox(width: 4),
        Text(label, style: AppTypography.microTag(color: AppColors.textMuted)),
      ],
    );
  }
}
