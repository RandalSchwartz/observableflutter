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
      when(() => mockYouTubeService.getChatMessages())
          .thenAnswer((_) async => []);
      container = ProviderContainer(
        overrides: [
          youTubeServiceProvider.overrideWith((ref) async => mockYouTubeService),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('initial state has loading messages', () {
      final controller = container.read(chatControllerProvider.notifier);
      final initialState = controller.build();
      expect(initialState.messages, isA<AsyncLoading<List<ChatMessage>>>());
      expect(initialState.selectedMessageId, isNull);
    });

    test('selectMessage updates the selected message id', () {
      final controller = container.read(chatControllerProvider.notifier);
      controller.selectMessage('test-id');
      expect(container.read(chatControllerProvider).selectedMessageId, 'test-id');
    });

    test('selecting the same message twice deselects it', () {
      final controller = container.read(chatControllerProvider.notifier);
      controller.selectMessage('test-id');
      controller.selectMessage('test-id');
      expect(container.read(chatControllerProvider).selectedMessageId, isNull);
    });
  });
}

