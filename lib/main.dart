import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jam Dinding Kreatif',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ClockScreen(),
    );
  }
}

class ClockScreen extends StatefulWidget {
  @override
  _ClockScreenState createState() => _ClockScreenState();
}

class _ClockScreenState extends State<ClockScreen> {
  late Timer _timer;
  DateTime _currentTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jam Dinding Kreatif'),
        backgroundColor: Color.fromARGB(255, 145, 126, 43),
      ),
      body: Center(
        child: CustomPaint(
          size: Size(300, 300),
          painter: ClockPainter(_currentTime),
        ),
      ),
    );
  }
}

class ClockPainter extends CustomPainter {
  final DateTime time;
  ClockPainter(this.time);

  @override
  void paint(Canvas canvas, Size size) {
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double radius = min(centerX, centerY);

    // Paint untuk lingkaran jam dengan gradasi warna dan tebal
    final Paint fillPaint = Paint()
      ..shader = RadialGradient(
        colors: [Color.fromARGB(255, 75, 70, 74), const Color.fromARGB(255, 108, 109, 110)],
        stops: [0.5, 1.0],
      ).createShader(Rect.fromCircle(center: Offset(centerX, centerY), radius: radius))
      ..style = PaintingStyle.fill;

    final Paint circleOutlinePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8; // Tebal lingkaran jam

    // Paint untuk jarum jam dan menit
    final Paint handPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    // Paint untuk jarum detik
    final Paint secondHandPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Paint untuk angka jam
    final Paint textPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final TextPainter textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    // Menggambar lingkaran jam dengan gradasi warna dan outline tebal
    canvas.drawCircle(Offset(centerX, centerY), radius, fillPaint);
    canvas.drawCircle(Offset(centerX, centerY), radius, circleOutlinePaint);

    // Menggambar angka pada jam
    for (int i = 1; i <= 12; i++) {
      final double angle = (i * 30 - 90) * (pi / 180);
      final double x = centerX + (radius * 0.8) * cos(angle);
      final double y = centerY + (radius * 0.8) * sin(angle);

      textPainter.text = TextSpan(
        text: '$i',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(x - textPainter.width / 2, y - textPainter.height / 2));
    }

    // Menggambar jarum jam, menit, dan detik
    _drawHand(canvas, centerX, centerY, radius * 0.5, (time.hour % 12) * 30 + time.minute / 2, handPaint);
    _drawHand(canvas, centerX, centerY, radius * 0.7, time.minute * 6, handPaint);
    _drawHand(canvas, centerX, centerY, radius * 0.9, time.second * 6, secondHandPaint);

    // Menggambar lingkaran pusat dengan bayangan
    final Paint centerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(centerX, centerY), 10, centerPaint);

    final Paint shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.4)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(centerX + 5, centerY + 5), 10, shadowPaint);
  }

  void _drawHand(Canvas canvas, double centerX, double centerY, double length, double angle, Paint paint) {
    final double radian = (angle - 90) * (pi / 180);
    final double x = centerX + length * cos(radian);
    final double y = centerY + length * sin(radian);
    canvas.drawLine(Offset(centerX, centerY), Offset(x, y), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
