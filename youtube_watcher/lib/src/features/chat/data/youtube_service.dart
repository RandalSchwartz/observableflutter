import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:youtube_watcher/src/features/chat/data/chat_message.dart';

class YouTubeService {
  YouTubeService(this._apiKey, this._videoId, this._client);

  final String _apiKey;
  final String _videoId;
  final http.Client _client;

  static const String _youtubeApiBaseUrl =
      'https://www.googleapis.com/youtube/v3';

  Future<String?> _getLiveChatId() async {
    final url = Uri.parse(
      '$_youtubeApiBaseUrl/videos?part=liveStreamingDetails&id=$_videoId&key=$_apiKey',
    );
    final response = await _client.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['items'] != null && data['items'].isNotEmpty) {
        return data['items'][0]['liveStreamingDetails']['activeLiveChatId'];
      }
    }
    return null;
  }

  Future<List<ChatMessage>> getChatMessages() async {
    final liveChatId = await _getLiveChatId();
    if (liveChatId == null) {
      return [];
    }

    final url = Uri.parse(
      '$_youtubeApiBaseUrl/liveChat/messages?liveChatId=$liveChatId&part=snippet,authorDetails&key=$_apiKey',
    );
    final response = await _client.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['items'] != null) {
        final messages = <ChatMessage>[];
        for (final item in data['items']) {
          messages.add(
            ChatMessage(
              id: item['id'],
              author: item['authorDetails']['displayName'],
              message: item['snippet']['displayMessage'],
              profileImageUrl: item['authorDetails']['profileImageUrl'],
            ),
          );
        }
        return messages;
      }
    }
    return [];
  }
}