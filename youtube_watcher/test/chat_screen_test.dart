import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:youtube_watcher/src/features/chat/presentation/chat_screen.dart';

void main() {
  testWidgets('ChatScreen renders correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(
      home: ChatScreen(),
    ));

    // Verify that the title is rendered.
    expect(find.text('Live Chat'), findsOneWidget);

    // Verify that the ListView is rendered.
    expect(find.byType(ListView), findsOneWidget);
  });
}
