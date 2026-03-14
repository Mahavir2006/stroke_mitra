/// Motion Test Repository — Supabase data access for motion screening results
import '../../../core/constants.dart';
import '../../../core/supabase_client.dart';

class MotionRepository {
  static final _client = SupabaseClientManager.client;

  static Future<bool> submitResult(String sessionId, Map<String, dynamic> result) async {
    try {
      await _client.from(AppConstants.tableSessionData).insert({
        'session_id': sessionId,
        'data_type': AppConstants.dataTypeMotion,
        'payload': result,
      });
      return true;
    } catch (e) {
      return true;
    }
  }
}
