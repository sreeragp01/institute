import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/token_storage.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthState {
  final AuthStatus status;
  final String? email;
  final String? role;
  final String? fullName;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.initial,
    this.email,
    this.role,
    this.fullName,
    this.errorMessage,
  });

  AuthState copyWith({
    AuthStatus? status,
    String? email,
    String? role,
    String? fullName,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      email: email ?? this.email,
      role: role ?? this.role,
      fullName: fullName ?? this.fullName,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState()) {
    checkSession();
  }

  Future<void> checkSession() async {
    state = state.copyWith(status: AuthStatus.loading);
    final token = await TokenStorage.getAccessToken();

    if (token != null && token.isNotEmpty) {
      try {
        final response = await ApiClient().dio.get('auth/me/');
        if (response.statusCode == 200) {
          final data = response.data;
          state = AuthState(
            status: AuthStatus.authenticated,
            email: data['email'],
            role: data['role'],
            fullName: '${data['first_name'] ?? ''} ${data['last_name'] ?? ''}'.strip(),
          );
          return;
        }
      } catch (_) {}
    }

    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  Future<bool> login(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    try {
      final response = await ApiClient().dio.post('auth/login/', data: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        final access = response.data['access'];
        final refresh = response.data['refresh'];
        final user = response.data['user'];

        final role = user['role'];
        final userEmail = user['email'];
        final name = '${user['first_name']} ${user['last_name']}'.strip();

        await TokenStorage.saveTokens(accessToken: access, refreshToken: refresh, role: role);

        state = AuthState(
          status: AuthStatus.authenticated,
          email: userEmail,
          role: role,
          fullName: name.isNotEmpty ? name : userEmail,
        );
        return true;
      }
    } on DioException catch (e) {
      final msg = e.response?.data?['detail'] ?? 'Invalid credentials. Please try again.';
      state = state.copyWith(status: AuthStatus.error, errorMessage: msg);
    } catch (e) {
      state = state.copyWith(status: AuthStatus.error, errorMessage: e.toString());
    }
    return false;
  }

  Future<void> logout() async {
    await TokenStorage.clearAll();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }
}

extension StringExtension on String {
  String strip() => trim();
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
