import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:ui' as ui;

class InvertedImage extends StatefulWidget {
  final ImageProvider imageProvider;

  const InvertedImage({super.key, required this.imageProvider});

  @override
  InvertedImageState createState() => InvertedImageState();
}

class InvertedImageState extends State<InvertedImage> {
  ui.Image? _image;
  late final ImageStream _imageStream;
  late final ImageStreamListener _imageStreamListener;

  @override
  void initState() {
    super.initState();
    _imageStream = widget.imageProvider.resolve(const ImageConfiguration());
    _imageStreamListener =
        ImageStreamListener((ImageInfo info, bool synchronousCall) {
      setState(() {
        _image = info.image;
      });
    });
    _imageStream.addListener(_imageStreamListener);
  }

  @override
  void dispose() {
    _imageStream.removeListener(_imageStreamListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_image == null) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return CustomPaint(
        size: Size.infinite,
        painter: ImagePainter(_image!),
      );
    }
  }
}

class ImagePainter extends CustomPainter {
  final ui.Image image;
  final Animation<double> animation;

  ImagePainter(this.image) : animation = const AlwaysStoppedAnimation(1.0);

  @override
  void paint(Canvas canvas, Size size) {
    double value = 10 / 3;
    double cosVal = cos(value);
    double sinVal = sin(value);
    double lumR = 0.213;
    double lumG = 0.715;
    double lumB = 0.072;

    final paint = Paint()
      ..isAntiAlias = true
      ..filterQuality = FilterQuality.high
      ..blendMode = BlendMode.screen
      ..imageFilter = ui.ImageFilter.blur(sigmaX: 1, sigmaY: 1)
      ..colorFilter = ColorFilter.matrix(<double>[
        -(lumR + (cosVal * (1 - lumR))) + (sinVal * (-lumR)),
        -(lumG + (cosVal * (-lumG))) + (sinVal * (-lumG)),
        -(lumB + (cosVal * (-lumB))) + (sinVal * (1 - lumB)),
        0,
        235,
        -(lumR + (cosVal * (-lumR))) + (sinVal * 0.143),
        -(lumG + (cosVal * (1 - lumG))) + (sinVal * 0.14),
        -(lumB + (cosVal * (-lumB))) + (sinVal * (-0.283)),
        0,
        235,
        -(lumR + (cosVal * (-lumR))) + (sinVal * (-(1 - lumR))),
        -(lumG + (cosVal * (-lumG))) + (sinVal * lumG),
        -(lumB + (cosVal * (1 - lumB))) + (sinVal * lumB),
        0,
        255,
        0,
        0,
        0,
        1,
        0,
      ]);

    final srcRect =
        Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble());
    final dstRect = Rect.fromLTWH(0, 0, size.width, size.height);

    canvas.drawImageRect(image, srcRect, dstRect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
