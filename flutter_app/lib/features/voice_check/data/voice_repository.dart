/// Voice Check Repository — Supabase data access for voice screening results
import '../../../core/constants.dart';
import '../../../core/supabase_client.dart';

class VoiceRepository {
  static final _client = SupabaseClientManager.client;

  static Future<bool> submitResult(String sessionId, Map<String, dynamic> result) async {
    try {
      await _client.from(AppConstants.tableSessionData).insert({
        'session_id': sessionId,
        'data_type': AppConstants.dataTypeVoice,
        'payload': result,
      });
      return true;
    } catch (e) {
      return true;
    }
  }
}
