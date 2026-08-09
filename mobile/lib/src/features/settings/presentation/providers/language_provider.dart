import 'package:flutter_riverpod/flutter_riverpod.dart';

class LanguageState {
  final String code;
  final String name;
  final String flag;
  final bool isRtl;

  const LanguageState({
    required this.code,
    required this.name,
    required this.flag,
    this.isRtl = false,
  });
}

const List<LanguageState> supportedLanguages = [
  LanguageState(code: 'en', name: 'English (US)', flag: '🇺🇸'),
  LanguageState(code: 'es', name: 'Español (Spanish)', flag: '🇪🇸'),
  LanguageState(code: 'hi', name: 'हिन्दी (Hindi)', flag: '🇮🇳'),
  LanguageState(code: 'ml', name: 'മലയാളം (Malayalam)', flag: '🇮🇳'),
  LanguageState(code: 'fr', name: 'Français (French)', flag: '🇫🇷'),
  LanguageState(code: 'ar', name: 'العربية (Arabic)', flag: '🇦🇪', isRtl: true),
  LanguageState(code: 'de', name: 'Deutsch (German)', flag: '🇩🇪'),
  LanguageState(code: 'zh', name: '中文 (Chinese)', flag: '🇨🇳'),
];

class LanguageNotifier extends StateNotifier<LanguageState> {
  LanguageNotifier() : super(supportedLanguages[0]);

  void setLanguage(LanguageState lang) {
    state = lang;
  }
}

final languageProvider = StateNotifierProvider<LanguageNotifier, LanguageState>((ref) {
  return LanguageNotifier();
});
