import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:youtube_watcher/src/features/chat/application/chat_providers.dart';
import 'package:youtube_watcher/src/features/chat/data/chat_message.dart';
import 'package:youtube_watcher/src/features/chat/data/youtube_service.dart';
import 'package:youtube_watcher/src/features/chat/presentation/chat_screen.dart';

class MockYouTubeService extends Mock implements YouTubeService {}

void main() {
  testWidgets('ChatScreen displays messages on successful load',
      (WidgetTester tester) async {
    final mockYouTubeService = MockYouTubeService();
    when(() => mockYouTubeService.getChatMessages()).thenAnswer((_) async => [
          const ChatMessage(
            id: '1',
            author: 'Test Author',
            message: 'Test Message',
            profileImageUrl: 'http://test.com/image.png',
          ),
        ]);

    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            youTubeServiceProvider.overrideWithValue(mockYouTubeService),
          ],
          child: const MaterialApp(
            home: ChatScreen(),
          ),
        ),
      );

      // At first, a loading indicator should be visible
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for the future to complete and the UI to rebuild
      await tester.pumpAndSettle();

      // Now, the loading indicator should be gone
      expect(find.byType(CircularProgressIndicator), findsNothing);

      // And the list view with the message should be visible
      expect(find.byType(ListView), findsOneWidget);
      expect(find.text('Test Author'), findsOneWidget);
      expect(find.text('Test Message'), findsOneWidget);
    });
  });
}