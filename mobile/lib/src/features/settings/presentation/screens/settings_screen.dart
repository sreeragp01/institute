import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/glassmorphic_card.dart';
import '../providers/language_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _biometricLock = true;
  bool _twoFactorAuth = false;
  bool _pushNotifications = true;


  void _showLanguageSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.darkCardSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Select Language', style: AppTypography.header2(color: AppColors.primaryNavy)),
              Text('Choose your preferred display language', style: AppTypography.caption(color: AppColors.textMuted)),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: supportedLanguages.length,
                  itemBuilder: (context, index) {
                    final lang = supportedLanguages[index];
                    final currentLang = ref.watch(languageProvider);
                    final isSelected = currentLang.code == lang.code;

                    return ListTile(
                      leading: Text(lang.flag, style: const TextStyle(fontSize: 24)),
                      title: Text(lang.name, style: AppTypography.subtitle(color: AppColors.textPrimary)),
                      trailing: isSelected ? const Icon(Icons.check_circle_rounded, color: AppColors.primaryNavy) : null,
                      onTap: () {
                        ref.read(languageProvider.notifier).setLanguage(lang);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Language switched to ${lang.name}')),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showFeatureIdeaDialog(String title, String desc) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.darkCardSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: AppColors.primaryNavy)),
        title: Text(title, style: AppTypography.header2(color: AppColors.primaryNavy)),
        content: Text(desc, style: AppTypography.caption(color: AppColors.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: AppTypography.caption(color: AppColors.primaryNavy)),
          ),
        ],
      ),
    );
  }
  void _showCoursesListModal() {
    final List<String> courses = [
      '.Net Fullstack with Gen AI',
      "Master's in Advanced AI & Big Data Analytics",
      'Data Analytics with Prompt Engineering',
      'UI/UX Design with Gen AI',
      'Flutter Development with Gen AI',
      'ME(A)RN Stack with Gen AI',
      'Python Fullstack with Gen AI',
      'Software Testing with Gen AI',
      'Data Science / AI / ML with Gen AI',
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.darkCardSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('SMEC Gen AI Enabled Courses', style: AppTypography.header2(color: AppColors.amberGold)),
                const Icon(Icons.auto_awesome_rounded, color: AppColors.amberGold),
              ],
            ),
            const SizedBox(height: 6),
            Text('Industry-Aligned Programs with Generative AI Integration', style: AppTypography.caption(color: AppColors.textMuted)),
            const SizedBox(height: 16),
            SizedBox(
              height: 320,
              child: ListView.separated(
                itemCount: courses.length,
                separatorBuilder: (ctx, i) => const Divider(color: AppColors.glassBorder, height: 12),
                itemBuilder: (ctx, index) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      radius: 16,
                      backgroundColor: AppColors.amberGold.withValues(alpha: 0.15),
                      child: Text('${index + 1}', style: AppTypography.caption(color: AppColors.amberGold)),
                    ),
                    title: Text(courses[index], style: AppTypography.subtitle(color: AppColors.textPrimary)),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textMuted),
                    onTap: () {
                      Navigator.pop(ctx);
                      context.push('/contact');
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeLanguage = ref.watch(languageProvider);

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
                    Text('App Settings & Preferences', style: AppTypography.header2(color: AppColors.textPrimary)),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Language Selector Card
                      GlassmorphicCard(
                        borderColor: AppColors.cyberCyan,
                        onTap: _showLanguageSelector,
                        child: Row(
                          children: [
                            Text(activeLanguage.flag, style: const TextStyle(fontSize: 28)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('App Language', style: AppTypography.caption(color: AppColors.textMuted)),
                                  Text(activeLanguage.name, style: AppTypography.subtitle(color: AppColors.textPrimary)),
                                ],
                              ),
                            ),
                            const Icon(Icons.translate_rounded, color: AppColors.cyberCyan),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Legal & Institutional Agreements Section
                      _buildSectionHeader('Legal & Compliance'),
                      GlassmorphicCard(
                        child: Column(
                          children: [
                            _buildSettingsTile(
                              icon: Icons.assignment_outlined,
                              title: 'Master Institutional SaaS Agreement',
                              subtitle: 'Terms governing institute tenant isolation & SLA',
                              onTap: () => context.push('/legal-document?type=agreement'),
                            ),
                            const Divider(color: AppColors.glassBorder, height: 16),
                            _buildSettingsTile(
                              icon: Icons.privacy_tip_outlined,
                              title: 'Privacy Policy & Data Security',
                              subtitle: 'GDPR, DPDP Act & AI processing disclosures',
                              onTap: () => context.push('/legal-document?type=privacy'),
                            ),
                            const Divider(color: AppColors.glassBorder, height: 16),
                            _buildSettingsTile(
                              icon: Icons.gavel_rounded,
                              title: 'Terms of Service & AUP',
                              subtitle: 'Acceptable use rules for staff, students & parents',
                              onTap: () => context.push('/legal-document?type=terms'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Security & Privacy Settings
                      _buildSectionHeader('Security & Authentication'),
                      GlassmorphicCard(
                        child: Column(
                          children: [
                            _buildSwitchTile(
                              icon: Icons.fingerprint_rounded,
                              title: 'Biometric App Lock',
                              subtitle: 'Require FaceID / Fingerprint to open app',
                              value: _biometricLock,
                              onChanged: (v) => setState(() => _biometricLock = v),
                            ),
                            const Divider(color: AppColors.glassBorder, height: 16),
                            _buildSwitchTile(
                              icon: Icons.security_rounded,
                              title: 'Two-Factor Authentication (2FA)',
                              subtitle: 'Extra security code sent to mobile/email',
                              value: _twoFactorAuth,
                              onChanged: (v) => setState(() => _twoFactorAuth = v),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // App Preferences & Theme
                      _buildSectionHeader('Preferences & Storage'),
                      GlassmorphicCard(
                        child: Column(
                          children: [
                            _buildSwitchTile(
                              icon: Icons.notifications_active_rounded,
                              title: 'Push Notifications',
                              subtitle: 'Instant alerts for fees, attendance & exams',
                              value: _pushNotifications,
                              onChanged: (v) => setState(() => _pushNotifications = v),
                            ),
                            const Divider(color: AppColors.glassBorder, height: 16),
                            _buildSettingsTile(
                              icon: Icons.cleaning_services_rounded,
                              title: 'Clear Offline Cache',
                              subtitle: 'Free up local device storage (Cached data: 14.2 MB)',
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Offline cache cleared successfully.')),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Luminora Technologies Strategic Innovations Section
                      _buildSectionHeader('Luminora Tech Key Innovations'),
                      GlassmorphicCard(
                        borderColor: AppColors.electricPurple.withValues(alpha: 0.4),
                        child: Column(
                          children: [
                            _buildSettingsTile(
                              icon: Icons.mic_rounded,
                              title: '🎙️ Luminora AI Voice Copilot',
                              subtitle: 'Voice-activated attendance & instant voice search',
                              onTap: () => _showFeatureIdeaDialog(
                                'Luminora AI Voice Copilot',
                                'Allows trainers to mark attendance verbally ("Mark Ananya present") and enables multi-lingual voice Q&A for students.',
                              ),
                            ),
                            const Divider(color: AppColors.glassBorder, height: 16),
                            _buildSettingsTile(
                              icon: Icons.offline_bolt_rounded,
                              title: '📶 Offline-First Auto-Sync Engine',
                              subtitle: 'Roll calls in zero-connectivity areas with auto-cloud sync',
                              onTap: () => _showFeatureIdeaDialog(
                                'Offline-First Auto-Sync Engine',
                                'Enables faculty to take attendance and record grades even without internet connection, automatically uploading records when connection is restored.',
                              ),
                            ),
                            const Divider(color: AppColors.glassBorder, height: 16),
                            _buildSettingsTile(
                              icon: Icons.palette_rounded,
                              title: '🎨 Enterprise White-Label Suite',
                              subtitle: 'Custom domain, brand colors, and splash screen per institute',
                              onTap: () => _showFeatureIdeaDialog(
                                'Enterprise White-Label Suite',
                                'Enterprise tier institutions get custom domain (e.g. portal.myinstitute.com), custom brand logo, dynamic primary color palette, and dedicated mobile app build.',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Official SMEC Technologies Contact & Support Section
                      _buildSectionHeader('SMEC Technologies Desk'),
                      GlassmorphicCard(
                        borderColor: AppColors.amberGold.withValues(alpha: 0.4),
                        child: Column(
                          children: [
                            _buildSettingsTile(
                              icon: Icons.contact_support_rounded,
                              title: 'Official Campus & Admissions Desk',
                              subtitle: 'Contact Kochi HQ, Calicut & Trivandrum Campuses',
                              onTap: () => context.push('/contact'),
                            ),
                            const Divider(color: AppColors.glassBorder, height: 16),
                            _buildSettingsTile(
                              icon: Icons.school_rounded,
                              title: 'Gen AI Master\'s & Stack Programs',
                              subtitle: 'Explore 9 Industry-Aligned Gen AI Courses',
                              onTap: _showCoursesListModal,
                            ),
                            const Divider(color: AppColors.glassBorder, height: 16),
                            _buildSettingsTile(
                              icon: Icons.chat_bubble_outline_rounded,
                              title: 'WhatsApp Admissions Hotline',
                              subtitle: '+91 97781 91215 (Direct Link)',
                              onTap: () => context.push('/contact'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Official SMEC Technologies Footer
                      Center(
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.amberGold.withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.school_rounded, color: AppColors.amberGold, size: 28),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'SMEC Technologies v1.0.4',
                              style: AppTypography.subtitle(color: AppColors.textPrimary),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Official Campus Management Platform\nwww.smectechnologies.co.in • info@smectechnologies.co.in\n© 2026 SMEC Technologies. All rights reserved.',
                              textAlign: TextAlign.center,
                              style: AppTypography.caption(color: AppColors.textMuted),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
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

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(title, style: AppTypography.subtitle(color: AppColors.cyberCyan)),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primaryNavy.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.primaryNavy, size: 20),
      ),
      title: Text(title, style: AppTypography.subtitle(color: AppColors.textPrimary)),
      subtitle: Text(subtitle, style: AppTypography.caption(color: AppColors.textMuted)),
      trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primaryNavy.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.primaryNavy, size: 20),
      ),
      title: Text(title, style: AppTypography.subtitle(color: AppColors.textPrimary)),
      subtitle: Text(subtitle, style: AppTypography.caption(color: AppColors.textMuted)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeTrackColor: AppColors.primaryNavy,
      ),
    );
  }

}
