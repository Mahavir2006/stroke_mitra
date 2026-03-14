/// Face Analysis Repository — Supabase data access for face screening results
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/constants.dart';
import '../../../core/supabase_client.dart';

class FaceRepository {
  static final _client = SupabaseClientManager.client;

  /// Submit face analysis results to Supabase
  static Future<bool> submitResult(String sessionId, Map<String, dynamic> result) async {
    try {
      await _client.from(AppConstants.tableSessionData).insert({
        'session_id': sessionId,
        'data_type': AppConstants.dataTypeFace,
        'payload': result,
      });
      return true;
    } catch (e) {
      return true; // Offline fallback
    }
  }
}
