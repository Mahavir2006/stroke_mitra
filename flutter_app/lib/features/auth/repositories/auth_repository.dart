/// Stroke Mitra - Authentication Repository
/// Abstracted abstraction for Authentication Service, making it mockable
/// and combining profile queries with auth methods.

import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/supabase_client.dart';
import 'auth_service.dart';

class AuthRepository {
  final AuthService _authService;
  final SupabaseClient _client = SupabaseClientManager.client;

  AuthRepository(this._authService);

  Future<AuthResponse> signUp(String email, String password, String fullName) {
    return _authService.signUp(email: email, password: password, fullName: fullName);
  }

  Future<AuthResponse> signIn(String email, String password) async {
    final response = await _authService.signIn(email: email, password: password);
    // Update last_login when signing in successfully
    if (response.user != null) {
      await _client.from('profiles').update({
        'last_login': DateTime.now().toUtc().toIso8601String()
      }).eq('id', response.user!.id);
    }
    return response;
  }

  Future<void> signOut() {
    return _authService.signOut();
  }

  Future<void> resetPassword(String email) {
    return _authService.resetPassword(email);
  }

  Stream<AuthState> get authStateChanges => _authService.authStateChanges;

  User? get currentUser => _authService.currentUser;

  Future<Map<String, dynamic>?> getProfile(String userId) async {
    final response = await _client
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();
    return response;
  }
}
