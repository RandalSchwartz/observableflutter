import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:youtube_watcher/src/features/initial_setup/presentation/initial_setup_screen.dart';

void main() {
  testWidgets('InitialSetupScreen renders correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(
      home: InitialSetupScreen(),
    ));

    // Verify that the title is rendered.
    expect(find.text('YouTube Live Chat Viewer'), findsOneWidget);

    // Verify that the TextFields are rendered.
    expect(find.widgetWithText(TextField, 'API Key'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Video ID'), findsOneWidget);

    // Verify that the Save button is rendered.
    expect(find.widgetWithText(ElevatedButton, 'Save'), findsOneWidget);
  });
}
