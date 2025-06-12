import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class YouTubeCommentStream {
  YouTubeCommentStream() : _controller = StreamController<ChatMessage>();

  Future<void> initialize() async {
    final liveChatId = await _getLiveChatId(videoId);

    if (liveChatId != null) {
      Timer.periodic(const Duration(seconds: 5), (timer) async {
        await _getChatMessages(liveChatId);
      });
    }
  }

  /// Retrieves the liveChatId for a given video ID.
  Future<String?> _getLiveChatId(String videoId) async {
    final url = Uri.parse(
      '$youtubeApiBaseUrl/videos?part=liveStreamingDetails&id=$videoId&key=$apiKey',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['items'] != null && data['items'].isNotEmpty) {
        return data['items'][0]['liveStreamingDetails']['activeLiveChatId'];
      }
    }
    return null;
  }

  /// Fetches and prints new chat messages for the given liveChatId.
  Future<void> _getChatMessages(String liveChatId) async {
    final url = Uri.parse(
      '$youtubeApiBaseUrl/liveChat/messages?liveChatId=$liveChatId&part=snippet,authorDetails&key=$apiKey',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['items'] != null) {
        for (final item in data['items']) {
          final messageId = item['id'];
          if (!_processedMessageIds.contains(messageId)) {
            final author = item['authorDetails']['displayName'];
            final profileImage = item['authorDetails']['profileImageUrl'];
            final message = item['snippet']['displayMessage'];
            // print('$author: $message :: $profileImage');
            final chatMessage = ChatMessage(
              username: author,
              photo: profileImage,
              message: message,
            );
            _controller.add(chatMessage);
            _processedMessageIds.add(messageId);
          }
        }
      }
    } else {
      print('Failed to fetch chat messages: ${response.body}');
    }
  }

  /// This is the YouTube Id from the Url.
  static const videoId = 'K-duxcUpUrQ';

  final StreamController<ChatMessage> _controller;

  Stream<ChatMessage> get stream => _controller.stream;
}

class ChatMessage {
  const ChatMessage({
    required this.username,
    required this.photo,
    required this.message,
  });

  final String username;
  final String photo;
  final String message;
}

// Your API key from the Google Cloud Console.
const String apiKey = 'AIzaSyC1-zivV3o4iTguYVhlXRL1_WdH9Xq5Bq0';

// The base URL for the YouTube Data API.
const String youtubeApiBaseUrl = 'https://www.googleapis.com/youtube/v3';

// A set to store the IDs of messages we've already processed.
final Set<String> _processedMessageIds = <String>{};
