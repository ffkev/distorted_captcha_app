import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter/scheduler.dart';

void main() {
  runApp(const CaptchaApp());
}

class CaptchaApp extends StatelessWidget {
  const CaptchaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Distorted CAPTCHA Demo',
      home: Scaffold(
        appBar: AppBar(title: const Text('Distorted Text-based CAPTCHA')),
        body: const Padding(
          padding: EdgeInsets.all(16.0),
          child: DistortedCaptchaWidget(),
        ),
      ),
    );
  }
}

// Generates a random string of specified length using uppercase letters and numbers
String generateCaptchaCode({int length = 6}) {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  Random random = Random();
  return String.fromCharCodes(Iterable.generate(
    length,
    (_) => chars.codeUnitAt(random.nextInt(chars.length)),
  ));
}

class DistortedCaptchaPainter extends CustomPainter {
  final String captchaCode;

  DistortedCaptchaPainter({required this.captchaCode});

  @override
  void paint(Canvas canvas, Size size) {
    final random = Random();
    final paint = Paint();

    // Set dark red background as per the design
    paint.color = const Color.fromARGB(255, 107, 17, 11);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    // Add random colored lines for visual noise
    for (int i = 0; i < 2; i++) {
      paint.color = Colors.primaries[random.nextInt(Colors.primaries.length)][random.nextInt(9) * 100]!;
      paint.strokeWidth = random.nextDouble() * 2 + 1;

      final start = Offset(
        random.nextDouble() * size.width,
        random.nextDouble() * size.height,
      );
      final end = Offset(
        random.nextDouble() * size.width,
        random.nextDouble() * size.height,
      );

      canvas.drawLine(start, end, paint);
    }

    // Style for CAPTCHA text - white
    const textStyle = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    // Starting X position for first character
    double currentX = 5.0;

    // Draw each character with random distortions
    for (int i = 0; i < captchaCode.length; i++) {
      final char = captchaCode[i];

      // Calculate position with randomness:
      // - dx: horizontal position with slight random variation
      // - dy: alternating up/down pattern with small random offset
      // - rotation: slight random rotation for each character
      final dx = currentX + i * 15 + random.nextDouble() * 3;
      final dy = 25.0 + (i % 2 == 0 ? -1 : 1) * (5 + random.nextDouble() * 3);
      final rotation = (random.nextDouble() - 0.5) * 0.3;

      // Apply transformations and draw the character
      canvas.save();
      canvas.translate(dx, dy);
      canvas.rotate(rotation);

      textPainter
        ..text = TextSpan(text: char, style: textStyle)
        ..layout();
      textPainter.paint(canvas, Offset.zero);

      canvas.restore();
      // Add small random spacing between characters
      currentX += random.nextDouble() * 5;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class DistortedCaptchaWidget extends StatefulWidget {
  const DistortedCaptchaWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DistortedCaptchaWidgetState createState() => _DistortedCaptchaWidgetState();
}

class _DistortedCaptchaWidgetState extends State<DistortedCaptchaWidget> {
  String _captchaCode = "";
  // final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Generate CAPTCHA code after the widget is built
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        _captchaCode = generateCaptchaCode();
      });

      // Debug print to verify the generated code
      print('THE CAPTCHA CODE IS: $_captchaCode');
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(160, 80),
      painter: DistortedCaptchaPainter(captchaCode: _captchaCode),
    );
  }
}
