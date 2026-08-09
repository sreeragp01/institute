import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({required this.text, required this.isUser, required this.timestamp});
}

class AIChatbotScreen extends StatefulWidget {
  const AIChatbotScreen({super.key});

  @override
  State<AIChatbotScreen> createState() => _AIChatbotScreenState();
}

class _AIChatbotScreenState extends State<AIChatbotScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [
    ChatMessage(
      text: "Hello Ananya! I am your 24/7 SMEC AI Learning & Career Assistant. How can I help you with your courses, notes, fee status, or timetable today?",
      isUser: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
  ];
  bool _isTyping = false;

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    final userMsg = ChatMessage(text: text, isUser: true, timestamp: DateTime.now());
    setState(() {
      _messages.add(userMsg);
      _isTyping = true;
    });
    _messageController.clear();

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;

      String aiReply = "I have analyzed your request against your Computer Science course syllabus and institute records.";
      final lower = text.toLowerCase();
      if (lower.contains('fee') || lower.contains('payment')) {
        aiReply = "Your next fee installment of ₹45,000 is due on August 18, 2026. You can view and download your payment receipts from your Fee Portal.";
      } else if (lower.contains('attendance') || lower.contains('present')) {
        aiReply = "Your overall attendance is 92.0% (46 out of 50 sessions attended). You are fully eligible for final exams!";
      } else if (lower.contains('quiz') || lower.contains('exam')) {
        aiReply = "I have generated 5 practice questions on Python Data Science & ML. Let me know when you're ready to start the self-assessment!";
      }

      setState(() {
        _messages.add(ChatMessage(text: aiReply, isUser: false, timestamp: DateTime.now()));
        _isTyping = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.darkMeshGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Top Bar with AI Glowing Avatar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                      onPressed: () => context.pop(),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.cyberCyan.withValues(alpha: 0.15),
                        border: Border.all(color: AppColors.cyberCyan),
                      ),
                      child: const Icon(Icons.psychology_rounded, color: AppColors.cyberCyan, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('SMEC AI Study Tutor', style: AppTypography.subtitle()),
                        Row(
                          children: [
                            Container(width: 6, height: 6, decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.emeraldGreen)),
                            const SizedBox(width: 6),
                            Text('Always Active • RAG Powered', style: AppTypography.microTag(color: AppColors.emeraldGreen)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(color: AppColors.glassBorder, height: 1),

              // Chat Messages List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final msg = _messages[index];
                    return _buildBubble(msg);
                  },
                ),
              ),

              if (_isTyping)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Row(
                    children: [
                      Text('AI Tutor is synthesizing response...', style: AppTypography.caption(color: AppColors.cyberCyan)),
                    ],
                  ),
                ),

              // Suggested Prompts Row
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    _promptChip('Check my Fee Status'),
                    _promptChip('My Attendance Percentage'),
                    _promptChip('Start Python Practice Quiz'),
                  ],
                ),
              ),

              // Input TextField Bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        onSubmitted: _sendMessage,
                        decoration: InputDecoration(
                          hintText: 'Ask subject questions, fees, timetables...',
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                          fillColor: AppColors.darkCardSurface,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppColors.aiGradient,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                        onPressed: () => _sendMessage(_messageController.text),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBubble(ChatMessage msg) {
    return Align(
      alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
        decoration: BoxDecoration(
          color: msg.isUser ? AppColors.primaryBlue : AppColors.darkCardSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: msg.isUser ? AppColors.primaryBlue : AppColors.glassBorderActive),
        ),
        child: Text(
          msg.text,
          style: AppTypography.bodyStandard(color: Colors.white),
        ),
      ),
    );
  }

  Widget _promptChip(String text) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ActionChip(
        backgroundColor: AppColors.darkCardSurface,
        side: const BorderSide(color: AppColors.glassBorder),
        label: Text(text, style: AppTypography.caption(color: AppColors.cyberCyan)),
        onPressed: () => _sendMessage(text),
      ),
    );
  }
}
