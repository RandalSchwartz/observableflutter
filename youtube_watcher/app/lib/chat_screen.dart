import 'dart:async';

import 'package:app/chat_bubble.dart';
import 'package:app/youtube_comment_stream.dart';
import 'package:flutter/material.dart';
import 'image_saver.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  int? selectedMessageIndex;

  final _chatMessages = <ChatMessage>[];
  final youTubeCommentStream = YouTubeCommentStream();

  late StreamSubscription<ChatMessage> _sub;

  @override
  void initState() {
    super.initState();

    unawaited(youTubeCommentStream.initialize());
    _sub = youTubeCommentStream.stream.listen(
      (ChatMessage msg) {
        setState(() {
          _chatMessages.add(msg);
        });
      },
    );
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            children: [
              SizedBox(
                height: constraints.maxHeight,
                width: constraints.maxWidth / 2,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: ImageSaver(
                      child: (selectedMessageIndex != null)
                          ? ChatMessageWidget(
                              _chatMessages[selectedMessageIndex!],
                            )
                          : Container(),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: constraints.maxHeight,
                width: constraints.maxWidth / 2,
                child: ListView.builder(
                  itemCount: _chatMessages.length,
                  itemBuilder: (context, index) => Padding(
                    padding: EdgeInsets.all(16),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          if (selectedMessageIndex != null) {
                            bool shouldUpdate = false;
                            if (index != selectedMessageIndex) {
                              shouldUpdate = true;
                            }
                            selectedMessageIndex = null;
                            if (shouldUpdate) {
                              selectedMessageIndex = index;
                            }
                          } else {
                            selectedMessageIndex = index;
                          }
                        });
                      },
                      child: ChatMessageWidget(_chatMessages[index]),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
