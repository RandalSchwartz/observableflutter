import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_watcher/src/features/chat/application/chat_controller.dart';
import 'package:youtube_watcher/src/features/chat/presentation/widgets/chat_bubble.dart';

/// The screen that displays the live chat messages.
class ChatScreen extends ConsumerWidget {
  /// Creates the chat screen.
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatState = ref.watch(chatControllerProvider);
    final chatController = ref.read(chatControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Chat'),
      ),
      body: chatState.messages.when(
        data: (messages) {
          if (messages.isEmpty) {
            return const Center(child: Text('No messages yet.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[index];
              return GestureDetector(
                onTap: () => chatController.selectMessage(message.id),
                child: ChatBubble(
                  message: message,
                  isSelected: chatState.selectedMessageId == message.id,
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 12),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // This will re-run the build method of the controller
                  ref.invalidate(chatControllerProvider);
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
