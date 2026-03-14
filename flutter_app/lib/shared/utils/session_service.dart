/// Stroke Mitra - Session Service
///
/// Manages screening sessions via Supabase. Replaces the
/// original Express API calls (startSession, submitData).

import '../../core/constants.dart';
import '../../core/supabase_client.dart';

class SessionService {
  SessionService._();

  static final _client = SupabaseClientManager.client;

  /// Start a new screening session — replaces POST /api/session
  static Future<String> startSession() async {
    try {
      final response = await _client
          .from(AppConstants.tableSessions)
          .insert({
            'is_completed': false,
          })
          .select('id')
          .single();

      return response['id'] as String;
    } catch (e) {
      // Fallback for offline usage — mirrors original React behavior
      return 'offline-${DateTime.now().millisecondsSinceEpoch}';
    }
  }

  /// Submit screening data — replaces POST /api/data
  static Future<bool> submitData(
    String sessionId,
    String type,
    Map<String, dynamic> payload,
  ) async {
    try {
      await _client.from(AppConstants.tableSessionData).insert({
        'session_id': sessionId,
        'data_type': type,
        'payload': payload,
      });
      return true;
    } catch (e) {
      // Offline mode: pretend it worked — matches original behavior
      return true;
    }
  }

  /// Mark session complete — replaces POST /api/complete
  static Future<bool> completeSession(String sessionId) async {
    try {
      await _client.from(AppConstants.tableSessions).update({
        'is_completed': true,
        'completed_at': DateTime.now().toIso8601String(),
      }).eq('id', sessionId);
      return true;
    } catch (e) {
      return false;
    }
  }
}
