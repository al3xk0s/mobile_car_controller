import 'package:mobile_car_controller_app/entities/actions/wheel/angle.dart';
import 'package:mobile_car_controller_app/entities/actions/wheel/sterring_wheel_controller.dart';
import 'package:mobile_car_controller_app/entities/actions/wheel/wheel_angle_calculator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SteeringWheelWidget extends StatelessWidget {
  const SteeringWheelWidget({super.key, required this.controller});

  final ISterringWheelController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Steering Wheel Simulator'),
      ),
      body: Center(
        child: GestureDetector(
          onPanUpdate: (d) {
            controller.setReturnState(false);
            final delta = WheelAngleCalculator.byDrag(d, controller.radius, controller.velocity);
            controller.changeAngle(delta);
          },
          onPanEnd: (_) => {
            controller.setReturnState(true),
          },
          child: Obx(() =>
            Transform.rotate(
              angle: Angle.degreesToRadians(controller.degreesAngle.value),
              child: Container(
                width: controller.radius * 2,
                height: controller.radius * 2,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/wheel.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
