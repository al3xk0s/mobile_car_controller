import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_car_controller_app/app/initial_bindings.dart';
import 'package:mobile_car_controller_app/entities/actions/axis/axis_controller.dart';
import 'package:mobile_car_controller_app/entities/actions/core/action_id.dart';
import 'package:mobile_car_controller_app/entities/actions/data/action_data_sender.dart';
import 'package:mobile_car_controller_app/entities/actions/wheel/angle.dart';
import 'package:mobile_car_controller_app/entities/actions/wheel/sterring_wheel_controller.dart';
import 'package:mobile_car_controller_app/shared/app/return_strategy.dart';

import 'entities/actions/axis/axis.dart';
import 'entities/actions/wheel/steering_wheel_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await const InitialBindings().dependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
      
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ISterringWheelController controller = SterringWheelController(
      wheelRotateAngle: const Angle(1.5 * 360 * 2),
      velocity: 1,
      radius: 150,
      returnStrategy: ReturnStrategy.smooth(delta: 5, period: Duration(milliseconds: 20))
    );

    final IAxisController asix1 = AxisController(
      height: 200,
      id: ActionID.clutchAxis,
      returnStrategy: ReturnStrategy.smooth(delta: 0.02, period: Duration(milliseconds: 20)),
      isReverse: true,
    );

    final IAxisController asix2 = AxisController(
      height: 200,
      id: ActionID.breakAxis,
      returnStrategy: ReturnStrategy.smooth(delta: 0.02, period: Duration(milliseconds: 20)),
      isReverse: true,
    );

    final IAxisController asix3 = AxisController(
      height: 200,
      id: ActionID.throttleAxis,
      returnStrategy: ReturnStrategy.smooth(delta: 0.02, period: Duration(milliseconds: 20)),
      isReverse: true,
    );

    final IActionDataSender sender = Get.find();

    controller.degreesAngle.stream.transform(createTransformer(1)).listen((_) => sender(controller));
    asix1.percent.stream.transform(createTransformer(0.01)).listen((_) => sender(asix1));
    asix2.percent.stream.transform(createTransformer(0.01)).listen((_) => sender(asix2));
    asix3.percent.stream.transform(createTransformer(0.01)).listen((_) => sender(asix3));

    return Scaffold(
      appBar: AppBar(),
      body: Row(
        children: [
          AxisWidget(controller: asix1),
          AxisWidget(controller: asix2),
          AxisWidget(controller: asix3),
          Expanded(
            child: SteeringWheelWidget(
              controller: controller,
            ),
          ),
        ],
      ),
    );
  }
}