/// Stroke Mitra - Authentication Service
/// Handles Supabase backend communication.

import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/supabase_client.dart';

class AuthService {
  final SupabaseClient _client = SupabaseClientManager.client;

  /// Sign up with email, password, and full name
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    return await _client.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': fullName},
    );
  }

  /// Sign in with email and password
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  /// Sign out
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  /// Reset password via email
  Future<void> resetPassword(String email) async {
    await _client.auth.resetPasswordForEmail(email);
  }

  /// Stream of Auth State changes
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  /// Get current user
  User? get currentUser => _client.auth.currentUser;
}
