import 'package:mobile_car_controller_app/shared/common/models/enum_class.dart';

class ActionType extends IntEnumClass {
  const ActionType._(super.value);

  static const axis = ActionType._(0);
  static const button = ActionType._(1);
}

class AxisType extends IntEnumClass {
  const AxisType._(super.value);

  static const singleAxis = AxisType._(0);
  static const singleReverseAxis = AxisType._(1);
  static const doubleAxis = AxisType._(2);
}

abstract class IAction {
  String get id;
  ActionType get type;
}

abstract class IButtonAction implements IAction {
  bool get isPressed;
}

extension ButtonActionExt on IButtonAction {
  bool get isReleased => !isPressed;
}

abstract class IAxisAction implements IAction {
  int get value;
  AxisType get axisType;
  bool get isReturnState;
  void setReturnState(bool newReturnState);
}
