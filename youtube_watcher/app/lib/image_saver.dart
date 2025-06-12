import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';

/// A widget that displays its child and provides a button to save the
/// child's visual representation as a PNG image file.
class ImageSaver extends StatefulWidget {
  final Widget child;

  const ImageSaver({Key? key, required this.child}) : super(key: key);

  @override
  State<ImageSaver> createState() => _ImageSaverState();
}

class _ImageSaverState extends State<ImageSaver> {
  // A GlobalKey is used to uniquely identify the widget that we want to capture.
  final GlobalKey _globalKey = GlobalKey();
  bool _isLoading = false;

  late Directory imagesFolder;
  late String imagePath;
  bool _fileExists = false;

  @override
  void initState() {
    _checkForInitialFile();
    super.initState();
  }

  void _checkForInitialFile() async {
    imagesFolder = await getApplicationDocumentsDirectory();
    imagePath = '${imagesFolder.path}/image.png';
    if (await File(imagePath).exists()) {
      print('file exists');
      setState(() {
        _fileExists = true;
      });
    } else {
      print('initial file does not exist');
    }
  }

  Future<void> _clearImage() async {
    final file = File(imagePath);
    if (await file.exists()) {
      await file.delete();
      setState(() {
        _fileExists = false;
      });
    } else {
      print('Tricksy hobbitses, they tooks the images from me!');
    }
  }

  /// Captures the widget identified by [_globalKey] as an image and saves it to the device.
  Future<void> _saveImage() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // 2. Find the RenderObject of the widget to be captured.
      // The RepaintBoundary is crucial for this to work.
      RenderRepaintBoundary boundary =
          _globalKey.currentContext!.findRenderObject()
              as RenderRepaintBoundary;

      // 3. Convert the RenderObject to a ui.Image
      ui.Image image = await boundary.toImage(
        pixelRatio: 3.0,
      ); // Higher pixelRatio for better quality

      // 4. Convert the ui.Image to byte data in PNG format
      ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      if (byteData == null) {
        throw Exception('Could not convert image to byte data.');
      }
      Uint8List pngBytes = byteData.buffer.asUint8List();

      // 5. Get the directory to save the image

      final file = File(imagePath);

      // 6. Write the image data to the file
      await file.writeAsBytes(pngBytes);
    } catch (e) {
      _showSnackBar('Error saving image: $e');
    } finally {
      setState(() {
        _fileExists = true;
        _isLoading = false;
        _showSnackBar('Image saved successfully to: $imagePath');
      });
    }
  }

  /// Shows a SnackBar with a message.
  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min, // To make the column wrap its content
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // This is the widget that will be captured. We wrap it in a
        // RepaintBoundary and associate it with our GlobalKey.
        RepaintBoundary(key: _globalKey, child: widget.child),
        const SizedBox(height: 24),
        if (_isLoading)
          const Padding(
            padding: EdgeInsets.only(bottom: 16.0),
            child: CircularProgressIndicator(),
          )
        else
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              textStyle: const TextStyle(fontSize: 16),
            ),
            icon: const Icon(Icons.save_alt_outlined),
            label: const Text('Save as Image'),
            onPressed: _saveImage,
          ),
        if (_fileExists) ...[
          SizedBox(height: 20),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              textStyle: const TextStyle(fontSize: 16, color: Colors.white),
              backgroundColor: Colors.red,
            ),
            icon: const Icon(Icons.delete_forever, color: Colors.white),
            label: const Text(
              'Clear image',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            onPressed: _clearImage,
          ),
        ],
      ],
    );
  }
}
