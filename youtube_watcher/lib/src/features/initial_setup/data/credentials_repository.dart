import 'package:shared_preferences/shared_preferences.dart';

class CredentialsRepository {
  CredentialsRepository(this._prefs);

  final SharedPreferences _prefs;

  static const String _apiKeyKey = 'api_key';
  static const String _videoIdKey = 'video_id';

  Future<void> setApiKey(String apiKey) async {
    await _prefs.setString(_apiKeyKey, apiKey);
  }

  String? getApiKey() {
    return _prefs.getString(_apiKeyKey);
  }

  Future<void> setVideoId(String videoId) async {
    await _prefs.setString(_videoIdKey, videoId);
  }

  String? getVideoId() {
    return _prefs.getString(_videoIdKey);
  }
}
