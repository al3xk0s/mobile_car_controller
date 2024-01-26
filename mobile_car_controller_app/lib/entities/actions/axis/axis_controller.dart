import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:mobile_car_controller_app/entities/actions/core/action.dart';
import 'package:mobile_car_controller_app/entities/actions/core/percent_corrector.dart';
import 'package:mobile_car_controller_app/shared/app/return_strategy.dart';

abstract class IAxisController implements IAxisAction {
  Rx<double> get percent;
  double get height;

  void setPercent(double newPercent);
  void choisePercent(double deltaPercent);

  bool get isReverse;
}

class AxisController implements IAxisController {
  AxisController({
    required this.height,
    required this.id,
    this.zeroPosition = 0.0,
    ReturnStrategy? returnStrategy,
    this.isReverse = false,
  }) {
    _returnStrategy = returnStrategy ?? ReturnStrategy.none();
    _returnStrategy.init(() => percent.value, setPercent, zeroPosition);
  }

  @override
  final String id;

  @override
  AxisType get axisType => AxisType.singleAxis;

  @override
  ActionType get type => ActionType.axis;

  late final ReturnStrategy _returnStrategy;
  final double zeroPosition;

  @override
  final bool isReverse;

  @override
  final double height;
  
  static const double _max = 1.0;
  static const double _min = 0.0;

  @override
  bool get isReturnState => _returnStrategy.isActive;

  @override
  late final Rx<double> percent = zeroPosition.obs;

  @override
  void setPercent(double newPercent) {
    if(percent.value == newPercent) return;
    percent.value = clampDouble(newPercent, _min, _max);
  }

  @override
  void choisePercent(double deltaPercent) => setPercent(!isReverse ? 1 - deltaPercent : deltaPercent);

  @override
  void setReturnState(bool isReturn) => _returnStrategy.setActiveState(isReturn);
  
  @override
  int get value => mainPercentCorrector(percent.value);
}
