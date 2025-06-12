import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: SizedBox.square(
            dimension: 400,
            child: RotatingWheel(
              size: 400,
            ),
          ),
        ),
      ),
    );
  }
}

class RotatingWheel extends StatefulWidget {
  const RotatingWheel({
    this.foregroundColor = Colors.red,
    this.backgroundColor = Colors.white,
    required this.size,
    super.key,
  });

  /// The height and width of the square space allocated to this
  /// [RotatingWheel].
  final double size;

  /// The color to show in the middle of the donut / wheel.
  final Color foregroundColor;

  /// The color to show in the middle of the donut / wheel.
  final Color backgroundColor;

  @override
  State<RotatingWheel> createState() => _RotatingWheelState();
}

class _RotatingWheelState extends State<RotatingWheel>
    with SingleTickerProviderStateMixin {
  Offset? panStart;
  double? panStartRadians;
  double? deltaRadians;
  double? reverseDeltaRadians;

  Offset get center => Offset(widget.size / 2, widget.size / 2);

  late final AnimationController _reverseRotationController;

  @override
  void initState() {
    super.initState();
    _reverseRotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
  }

  void _onPanStart(DragStartDetails details) {
    panStart = details.localPosition;

    panStartRadians = atan2(panStart!.dy - center.dy, panStart!.dx - center.dx);
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final dragRadians = atan2(
      details.localPosition.dy - center.dy,
      details.localPosition.dx - center.dx,
    );

    setState(() {
      deltaRadians = dragRadians - panStartRadians!;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    _reverseRotationController.addListener(() {
      setState(() {
        reverseDeltaRadians =
            deltaRadians! * (1 - _reverseRotationController.value);
      });
    });
    _reverseRotationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          deltaRadians = null;
          reverseDeltaRadians = null;
        });
      }
    });
    _reverseRotationController.reset();
    _reverseRotationController.animateTo(
      1,
      duration: Duration(milliseconds: 2000),
      curve: Curves.bounceOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const double wheelThickness = 50;

        double radiansToUse = reverseDeltaRadians ?? deltaRadians ?? 0;
        print('radiansToUse: $radiansToUse');

        return GestureDetector(
          onPanStart: _onPanStart,
          onPanUpdate: _onPanUpdate,
          onPanEnd: _onPanEnd,
          child: Transform.rotate(
            angle: radiansToUse,
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: WheelPainter(
                      rotation: 0,
                      thickness: wheelThickness,
                      foregroundColor: widget.foregroundColor,
                      backgroundColor: widget.backgroundColor,
                    ),
                  ),
                ),
                Positioned(
                  left: (constraints.maxWidth / 2) - (wheelThickness / 2),
                  child: Transform.rotate(
                    angle: -radiansToUse,
                    child: Icon(
                      Icons.flutter_dash_outlined,
                      color: widget.backgroundColor,
                      size: wheelThickness,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _reverseRotationController.dispose();
    super.dispose();
  }
}

class WheelPainter extends CustomPainter {
  const WheelPainter({
    required this.rotation,
    required this.thickness,
    required this.foregroundColor,
    required this.backgroundColor,
  });

  /// In radians.
  final double rotation;

  /// Distance between outer and inner rings of the wheel.
  final double thickness;

  /// The color to show in the middle of the donut / wheel.
  final Color foregroundColor;

  /// The color to show in the middle of the donut / wheel.
  final Color backgroundColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Outer circle
    canvas.drawCircle(
      center,
      size.height / 2,
      Paint()..color = foregroundColor,
    );

    // Inner circle
    canvas.drawCircle(
      center,
      (size.height / 2) - thickness,
      Paint()..color = backgroundColor,
    );
  }

  @override
  bool shouldRepaint(WheelPainter oldDelegate) =>
      rotation != oldDelegate.rotation;
}
