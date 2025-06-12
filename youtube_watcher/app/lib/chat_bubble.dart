// A widget that displays a message in a chat bubble with a tail.
import 'package:app/youtube_comment_stream.dart';
import 'package:flutter/material.dart';

class ChatMessageWidget extends StatelessWidget {
  const ChatMessageWidget(this.message, {super.key});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _ChatBubble(
          authorName: message.username,
          message: message.message,
          authorAvatar: CircleAvatar(
            backgroundColor: Colors.deepPurple,
            child: Image.network(message.photo),
          ),
          bubbleColor: Colors.deepPurpleAccent,
        ),
      ],
    );
  }
}

/// It includes an author avatar, name, and the message content.
class _ChatBubble extends StatelessWidget {
  final String authorName;
  final String message;
  final Widget authorAvatar;
  final Color bubbleColor;

  const _ChatBubble({
    Key? key,
    required this.authorName,
    required this.message,
    required this.authorAvatar,
    this.bubbleColor = Colors.grey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      // The CustomPainter is what draws the bubble shape.
      painter: BubblePainter(color: bubbleColor),
      child: Container(
        padding: const EdgeInsets.only(
          left: 48, // Space for the tail and avatar
          top: 12,
          right: 20,
          bottom: 12,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            authorAvatar,
            const SizedBox(width: 12),
            // The content of the bubble
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Author's Name
                  Text(
                    authorName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 1.0,
                          color: Colors.black26,
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Message Text
                  Text(
                    message,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 1.0,
                          color: Colors.black26,
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A CustomPainter to draw the chat bubble shape with a tail.
class BubblePainter extends CustomPainter {
  final Color color;
  final double cornerRadius;
  final double tailSize;

  BubblePainter({
    required this.color,
    this.cornerRadius = 16.0,
    this.tailSize = 16.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Create the path for the bubble
    final path = Path()
      // Start at the top-left corner, after the radius
      ..moveTo(cornerRadius, 0)
      // Top edge
      ..lineTo(size.width - cornerRadius, 0)
      // Top-right corner
      ..arcToPoint(
        Offset(size.width, cornerRadius),
        radius: Radius.circular(cornerRadius),
      )
      // Right edge
      ..lineTo(size.width, size.height - cornerRadius)
      // Bottom-right corner
      ..arcToPoint(
        Offset(size.width - cornerRadius, size.height),
        radius: Radius.circular(cornerRadius),
      )
      // Bottom edge
      ..lineTo(cornerRadius, size.height)
      // Bottom-left corner
      ..arcToPoint(
        Offset(0, size.height - cornerRadius),
        radius: Radius.circular(cornerRadius),
      )
      // Left edge, leading up to the tail
      ..lineTo(0, cornerRadius + tailSize)
      // The tail
      ..lineTo(-tailSize, cornerRadius + (tailSize / 2))
      ..lineTo(0, cornerRadius)
      // Left-edge, finishing up to the top-left corner
      ..lineTo(0, cornerRadius)
      ..arcToPoint(
        Offset(cornerRadius, 0),
        radius: Radius.circular(cornerRadius),
      )
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // Repaint only if the color changes
    return oldDelegate is! BubblePainter || oldDelegate.color != color;
  }
}
