import 'package:flutter/widgets.dart' show Offset;
import 'package:mobile_car_controller_app/entities/actions/core/action.dart';
import 'package:mobile_car_controller_app/entities/actions/core/action_id.dart';
import 'package:mobile_car_controller_app/entities/actions/core/percent_corrector.dart';
import 'package:mobile_car_controller_app/entities/actions/wheel/angle.dart';
import 'package:get/get.dart';
import 'package:mobile_car_controller_app/shared/app/return_strategy.dart';

abstract class ISterringWheelController implements IAxisAction {
  Rx<double> get degreesAngle;
  Rx<double> get radius;
  Rx<Offset> get position;

  void setMaxAngle(double maxAngle);
  void setVelocity(double velocity);
  void setRadius(double newRadius);

  double get velocity;
  double get maxDegreesHalfAngle;

  void resetAngle();
  void changeAngle(double deltaDegreesAngle);
}

class SterringWheelController implements ISterringWheelController {
  SterringWheelController({
    required Angle wheelRotateAngle,
    required this.radius,
    this.velocity = 1,
    ReturnStrategy? returnStrategy,
  }) : maxDegreesHalfAngle = (wheelRotateAngle / 2).round().degreesAngle {
    _returnStrategy = returnStrategy ?? ReturnStrategy.smooth(delta: 2);
    _returnStrategy.init(() => degreesAngle.value, _setAngle, 0.0);
  }

  late final ReturnStrategy _returnStrategy;

  @override
  String get id => ActionID.wheelAxis;

  @override
  AxisType get axisType => AxisType.doubleAxis;

  @override
  ActionType get type => ActionType.axis;

  @override
  double get maxDegreesHalfAngle => _maxDegreesHalfAngle!;
  double? _maxDegreesHalfAngle;

  @override
  void setMaxAngle(double maxAngle) => _maxDegreesHalfAngle = (maxAngle / 2).round() * 1.0;

  @override
  final Rx<double> radius;

  @override
  double get velocity => _velocity;
  double _velocity;

  @override
  final Rx<double> degreesAngle = 0.0.obs;

  void _setAngle(double newDegreesAngle) => degreesAngle.value = newDegreesAngle;

  @override
  void changeAngle(double deltaDegreesAngle) {
    final newAngle = degreesAngle.value + deltaDegreesAngle;
    if(newAngle > 0 && newAngle > maxDegreesHalfAngle) return _setAngle(maxDegreesHalfAngle);
    if(newAngle < 0 && newAngle < -maxDegreesHalfAngle) return _setAngle(-maxDegreesHalfAngle);

    _setAngle(newAngle);
  }

  @override
  bool get isReturnState => _returnStrategy.isActive;

  @override
  void resetAngle() => _setAngle(0.0);

  @override
  void setReturnState(bool newWheelReturn) => _returnStrategy.setActiveState(newWheelReturn);
  
  @override
  int get value => mainPercentCorrector(_anglePercent);

  double get _anglePercent => _positiveAngle / _maxAngle;
  double get _positiveAngle => degreesAngle.value + maxDegreesHalfAngle;
  double get _maxAngle => maxDegreesHalfAngle * 2;
}
