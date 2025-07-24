import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:youtube_watcher/src/features/chat/application/chat_providers.dart';
import 'package:youtube_watcher/src/features/chat/data/chat_message.dart';

part 'chat_controller.g.dart';

@riverpod
class ChatController extends _$ChatController {
  @override
  Future<List<ChatMessage>> build() async {
    final youTubeService = ref.watch(youTubeServiceProvider);
    return youTubeService.getChatMessages();
  }

  Future<void> getChatMessages() async {
    final youTubeService = ref.watch(youTubeServiceProvider);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => youTubeService.getChatMessages());
  }
}
