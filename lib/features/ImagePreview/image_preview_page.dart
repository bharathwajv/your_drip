import 'dart:io';
import 'dart:math';
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

class ShapePainter extends CustomPainter {
  final ShapeType shapeType;
  final Color color;

  ShapePainter({required this.shapeType, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    switch (shapeType) {
      case ShapeType.heart:
        _drawHeart(path, center, radius);
        break;
      case ShapeType.diamond:
        _drawDiamond(path, center, radius);
        break;
      case ShapeType.circle:
        _drawCircle(path, center, radius);
        break;
      case ShapeType.flower:
        _drawFlower(path, center, radius);
        break;
      case ShapeType.star:
        _drawStar(path, center, radius);
        break;
      case ShapeType.hexagon:
        _drawHexagon(path, center, radius);
        break;
      case ShapeType.octagon:
        _drawOctagon(path, center, radius);
        break;
      case ShapeType.pentagon:
        _drawPentagon(path, center, radius);
        break;
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

  void _drawCircle(Path path, Offset center, double radius) {
    path.addOval(Rect.fromCircle(center: center, radius: radius));
  }

  void _drawDiamond(Path path, Offset center, double radius) {
    path.moveTo(center.dx, center.dy - radius);
    path.lineTo(center.dx + radius, center.dy);
    path.lineTo(center.dx, center.dy + radius);
    path.lineTo(center.dx - radius, center.dy);
    path.close();
  }

  void _drawFlower(Path path, Offset center, double radius) {
    for (var i = 0; i < 8; i++) {
      final angle = i * (2 * pi / 8);
      final petalCenter = Offset(
        center.dx + cos(angle) * radius * 0.5,
        center.dy + sin(angle) * radius * 0.5,
      );
      path.addOval(Rect.fromCircle(center: petalCenter, radius: radius * 0.3));
    }
    path.addOval(Rect.fromCircle(center: center, radius: radius * 0.3));
  }

  void _drawHeart(Path path, Offset center, double radius) {
    path.moveTo(center.dx, center.dy + radius * 0.3);
    path.cubicTo(
      center.dx - radius * 0.5,
      center.dy - radius * 0.5,
      center.dx - radius,
      center.dy + radius * 0.1,
      center.dx,
      center.dy + radius,
    );
    path.cubicTo(
      center.dx + radius,
      center.dy + radius * 0.1,
      center.dx + radius * 0.5,
      center.dy - radius * 0.5,
      center.dx,
      center.dy + radius * 0.3,
    );
  }

  void _drawHexagon(Path path, Offset center, double radius) {
    for (var i = 0; i < 6; i++) {
      final angle = i * (2 * pi / 6);
      final point = Offset(
        center.dx + cos(angle) * radius,
        center.dy + sin(angle) * radius,
      );
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();
  }

  void _drawOctagon(Path path, Offset center, double radius) {
    for (var i = 0; i < 8; i++) {
      final angle = i * (2 * pi / 8);
      final point = Offset(
        center.dx + cos(angle) * radius,
        center.dy + sin(angle) * radius,
      );
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();
  }

  void _drawPentagon(Path path, Offset center, double radius) {
    for (var i = 0; i < 5; i++) {
      final angle = i * (2 * pi / 5) - pi / 2;
      final point = Offset(
        center.dx + cos(angle) * radius,
        center.dy + sin(angle) * radius,
      );
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();
  }

  void _drawStar(Path path, Offset center, double radius) {
    for (var i = 0; i < 5; i++) {
      final angle = i * (2 * pi / 5) - pi / 2;
      final outerPoint = Offset(
        center.dx + cos(angle) * radius,
        center.dy + sin(angle) * radius,
      );
      final innerPoint = Offset(
        center.dx + cos(angle + pi / 5) * radius * 0.4,
        center.dy + sin(angle + pi / 5) * radius * 0.4,
      );
      if (i == 0) {
        path.moveTo(outerPoint.dx, outerPoint.dy);
      } else {
        path.lineTo(outerPoint.dx, outerPoint.dy);
      }
      path.lineTo(innerPoint.dx, innerPoint.dy);
    }
    path.close();
  }
}

enum ShapeType {
  heart,
  diamond,
  circle,
  flower,
  star,
  hexagon,
  octagon,
  pentagon,
}

class _ImagePreviewPageState extends State<ImagePreviewPage> {
  Uint8List? _imageBytes;
  bool _loading = false;
  String? _error;
  ui.Image? _processedImage;
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Selected shapes for the carousel
  final List<ShapeType> _shapes = [
    ShapeType.heart,
    ShapeType.diamond,
    ShapeType.circle,
    ShapeType.flower,
    ShapeType.star,
    ShapeType.hexagon,
    ShapeType.octagon,
    ShapeType.pentagon,
  ];

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
                            const SizedBox(height: 40),
                            // Shape carousel
                            SizedBox(
                              height: 200,
                              child: PageView.builder(
                                controller: _pageController,
                                onPageChanged: (index) {
                                  setState(() {
                                    _currentPage = index;
                                  });
                                },
                                itemCount: _shapes.length,
                                itemBuilder: (context, index) {
                                  return AnimatedBuilder(
                                    animation: _pageController,
                                    builder: (context, child) {
                                      double value = 1.0;
                                      if (_pageController
                                          .position
                                          .haveDimensions) {
                                        value = _pageController.page! - index;
                                        value = (1 - (value.abs() * 0.5)).clamp(
                                          0.0,
                                          1.0,
                                        );
                                      }
                                      return Transform.scale(
                                        scale: 0.8 + (value * 0.2),
                                        child: Transform.translate(
                                          offset: Offset(0, -20 * value),
                                          child: child,
                                        ),
                                      );
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          // Shape background
                                          CustomPaint(
                                            size: const Size(150, 150),
                                            painter: ShapePainter(
                                              shapeType: _shapes[index],
                                              color: Colors.white.withOpacity(
                                                0.2,
                                              ),
                                            ),
                                          ),
                                          // Processed image
                                          Container(
                                            width: 120,
                                            height: 120,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.3),
                                                  blurRadius: 10,
                                                  spreadRadius: 2,
                                                ),
                                              ],
                                            ),
                                            child: ClipOval(
                                              child: Image.memory(
                                                snapshot.data!,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            // Page indicator
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                _shapes.length,
                                (index) => Container(
                                  width: 8,
                                  height: 8,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _currentPage == index
                                        ? Colors.white
                                        : Colors.white.withOpacity(0.3),
                                  ),
                                ),
                              ),
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
    _pageController.dispose();
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
