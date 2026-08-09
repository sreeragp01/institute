import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/glassmorphic_card.dart';
import '../../../../core/widgets/custom_button.dart';

class InstituteRegistrationScreen extends StatefulWidget {
  const InstituteRegistrationScreen({super.key});

  @override
  State<InstituteRegistrationScreen> createState() => _InstituteRegistrationScreenState();
}

class _InstituteRegistrationScreenState extends State<InstituteRegistrationScreen> {
  int _currentStep = 0;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _websiteController = TextEditingController();
  final _addressController = TextEditingController();

  final _adminFirstNameController = TextEditingController();
  final _adminLastNameController = TextEditingController();
  final _adminEmailController = TextEditingController();
  final _adminPasswordController = TextEditingController();

  String _selectedTier = 'FREE_TRIAL';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _websiteController.dispose();
    _addressController.dispose();
    _adminFirstNameController.dispose();
    _adminLastNameController.dispose();
    _adminEmailController.dispose();
    _adminPasswordController.dispose();
    super.dispose();
  }

  void _submitRegistration() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Institute Onboarded Successfully! Welcome to SMEC Connect.'),
        backgroundColor: AppColors.emeraldGreen,
      ),
    );
    context.go('/admin-dashboard');
  }

  @override
  Widget build(BuildContext context) {
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
                      icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                      onPressed: () {
                        if (_currentStep > 0) {
                          setState(() => _currentStep--);
                        } else {
                          context.go('/welcome');
                        }
                      },
                    ),
                    Text('Register Institute', style: AppTypography.header2()),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          _buildStepTab(0, '1. Details'),
                          _buildStepTab(1, '2. Plan'),
                          _buildStepTab(2, '3. Admin'),
                        ],
                      ),
                      const SizedBox(height: 24),

                      if (_currentStep == 0) _buildDetailsStep(),
                      if (_currentStep == 1) _buildPlanStep(),
                      if (_currentStep == 2) _buildAdminStep(),
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

  Widget _buildStepTab(int stepIndex, String title) {
    final isActive = _currentStep == stepIndex;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: isActive ? AppColors.cyberCyan.withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isActive ? AppColors.cyberCyan : Colors.white24),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: AppTypography.caption(color: isActive ? AppColors.cyberCyan : Colors.white60),
        ),
      ),
    );
  }

  Widget _buildDetailsStep() {
    return GlassmorphicCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Institute Profile', style: AppTypography.header2(color: AppColors.cyberCyan)),
          const SizedBox(height: 4),
          Text('Enter basic details to setup your institute workspace.', style: AppTypography.caption(color: AppColors.textMuted)),
          const SizedBox(height: 16),
          _buildTextField('Institute Name *', _nameController, Icons.business_rounded, 'e.g. SMEC Tech Academy'),
          _buildTextField('Contact Email *', _emailController, Icons.email_rounded, 'info@institution.edu'),
          _buildTextField('Contact Phone', _phoneController, Icons.phone_rounded, '+91 9876543210'),
          _buildTextField('Official Website', _websiteController, Icons.language_rounded, 'https://institution.edu'),
          _buildTextField('Campus Address', _addressController, Icons.location_on_rounded, 'City, State, Country', maxLines: 2),
          const SizedBox(height: 20),
          CustomButton(
            text: 'Next: Select Plan',
            onPressed: () {
              if (_nameController.text.isEmpty || _emailController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill in Institute Name & Email.')),
                );
                return;
              }
              setState(() => _currentStep = 1);
            },
          )

        ],
      ),
    );
  }

  Widget _buildPlanStep() {
    return Column(
      children: [
        _buildPlanCard('FREE_TRIAL', '14-Day Free Trial', '\$0 / mo', 'Up to 50 Students • 10 Staff • Basic AI'),
        const SizedBox(height: 12),
        _buildPlanCard('BASIC', 'Basic Plan', '\$99 / mo', 'Up to 200 Students • 25 Staff • Standard AI'),
        const SizedBox(height: 12),
        _buildPlanCard('PROFESSIONAL', 'Professional Plan', '\$299 / mo', 'Up to 1000 Students • 100 Staff • Unlimited AI'),
        const SizedBox(height: 12),
        _buildPlanCard('ENTERPRISE', 'Enterprise Suite', 'Custom', 'Unlimited Students • Custom Domain • Dedicated AI'),
        const SizedBox(height: 24),
        CustomButton(
          text: 'Next: Setup Admin Account',
          onPressed: () => setState(() => _currentStep = 2),
        ),
      ],
    );
  }

  Widget _buildPlanCard(String tier, String title, String price, String desc) {
    final isSelected = _selectedTier == tier;
    return GestureDetector(
      onTap: () => setState(() => _selectedTier = tier),
      child: GlassmorphicCard(
        borderColor: isSelected ? AppColors.cyberCyan : Colors.white12,
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? AppColors.cyberCyan : Colors.white38,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTypography.subtitle(color: Colors.white)),
                  const SizedBox(height: 2),
                  Text(desc, style: AppTypography.microTag(color: AppColors.textMuted)),
                ],
              ),
            ),
            Text(price, style: AppTypography.subtitle(color: AppColors.cyberCyan)),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminStep() {
    return GlassmorphicCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Institute Admin Credentials', style: AppTypography.header2(color: AppColors.cyberCyan)),
          const SizedBox(height: 4),
          Text('Create primary administrator account for this tenant workspace.', style: AppTypography.caption(color: AppColors.textMuted)),
          const SizedBox(height: 16),
          _buildTextField('Admin First Name *', _adminFirstNameController, Icons.person_rounded, 'First Name'),
          _buildTextField('Admin Last Name', _adminLastNameController, Icons.person_outline_rounded, 'Last Name'),
          _buildTextField('Admin Work Email *', _adminEmailController, Icons.email_rounded, 'admin@institution.edu'),
          _buildTextField('Account Password *', _adminPasswordController, Icons.lock_rounded, '••••••••', obscureText: true),
          const SizedBox(height: 20),
          CustomButton(
            text: 'Launch Institute Workspace',
            onPressed: _submitRegistration,
          )
        ],
      ),
    );
  }


  Widget _buildTextField(String label, TextEditingController controller, IconData icon, String hint, {bool obscureText = false, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTypography.caption(color: Colors.white70)),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            obscureText: obscureText,
            maxLines: maxLines,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.white30),
              prefixIcon: Icon(icon, color: AppColors.cyberCyan, size: 20),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.06),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
        ],
      ),
    );
  }
}
