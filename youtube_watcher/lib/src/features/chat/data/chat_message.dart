class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.author,
    required this.message,
    required this.profileImageUrl,
  });

  final String id;
  final String author;
  final String message;
  final String profileImageUrl;
}
