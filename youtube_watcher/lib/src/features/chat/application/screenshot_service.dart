import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'screenshot_service.g.dart';

/// A service that captures a widget as an image and saves it to the device.
class ScreenshotService {
  /// Captures the widget with the given [key] and saves it as a PNG image.
  Future<void> captureAndSave(GlobalKey key) async {
    final boundary =
        key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final image = await boundary.toImage();
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final pngBytes = byteData!.buffer.asUint8List();

    final imageToSave = img.decodeImage(pngBytes)!;

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/image.png');
    await file.writeAsBytes(img.encodePng(imageToSave));
  }
}

@riverpod
ScreenshotService screenshotService(ScreenshotServiceRef ref) {
  return ScreenshotService();
}