import 'dart:math';

class Angle implements Comparable<Angle> {
  const Angle(this.degreesAngle);
  const Angle.zero() : degreesAngle = 0;

  Angle.radians(double radianAngle) : degreesAngle = radiansToDegrees(radianAngle);
  Angle.degreesRound(double degreesAngle) : this(roundDegrees(degreesAngle));

  Angle round() => Angle.degreesRound(degreesAngle);
  Angle abs() => Angle(degreesAngle.abs());

  bool get isPositive => degreesAngle >= 0;
  bool get isNegative => degreesAngle < 0;

  double get radianAngle => degreesToRadians(degreesAngle);
  final double degreesAngle;

  static double degreesToRadians(double degreesAngle) => degreesAngle * (pi / 180);
  static double radiansToDegrees(double radianAngle) => radianAngle * 180 / pi;
  static double roundDegrees(double degreesAngle) => degreesAngle.roundToDouble();
  
  @override
  int compareTo(covariant Angle other) {
    if(this == other) return 0;
    return degreesAngle.compareTo(other.degreesAngle);
  }

  bool operator >(covariant Angle other) => compareTo(other) > 0;
  bool operator <(covariant Angle other) => compareTo(other) < 0;

  bool operator >=(covariant Angle other) => compareTo(other) >= 0;
  bool operator <=(covariant Angle other) => compareTo(other) <= 0;

  Angle operator +(covariant Angle other) => Angle(degreesAngle + other.degreesAngle);
  Angle operator -(covariant Angle other) => Angle(degreesAngle - other.degreesAngle);

  Angle operator *(covariant double multiplier) => Angle(degreesAngle * multiplier);
  Angle operator /(covariant double multiplier) => Angle(degreesAngle / multiplier);

  @override
  bool operator ==(covariant Angle other) => identical(this, other) || degreesAngle == other.degreesAngle;

  @override
  int get hashCode => roundDegrees(degreesAngle).hashCode;
}
