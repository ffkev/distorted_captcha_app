# Distorted CAPTCHA for Flutter Web

![CAPTCHA Example](assets/captcha_example.png)

## Overview
This project demonstrates how to implement a text-based CAPTCHA with distorted text and visual noise in a Flutter web application using the `CustomPainter` widget.

## Key Features
- Randomly generated alphanumeric CAPTCHA codes
- Distorted and rotated text for security
- Visual noise (random lines) to prevent bot recognition
- Lightweight and fully implemented in Flutter

## Getting Started

### Prerequisites
- Flutter SDK installed ([Installation Guide](https://docs.flutter.dev/get-started/install))

### Setup
1. Clone the repository:
```sh
git clone https://github.com/ffkev/distorted_captcha_app.git
cd distorted_captcha_app
```

2. Get dependencies:
```sh
flutter pub get
```

3. Run the app on the web:
```sh
flutter run -d chrome
```

## Code Highlights

### Generating Random CAPTCHA Code
```dart
String generateCaptchaCode({int length = 6}) {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  Random random = Random();
  return String.fromCharCodes(Iterable.generate(
    length,
    (_) => chars.codeUnitAt(random.nextInt(chars.length)),
  ));
}
```

### Rendering Distorted CAPTCHA
```dart
class DistortedCaptchaPainter extends CustomPainter {
  final String captchaCode;

  DistortedCaptchaPainter({required this.captchaCode});

  @override
  void paint(Canvas canvas, Size size) {
    final random = Random();
    final paint = Paint();
    paint.color = const Color.fromARGB(255, 107, 17, 11);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

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
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
```

## Project Structure
```
distorted_captcha_app/
├── lib/
│   ├── main.dart
├── web/
├── pubspec.yaml
└── assets/
```

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more information.
