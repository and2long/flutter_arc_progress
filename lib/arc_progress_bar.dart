import 'dart:math' as Math;
import 'dart:ui' as UI;

import 'package:flutter/material.dart';

class ArcProgressBar extends StatelessWidget {
  final int min;
  final int max;
  final int strokeSize;
  final double progress;
  final double marginValue;

  ArcProgressBar({
    Key? key,
    this.min = 0,
    this.max = 100,
    this.progress = 0,
    this.strokeSize = 10,
    this.marginValue = 70,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 1,
        child: CustomPaint(
          painter: _ArcProgressBarPainter(
            strokeSize.toDouble(),
            progress,
            min: min,
            max: max,
            scaleValueMargin: marginValue.toDouble(),
          ),
        ),
      ),
    );
  }
}

class _ArcProgressBarPainter extends CustomPainter {
  Paint _paint = Paint();
  double _strokeSize = 8;
  double progress = 0;
  int min;
  int max;
  double startAngle = 150;
  double sweepAngle = 240;
  late double progressMarginValue; // 70
  late double scaleMargin; // 40
  late double scaleValueMargin; // 25

  double _toRadius(double degree) => degree * Math.pi / 180;

  _ArcProgressBarPainter(double strokeSize, this.progress,
      {this.min = 0, this.max = 100, this.scaleValueMargin = 25}) {
    this.scaleMargin = scaleValueMargin + 15;
    this.progressMarginValue = scaleValueMargin + 45;
  }

  @override
  void paint(Canvas canvas, Size size) {
    double radius = size.width / 2;
    _drawProgressArc(canvas, size);
    _drawScale(canvas, radius);
    _drawScale1(canvas, radius);
    _drawScaleValue(canvas, radius);
    _drawArcPointLine(canvas, radius);
  }

  void _drawProgressArc(Canvas canvas, Size size) {
    _paint
      ..isAntiAlias = true
      ..color = Colors.grey[400]!
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = _strokeSize;
    canvas.drawArc(
        Rect.fromLTWH(
            progressMarginValue,
            progressMarginValue,
            size.width - progressMarginValue * 2,
            size.height - progressMarginValue * 2),
        _toRadius(startAngle),
        _toRadius(sweepAngle),
        false,
        _paint);

    _paint
      ..color = Color(0xff22BFB4)
      ..strokeWidth = _strokeSize - 1;
    canvas.drawArc(
        Rect.fromLTWH(
            progressMarginValue,
            progressMarginValue,
            size.width - progressMarginValue * 2,
            size.height - progressMarginValue * 2),
        _toRadius(startAngle),
        progress * _toRadius(sweepAngle / (max - min)),
        false,
        _paint);
  }

  void _drawScale(Canvas canvas, double radius) {
    _paint.strokeWidth = 1;
    canvas.save();
    canvas.translate(radius, radius);
    canvas.rotate(_toRadius(startAngle));
    canvas.translate(-radius, -radius);
    for (int i = 0; i <= (max - min); i += 10) {
      double evaDegree = i * _toRadius(sweepAngle / (max - min));
      double f = i % 10 == 0 ? -5 : 0;
      double x = radius + (radius - scaleMargin - f) * Math.cos(evaDegree);
      double y = radius + (radius - scaleMargin - f) * Math.sin(evaDegree);
      double a = radius + (radius - scaleMargin - 5) * Math.cos(evaDegree);
      double b = radius + (radius - scaleMargin - 5) * Math.sin(evaDegree);
      canvas.drawLine(Offset(x, y), Offset(a, b), _paint);
    }
    canvas.restore();
  }

  void _drawScaleValue(Canvas canvas, double radius) {
    _paint.strokeWidth = 1;
    canvas.save();
    for (int i = min; i <= max; i += 10) {
      var pb = UI.ParagraphBuilder(
          UI.ParagraphStyle(fontSize: 10, textAlign: TextAlign.start))
        ..pushStyle(UI.TextStyle(color: Color(0xff22BFB4)))
        ..addText(i.toString());
      UI.Paragraph p = pb.build()..layout(UI.ParagraphConstraints(width: 30));
      double evaDegree =
          _toRadius(startAngle) + i * _toRadius(sweepAngle / (max - min));
      double x = radius + (radius - scaleValueMargin) * Math.cos(evaDegree);
      double y = radius + (radius - scaleValueMargin) * Math.sin(evaDegree);
      canvas.drawParagraph(p, Offset(x - 6, y - 10));
    }
    canvas.restore();
  }

  void _drawScale1(Canvas canvas, double radius) {
    _paint
      ..strokeWidth = 1
      ..color = Colors.grey[400]!;
    canvas.save();
    canvas.translate(radius, radius);
    canvas.rotate(_toRadius(startAngle));
    canvas.translate(-radius, -radius);
    for (int i = 2; i <= (max - min); i += 2) {
      if (i % 10 != 0) {
        double evaDegree = i * _toRadius(sweepAngle / (max - min));
        double f = i % 10 == 0 ? -5 : 0;
        double x = radius + (radius - scaleMargin - f) * Math.cos(evaDegree);
        double y = radius + (radius - scaleMargin - f) * Math.sin(evaDegree);
        double a = radius + (radius - scaleMargin - 5) * Math.cos(evaDegree);
        double b = radius + (radius - scaleMargin - 5) * Math.sin(evaDegree);
        canvas.drawLine(Offset(x, y), Offset(a, b), _paint);
      }
    }
    canvas.restore();
  }

  void _drawArcPointLine(UI.Canvas canvas, double radius) {
    canvas.save();
    canvas.translate(radius, radius);
    canvas.rotate(_toRadius(startAngle));
    canvas.translate(-radius, -radius);
    _paint
      ..color = Colors.amber[800]!
      ..style = PaintingStyle.fill
      ..strokeWidth = 5;
    double degree = _toRadius(sweepAngle / (max - min)) * progress;
    double a = radius + (radius - scaleMargin - 20) * Math.cos(degree);
    double b = radius + (radius - scaleMargin - 20) * Math.sin(degree);
    canvas.drawLine(Offset(radius, radius), Offset(a, b), _paint);
    _paint.color = Colors.amber[900]!;
    canvas.drawCircle(Offset(radius, radius), 12, _paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
