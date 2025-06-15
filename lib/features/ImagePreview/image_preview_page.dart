import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_background_remover/image_background_remover.dart';

class ImagePreviewPage extends StatefulWidget {
  final String imagePath;
  final String title;

  const ImagePreviewPage({
    super.key,
    required this.imagePath,
    required this.title,
  });

  @override
  State<ImagePreviewPage> createState() => _ImagePreviewPageState();
}

class _ImagePreviewPageState extends State<ImagePreviewPage> {
  Uint8List? _imageBytes;
  bool _loading = false;
  String? _error;
  ui.Image? _processedImage;

  bool get isWebUrl =>
      widget.imagePath.startsWith('http://') ||
      widget.imagePath.startsWith('https://');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.8),
                  Colors.black.withOpacity(0.4),
                ],
              ),
            ),
          ),
          // Content
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 100),
                // Cool title
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.black,
                          offset: Offset(2.0, 2.0),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                // Image display
                if (_loading)
                  const Center(child: CircularProgressIndicator())
                else if (_error != null)
                  Center(
                    child: Text(
                      _error!,
                      style: const TextStyle(color: Colors.white),
                    ),
                  )
                else if (_processedImage != null)
                  FutureBuilder<Uint8List>(
                    future: _processedImage!
                        .toByteData(format: ui.ImageByteFormat.png)
                        .then((value) => value!.buffer.asUint8List()),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.connectionState ==
                          ConnectionState.done) {
                        return Column(
                          children: [
                            // Original image
                            Container(
                              margin: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: isWebUrl
                                    ? Image.network(widget.imagePath)
                                    : Image.file(File(widget.imagePath)),
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Background removed image with yellow background
                            Container(
                              margin: const EdgeInsets.all(16),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.yellow,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Image.memory(snapshot.data!),
                            ),
                          ],
                        );
                      } else {
                        return const Text(
                          'Error processing image',
                          style: TextStyle(color: Colors.white),
                        );
                      }
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    BackgroundRemover.instance.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    BackgroundRemover.instance.initializeOrt();
    _fetchImageBytesIfNeeded();
  }

  Future<void> _fetchImageBytesIfNeeded() async {
    if (isWebUrl) {
      setState(() {
        _loading = true;
        _error = null;
      });
      try {
        final response = await http.get(Uri.parse(widget.imagePath));
        if (response.statusCode == 200) {
          _imageBytes = response.bodyBytes;
          _processImage();
        } else {
          _error = 'Failed to load image from network.';
        }
      } catch (e) {
        _error = 'Error loading image: $e';
      }
      setState(() {
        _loading = false;
      });
    } else {
      final file = File(widget.imagePath);
      if (file.existsSync()) {
        _imageBytes = file.readAsBytesSync();
        _processImage();
      } else {
        _error = 'File does not exist.';
      }
    }
  }

  Future<void> _processImage() async {
    if (_imageBytes != null) {
      try {
        final removedBgImage = await BackgroundRemover.instance.removeBg(
          _imageBytes!,
        );
        setState(() {
          _processedImage = removedBgImage;
        });
      } catch (e) {
        setState(() {
          _error = 'Error processing image: $e';
        });
      }
    }
  }
}
