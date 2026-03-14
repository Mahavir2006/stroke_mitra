/// Stroke Mitra - Supabase Client Initialization
///
/// Singleton setup for the Supabase client. Must be initialized
/// in main.dart before runApp.

import 'package:supabase_flutter/supabase_flutter.dart';
import 'constants.dart';

class SupabaseClientManager {
  SupabaseClientManager._();

  static SupabaseClient get client => Supabase.instance.client;

  /// Initialize Supabase — call once in main()
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: AppConstants.supabaseUrl,
      anonKey: AppConstants.supabaseAnonKey,
    );
  }
}
