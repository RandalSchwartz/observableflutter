import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_watcher/src/features/initial_setup/data/credentials_repository.dart';

part 'initial_setup_providers.g.dart';

@riverpod
Future<SharedPreferences> sharedPreferences(SharedPreferencesRef ref) {
  return SharedPreferences.getInstance();
}

@riverpod
CredentialsRepository credentialsRepository(CredentialsRepositoryRef ref) {
  final prefs = ref.watch(sharedPreferencesProvider).value;
  if (prefs == null) {
    throw Exception('SharedPreferences not initialized');
  }
  return CredentialsRepository(prefs);
}
