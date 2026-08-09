import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/glassmorphic_card.dart';
import '../providers/auth_provider.dart';

class RoleSelectionScreen extends ConsumerWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.darkMeshGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('SMEC Connect', style: AppTypography.microTag(color: AppColors.cyberCyan)),
                        Text(
                          authState.fullName ?? authState.email ?? 'Workspace User',
                          style: AppTypography.header2(color: Colors.white),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.settings_rounded, color: AppColors.cyberCyan),
                          onPressed: () => context.push('/settings'),
                        ),
                        IconButton(
                          icon: const Icon(Icons.logout_rounded, color: AppColors.coralRed),
                          onPressed: () async {
                            await ref.read(authProvider.notifier).logout();
                            if (context.mounted) context.go('/login');
                          },
                        ),
                      ],
                    ),

                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Select Role Portal',
                  style: AppTypography.header2(),
                ),
                Text(
                  'One Platform. Every Institute. Switch workspace view.',
                  style: AppTypography.caption(color: AppColors.textMuted),
                ),
                const SizedBox(height: 16),

                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isDesktop = constraints.maxWidth > 800;
                      final isTablet = constraints.maxWidth > 500;
                      final crossCount = isDesktop ? 3 : (isTablet ? 3 : 2);
                      final ratio = isDesktop ? 1.4 : (isTablet ? 1.2 : 0.95);

                      return GridView.count(
                        crossAxisCount: crossCount,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: ratio,
                        children: [
                          _buildWorkspaceCard(
                            context,
                            title: 'Super Admin',
                            subtitle: 'Platform SaaS Console',
                            icon: Icons.hub_rounded,
                            color: AppColors.electricPurple,
                            route: '/super-admin',
                          ),
                          _buildWorkspaceCard(
                            context,
                            title: 'Institute Admin',
                            subtitle: 'Institute Dashboard',
                            icon: Icons.admin_panel_settings_rounded,
                            color: AppColors.primaryBlue,
                            route: '/admin-dashboard',
                          ),
                          _buildWorkspaceCard(
                            context,
                            title: 'Trainer App',
                            subtitle: 'Classes & Roll Call',
                            icon: Icons.psychology_rounded,
                            color: AppColors.emeraldGreen,
                            route: '/staff-dashboard',
                          ),
                          _buildWorkspaceCard(
                            context,
                            title: 'Student App',
                            subtitle: 'Courses & AI Assistant',
                            icon: Icons.person_rounded,
                            color: AppColors.cyberCyan,
                            route: '/student-dashboard',
                          ),
                          _buildWorkspaceCard(
                            context,
                            title: 'Parent App',
                            subtitle: 'Child Attendance & Fees',
                            icon: Icons.family_restroom_rounded,
                            color: AppColors.amberGold,
                            route: '/parent-dashboard',
                          ),
                          _buildWorkspaceCard(
                            context,
                            title: 'Placements Cell',
                            subtitle: 'Hiring & Career Drives',
                            icon: Icons.work_history_rounded,
                            color: AppColors.coralRed,
                            route: '/placements',
                          ),
                        ],
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

  Widget _buildWorkspaceCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required String route,
  }) {
    return GlassmorphicCard(
      borderColor: color.withValues(alpha: 0.4),
      onTap: () => context.go(route),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: color.withValues(alpha: 0.3)),
            ),
            child: Icon(icon, size: 24, color: color),
          ),
          const Spacer(),
          Text(title, style: AppTypography.subtitle(color: Colors.white)),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: AppTypography.microTag(color: AppColors.textMuted),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text('Launch', style: AppTypography.caption(color: color)),
              const SizedBox(width: 4),
              Icon(Icons.arrow_forward_rounded, size: 12, color: color),
            ],
          ),
        ],
      ),
    );
  }
}
