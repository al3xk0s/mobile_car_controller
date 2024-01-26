import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_car_controller_app/entities/actions/axis/axis_controller.dart';

class AxisWidget extends StatelessWidget {
  const AxisWidget({super.key, required this.controller});

  final IAxisController controller;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(      
      onPanUpdate: (d) {
        controller.setReturnState(false);        
        controller.choisePercent(d.localPosition.dy / controller.height);
      },
      onPanEnd: (d) => controller.setReturnState(true),
      child: Obx(() =>
        SizedBox(
          width: 100,
          height: controller.height,
          child: CustomPaint(
            painter: AxisCustomPainter(
              percent: controller.percent.value,
              isReverse: controller.isReverse,
              color: Colors.purple,
              borderRadius: const Radius.circular(10),
              indicatorColor: Colors.yellowAccent,
              indicatorRadius: 50,
            ),
          ),
        ),
      ),
    );
  }
}

class AxisCustomPainter extends CustomPainter {
  const AxisCustomPainter({
    required this.percent,
    required this.isReverse,
    required this.color,
    required this.borderRadius,
    required this.indicatorColor,
    required this.indicatorRadius,
  });  

  final double percent;
  final Color color;
  final Color indicatorColor;
  final double indicatorRadius;
  final Radius borderRadius;
  final bool isReverse;

  @override
  void paint(Canvas canvas, Size size) {
    final indicatorPaint = Paint()
      ..color = indicatorColor
      ..style = PaintingStyle.fill;

    final rectPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;

    final rect = Rect.fromCenter(center: size.center(Offset.zero), width: size.width, height: size.height);

    final rrect = RRect.fromRectAndRadius(rect, borderRadius);

    canvas.drawRRect(rrect, rectPaint);

    final offset = size.height - indicatorRadius / 4;
    final percentFact = isReverse ? percent : (1.0 - percent);

    canvas.drawCircle(Offset(size.width / 2, clampDouble(size.height * percentFact, size.height - offset, offset)), indicatorRadius, indicatorPaint);
  }

  @override
  bool shouldRepaint(covariant AxisCustomPainter oldDelegate)
    => oldDelegate.percent != percent || oldDelegate.isReverse != isReverse;
}