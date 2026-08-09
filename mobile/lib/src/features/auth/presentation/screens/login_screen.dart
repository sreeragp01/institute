import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/glassmorphic_card.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _instituteCodeController = TextEditingController(text: 'SMEC');
  final _emailController = TextEditingController(text: 'student@smec.edu');
  final _passwordController = TextEditingController(text: 'student123');
  bool _obscurePassword = true;

  void _submit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email and password')),
      );
      return;
    }

    final success = await ref.read(authProvider.notifier).login(email, password);
    if (success && mounted) {
      context.go('/main-shell');
    }
  }

  void _fillDemoCredentials(String instCode, String email, String pass) {
    setState(() {
      _instituteCodeController.text = instCode;
      _emailController.text = email;
      _passwordController.text = pass;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.darkMeshGradient),
        child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 74,
                      height: 74,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primaryBlue.withValues(alpha: 0.15),
                        border: Border.all(color: AppColors.cyberCyan, width: 2),
                      ),
                      child: const Icon(Icons.school_rounded, size: 38, color: AppColors.cyberCyan),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Text('SMEC Connect', style: AppTypography.header1()),
                  ),
                  Center(
                    child: Text(
                      'SMEC Institute of Technology • Digital Campus Portal',
                      style: AppTypography.bodyStandard(color: AppColors.textSecondary),
                    ),
                  ),
                  const SizedBox(height: 28),

                  if (authState.errorMessage != null)
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.coralRed.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.coralRed),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline, color: AppColors.coralRed, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              authState.errorMessage!,
                              style: AppTypography.caption(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),

                  GlassmorphicCard(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Institutional Email Address', style: AppTypography.subtitle()),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.email_outlined, color: AppColors.cyberCyan),
                            hintText: 'e.g. student@smec.edu, trainer@smec.edu',
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text('Password', style: AppTypography.subtitle()),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock_outline, color: AppColors.cyberCyan),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                color: AppColors.textMuted,
                              ),
                              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                            ),
                            hintText: 'Enter your password',
                          ),
                        ),
                        const SizedBox(height: 28),
                        CustomButton(
                          text: 'Log In to SMEC Portal',
                          isLoading: authState.status == AuthStatus.loading,
                          onPressed: _submit,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  Text('Quick Portal Access:', style: AppTypography.subtitle(color: AppColors.textMuted)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _demoChip('Student', 'student@smec.edu', 'student123'),
                      _demoChip('Trainer / Faculty', 'trainer@smec.edu', 'trainer123'),
                      _demoChip('Institute Admin', 'admin@smec.edu', 'admin123'),
                      _demoChip('Parent Portal', 'parent@smec.edu', 'parent123'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextButton.icon(
                    onPressed: () => context.push('/contact'),
                    icon: const Icon(Icons.headset_mic_rounded, color: AppColors.amberGold, size: 18),
                    label: Text(
                      'Need Admissions Help? Contact SMEC Desk',
                      style: AppTypography.caption(color: AppColors.amberGold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
  }

  Widget _demoChip(String roleLabel, String email, String pass) {
    return ActionChip(
      backgroundColor: AppColors.darkCardSurface,
      side: const BorderSide(color: AppColors.glassBorder),
      label: Text(roleLabel, style: AppTypography.caption(color: AppColors.cyberCyan)),
      onPressed: () => _fillDemoCredentials('SMEC', email, pass),
    );
  }
}
