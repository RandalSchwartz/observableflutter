import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ValuesRepository {
  factory ValuesRepository([SharedPreferences? prefs]) {
    return ValuesRepository._(prefs ?? GetIt.I<SharedPreferences>())
      .._initialize();
  }
  ValuesRepository._(this._sharedPreferences);

  String? apiKey;
  String? videoId;

  late final SharedPreferences _sharedPreferences;

  static const API_KEY_KEY = 'apiKey';
  static const VIDEO_ID_KEY = 'video_id';

  void _initialize() {
    if (_sharedPreferences.containsKey(API_KEY_KEY)) {
      apiKey = _sharedPreferences.getString(API_KEY_KEY);
    }
    if (_sharedPreferences.containsKey(VIDEO_ID_KEY)) {
      videoId = _sharedPreferences.getString(VIDEO_ID_KEY);
    }
  }

  Future<void> setApiKey(String? apiKey) async {
    apiKey = apiKey;
    if (apiKey != null) {
      await _sharedPreferences.setString(API_KEY_KEY, apiKey);
    } else {
      await _sharedPreferences.remove(API_KEY_KEY);
    }
  }

  Future<void> setVideoId(String? videoId) async {
    videoId = videoId;
    if (videoId != null) {
      await _sharedPreferences.setString(VIDEO_ID_KEY, videoId);
    } else {
      await _sharedPreferences.remove(VIDEO_ID_KEY);
    }
  }
}
