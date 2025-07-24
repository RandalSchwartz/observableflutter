import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:youtube_watcher/src/features/chat/data/youtube_service.dart';
import 'package:youtube_watcher/src/features/initial_setup/data/initial_setup_providers.dart';

part 'chat_providers.g.dart';

@riverpod
http.Client httpClient(Ref ref) {
  return http.Client();
}

@riverpod
Future<YouTubeService> youTubeService(Ref ref) async {
  final credentialsRepository = await ref.watch(credentialsRepositoryProvider.future);
  final apiKey = credentialsRepository.getApiKey()!;
  final videoId = credentialsRepository.getVideoId()!;
  final client = ref.watch(httpClientProvider);
  return YouTubeService(apiKey, videoId, client);
}
