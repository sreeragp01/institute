import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/glassmorphic_card.dart';
import '../../../../core/widgets/custom_button.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();

  String _selectedQueryType = 'Course Admission';
  String _selectedCourse = '.Net Fullstack with Gen AI';
  bool _optInUpdates = true;

  final List<String> _queryTypes = [
    'Course Admission',
    'Placement & Career Cell',
    'Corporate Training',
    'General Enquiry'
  ];

  final List<String> _coursesList = [
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

  final List<Map<String, String>> _campuses = [
    {
      'name': 'Kochi (Head Office)',
      'city': 'Ernakulam, Kerala',
      'address': 'II Floor, Express House, Kaloor, Kochi, Ernakulam, Kerala 682017',
      'phone': '+91 97781 91215',
      'map_url': 'https://maps.google.com/maps?q=SMEC%20Technologies%20II%20Floor%2C%20Express%20House%2C%20Kaloor%2C%20Kochi%2C%20Ernakulam%2C%20Kerala%20682017',
    },
    {
      'name': 'Calicut Branch',
      'city': 'Kozhikode, Kerala',
      'address': '2nd Floor, Al Noor Complex, Arayidathupalam, Kozhikode, Kerala 673004',
      'phone': '+91 97781 91215',
      'map_url': 'https://maps.google.com/maps?q=Al%20Noor%20Complex%2C%20Arayidathupalam%2C%20Kozhikode',
    },
    {
      'name': 'Trivandrum Branch',
      'city': 'Thiruvananthapuram, Kerala',
      'address': 'KSRTC Bus Terminal Complex, Z-1, 10th Floor, above Thampanoor, Thiruvananthapuram, Kerala 695001',
      'phone': '+91 97781 91215',
      'map_url': 'https://maps.google.com/maps?q=KSRTC%20Bus%20Terminal%20Complex%2C%20Thampanoor%2C%20Thiruvananthapuram',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  void _launchUrlStr(String urlStr) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Opening: $urlStr'),
          backgroundColor: AppColors.cyberCyan,
        ),
      );
    }
  }

  void _submitEnquiry() {
    if (_nameCtrl.text.isEmpty || _phoneCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your name and phone number')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Enquiry submitted successfully! A SMEC advisor will contact you shortly.'),
        backgroundColor: AppColors.emeraldGreen,
      ),
    );
    _nameCtrl.clear();
    _emailCtrl.clear();
    _phoneCtrl.clear();
    _messageCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.darkMeshGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Bar
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.primaryNavy, size: 20),
                      onPressed: () => context.pop(),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Contact SMEC Technologies', style: AppTypography.header2()),
                          Text('Official Campus & Admissions Desk', style: AppTypography.caption(color: AppColors.amberGold)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Quick Action Bar (Call, WhatsApp, Email)
                Row(
                  children: [
                    Expanded(
                      child: _quickActionButton(
                        icon: Icons.phone_forwarded_rounded,
                        label: 'Call Us',
                        color: AppColors.emeraldGreen,
                        onTap: () => _launchUrlStr('tel:+919778191215'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _quickActionButton(
                        icon: Icons.chat_bubble_rounded,
                        label: 'WhatsApp',
                        color: AppColors.cyberCyan,
                        onTap: () => _launchUrlStr('https://wa.me/919778191215'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _quickActionButton(
                        icon: Icons.email_rounded,
                        label: 'Email',
                        color: AppColors.amberGold,
                        onTap: () => _launchUrlStr('mailto:info@smectechnologies.co.in'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Campus Tabs
                Text('SMEC Campus Locations', style: AppTypography.subtitle()),
                const SizedBox(height: 12),
                TabBar(
                  controller: _tabController,
                  indicatorColor: AppColors.amberGold,
                  labelColor: AppColors.amberGold,
                  unselectedLabelColor: AppColors.textMuted,
                  tabs: const [
                    Tab(text: 'Kochi (HQ)'),
                    Tab(text: 'Calicut'),
                    Tab(text: 'Trivandrum'),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 180,
                  child: TabBarView(
                    controller: _tabController,
                    children: _campuses.map((campus) => _buildCampusCard(campus)).toList(),
                  ),
                ),
                const SizedBox(height: 24),

                // Working Hours
                GlassmorphicCard(
                  borderColor: AppColors.cyberCyan.withValues(alpha: 0.4),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.cyberCyan.withValues(alpha: 0.15),
                        ),
                        child: const Icon(Icons.access_time_filled_rounded, color: AppColors.cyberCyan, size: 24),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Working Hours', style: AppTypography.subtitle()),
                            Text('Mon – Sat: 9:00 AM – 6:00 PM', style: AppTypography.caption(color: AppColors.textPrimary)),
                            Text('Sunday: 10:30 AM – 5:00 PM', style: AppTypography.caption(color: AppColors.textMuted)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Enquiry Form Card
                GlassmorphicCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.edit_note_rounded, color: AppColors.amberGold),
                          const SizedBox(width: 8),
                          Text('Course Enquiry Form', style: AppTypography.subtitle(color: AppColors.amberGold)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _nameCtrl,
                        style: const TextStyle(color: AppColors.textPrimary),
                        decoration: const InputDecoration(labelText: 'Full Name *', hintText: 'Enter your name'),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _emailCtrl,
                        style: const TextStyle(color: AppColors.textPrimary),
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(labelText: 'Email Address', hintText: 'Enter your email'),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _phoneCtrl,
                        style: const TextStyle(color: AppColors.textPrimary),
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(labelText: 'Mobile Number *', hintText: '+91 97781 91215'),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedQueryType,
                        dropdownColor: AppColors.darkCardSurface,
                        style: const TextStyle(color: AppColors.textPrimary),
                        decoration: const InputDecoration(labelText: 'Query Type'),
                        items: _queryTypes.map((q) => DropdownMenuItem(value: q, child: Text(q))).toList(),
                        onChanged: (val) => setState(() => _selectedQueryType = val ?? _queryTypes.first),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedCourse,
                        dropdownColor: AppColors.darkCardSurface,
                        style: const TextStyle(color: AppColors.textPrimary),
                        decoration: const InputDecoration(labelText: 'Course of Interest'),
                        items: _coursesList.map((c) => DropdownMenuItem(value: c, child: Text(c, overflow: TextOverflow.ellipsis))).toList(),
                        onChanged: (val) => setState(() => _selectedCourse = val ?? _coursesList.first),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _messageCtrl,
                        style: const TextStyle(color: AppColors.textPrimary),
                        maxLines: 3,
                        decoration: const InputDecoration(labelText: 'Your Message / Query', hintText: 'Tell us about your learning goals...'),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Checkbox(
                            value: _optInUpdates,
                            activeColor: AppColors.amberGold,
                            onChanged: (val) => setState(() => _optInUpdates = val ?? true),
                          ),
                          Expanded(
                            child: Text(
                              'Receive course brochure and batch updates on WhatsApp',
                              style: AppTypography.microTag(color: AppColors.textMuted),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      CustomButton(
                        text: 'Submit Enquiry',
                        gradient: AppColors.goldGradient,
                        icon: Icons.send_rounded,
                        onPressed: _submitEnquiry,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Social Media Connections Row
                Center(
                  child: Column(
                    children: [
                      Text('Connect with SMEC Technologies', style: AppTypography.caption(color: AppColors.textMuted)),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _socialIconButton(Icons.facebook, 'https://www.facebook.com/smectechnologies.co.in'),
                          const SizedBox(width: 14),
                          _socialIconButton(Icons.camera_alt_rounded, 'https://www.instagram.com/smec.technologies/'),
                          const SizedBox(width: 14),
                          _socialIconButton(Icons.business_center_rounded, 'https://www.linkedin.com/company/smec-technologies-co-in/'),
                          const SizedBox(width: 14),
                          _socialIconButton(Icons.play_circle_fill_rounded, 'https://www.youtube.com/@SMECTechnologies'),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCampusCard(Map<String, String> campus) {
    return GlassmorphicCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(campus['name']!, style: AppTypography.subtitle(color: AppColors.amberGold)),
              Icon(Icons.location_on_rounded, color: AppColors.amberGold, size: 20),
            ],
          ),
          Text(campus['address']!, style: AppTypography.caption(color: AppColors.textPrimary), maxLines: 2, overflow: TextOverflow.ellipsis),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(campus['phone']!, style: AppTypography.microTag(color: AppColors.cyberCyan)),
              InkWell(
                onTap: () => _launchUrlStr(campus['map_url']!),
                child: Row(
                  children: [
                    Text('Open Google Maps', style: AppTypography.caption(color: AppColors.cyberCyan)),
                    const SizedBox(width: 4),
                    const Icon(Icons.open_in_new_rounded, size: 14, color: AppColors.cyberCyan),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _quickActionButton({required IconData icon, required String label, required Color color, VoidCallback? onTap}) {
    return GlassmorphicCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(vertical: 14),
      borderColor: color.withValues(alpha: 0.4),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 6),
          Text(label, style: AppTypography.caption(color: AppColors.textPrimary)),
        ],
      ),
    );
  }

  Widget _socialIconButton(IconData icon, String urlStr) {
    return InkWell(
      onTap: () => _launchUrlStr(urlStr),
      child: CircleAvatar(
        radius: 20,
        backgroundColor: AppColors.darkCardSurface,
        child: Icon(icon, color: AppColors.amberGold, size: 20),
      ),
    );
  }
}
