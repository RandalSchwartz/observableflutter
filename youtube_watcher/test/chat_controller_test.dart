import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:youtube_watcher/src/features/chat/application/chat_controller.dart';
import 'package:youtube_watcher/src/features/chat/application/chat_providers.dart';
import 'package:youtube_watcher/src/features/chat/data/chat_message.dart';
import 'package:youtube_watcher/src/features/chat/data/youtube_service.dart';

class MockYouTubeService extends Mock implements YouTubeService {}

void main() {
  group('ChatController', () {
    late MockYouTubeService mockYouTubeService;
    late ProviderContainer container;

    setUp(() {
      mockYouTubeService = MockYouTubeService();
      container = ProviderContainer(
        overrides: [
          youTubeServiceProvider.overrideWithValue(mockYouTubeService),
        ],
      );
    });

    test('initial state is loading', () async {
      when(() => mockYouTubeService.getChatMessages()).thenAnswer(
        (_) async => [
          const ChatMessage(
            id: '1',
            author: 'author',
            message: 'message',
            profileImageUrl: 'profileImageUrl',
          ),
        ],
      );

      final controller = container.read(chatControllerProvider.notifier);
      expect(
        await controller.build(),
        isA<List<ChatMessage>>(),
      );
    });

    test('getChatMessages updates the state', () async {
      when(() => mockYouTubeService.getChatMessages()).thenAnswer(
        (_) async => [
          const ChatMessage(
            id: '1',
            author: 'author',
            message: 'message',
            profileImageUrl: 'profileImageUrl',
          ),
        ],
      );

      final controller = container.read(chatControllerProvider.notifier);
      await controller.getChatMessages();
      final result = await container.read(chatControllerProvider.future);

      expect(result, isA<List<ChatMessage>>());
      expect(result.length, 1);
    });
  });
}
