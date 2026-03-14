/// Stroke Mitra - Authentication Provider
/// Manages completely reactive Authentication state across the app.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_service.dart';
import '../repositories/auth_repository.dart';

// Provides the AuthService
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

// Provides the AuthRepository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final service = ref.watch(authServiceProvider);
  return AuthRepository(service);
});

// Provides the auth state from Supabase
final authStateProvider = StreamProvider<AuthState>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return repo.authStateChanges;
});

// Provides the current user explicitly
final currentUserProvider = Provider<User?>((ref) {
  // Watch the auth state stream to automatically trigger updates.
  final authStateParams = ref.watch(authStateProvider);
  return authStateParams.value?.session?.user ?? ref.read(authRepositoryProvider).currentUser;
});

// Provides current users profile explicitly
final userProfileProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return null;
  final repo = ref.watch(authRepositoryProvider);
  return repo.getProfile(user.id);
});

class AuthController extends StateNotifier<AsyncValue<void>> {
  final AuthRepository _repository;

  AuthController(this._repository) : super(const AsyncData(null));

  Future<void> signIn(String email, String password) async {
    state = const AsyncLoading();
    try {
      await _repository.signIn(email, password);
      state = const AsyncData(null);
    } on AuthException catch (e) {
      state = AsyncError(e.message, StackTrace.current);
    } catch (e, st) {
      state = AsyncError('An unexpected error occurred.', st);
    }
  }

  Future<void> signUp(String email, String password, String fullName) async {
    state = const AsyncLoading();
    try {
      await _repository.signUp(email, password, fullName);
      state = const AsyncData(null);
    } on AuthException catch (e) {
      state = AsyncError(e.message, StackTrace.current);
    } catch (e, st) {
      state = AsyncError('An unexpected error occurred.', st);
    }
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    try {
      await _repository.signOut();
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError('Failed to sign out', st);
    }
  }

  Future<void> resetPassword(String email) async {
    state = const AsyncLoading();
    try {
      await _repository.resetPassword(email);
      state = const AsyncData(null);
    } on AuthException catch (e) {
      state = AsyncError(e.message, StackTrace.current);
    } catch (e, st) {
      state = AsyncError('An unexpected error occurred.', st);
    }
  }
}

// Controller Provider
final authControllerProvider = StateNotifierProvider<AuthController, AsyncValue<void>>((ref) {
  return AuthController(ref.watch(authRepositoryProvider));
});
