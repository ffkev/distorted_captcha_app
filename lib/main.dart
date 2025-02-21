import 'package:flutter/material.dart';
import 'dart:math';

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

  DistortedCaptchaPainter(this.captchaCode);

  @override
  void paint(Canvas canvas, Size size) {
    final random = Random();
    final paint = Paint();

    // Background Color
    paint.color = const Color.fromARGB(255, 107, 17, 11);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    // Draw random lines as noise
    for (int i = 0; i < 8; i++) {
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

    // Draw the CAPTCHA code with random distortions
    final textStyle = TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      // color: Colors.primaries[random.nextInt(Colors.primaries.length)][random.nextInt(9) * 100]!,
    );

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    for (int i = 0; i < captchaCode.length; i++) {
      final char = captchaCode[i];

      // Slight rotation and position randomness
      final dx = 10.0 + i * 30 + random.nextDouble() * 5;
      final dy = 10.0 + random.nextDouble() * 10;
      final rotation = (random.nextDouble() - 0.5) * 0.3;

      canvas.save();
      canvas.translate(dx, dy);
      canvas.rotate(rotation);

      textPainter.text = TextSpan(text: char, style: textStyle);
      textPainter.layout();
      textPainter.paint(canvas, Offset.zero);

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class DistortedCaptchaWidget extends StatefulWidget {
  const DistortedCaptchaWidget({Key? key}) : super(key: key);

  @override
  _DistortedCaptchaWidgetState createState() => _DistortedCaptchaWidgetState();
}

class _DistortedCaptchaWidgetState extends State<DistortedCaptchaWidget> {
  late String _captchaCode;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _captchaCode = generateCaptchaCode();
  }

  void _validateCaptcha() {
    if (_controller.text.toUpperCase() == _captchaCode.toUpperCase()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Captcha Verified!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid Captcha, try again!')),
      );
      setState(() {
        _captchaCode = generateCaptchaCode();
      });
    }
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomPaint(
          size: const Size(200, 60),
          painter: DistortedCaptchaPainter(_captchaCode),
        ),
        TextField(
          controller: _controller,
          decoration: const InputDecoration(labelText: 'Enter CAPTCHA'),
        ),
        ElevatedButton(
          onPressed: _validateCaptcha,
          child: const Text('Verify'),
        ),
      ],
    );
  }
}
