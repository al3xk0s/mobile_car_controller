import 'package:mobile_car_controller_app/entities/actions/wheel/angle.dart';
import 'package:flutter/widgets.dart' show DragUpdateDetails;

abstract class WheelAngleCalculator {
  static byDrag(DragUpdateDetails details, double radius, double velocity) {
    bool onTop = details.localPosition.dy <= radius;
    bool onLeftSide = details.localPosition.dx <= radius;
    bool onRightSide = !onLeftSide;
    bool onBottom = !onTop;

    /// Pan movements
    bool panUp = details.delta.dy <= 0.0;
    bool panLeft = details.delta.dx <= 0.0;
    bool panRight = !panLeft;
    bool panDown = !panUp;

    /// Absoulte change on axis
    double yChange = details.delta.dy.abs();
    double xChange = details.delta.dx.abs();

    /// Directional change on wheel
    double verticalRotation = (onRightSide && panDown) || (onLeftSide && panUp)
        ? yChange
        : yChange * -1;

    double horizontalRotation = (onTop && panRight) || (onBottom && panLeft) 
        ? xChange 
        : xChange * -1;

    // Total computed change
    double rotationalChange = (verticalRotation + horizontalRotation) * velocity; 

    // bool movingClockwise = rotationalChange > 0;
    // bool movingCounterClockwise = rotationalChange < 0;

    return Angle.radiansToDegrees(rotationalChange / 100);
  }
}
