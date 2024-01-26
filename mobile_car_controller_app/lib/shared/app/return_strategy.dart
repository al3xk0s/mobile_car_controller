import 'dart:async';

typedef GetValue<T> = T Function();
typedef SetValue<T> = void Function(T value);

abstract class ReturnStrategy {
  double get targetPosition;
  void setTargetPosition(double newTarget);

  bool get isActive;
  void setActiveState(bool newState);

  void init(GetValue<double> getter, SetValue<double> setter, double targetPosition);
  void dispose();

  factory ReturnStrategy.reset() => _ResetReturnStrategy(false);
  factory ReturnStrategy.none() => _NoneReturnStrategy(false);

  factory ReturnStrategy.smooth({
    Duration period = const Duration(milliseconds: 20),
    required double delta,
  }) => _SmoothReturnStrategy(false, period, delta);
}

abstract class _Base implements ReturnStrategy {
  _Base(this._isActive);

  GetValue<double>? _getter;
  SetValue<double>? _setter;
  double? _targetPosition;

  @override
  double get targetPosition => _targetPosition!;

  @override
  void setTargetPosition(double newTarget) => _targetPosition = newTarget;

  @override
  void init(GetValue<double> getter, SetValue<double> setter, double t) {
    _getter = getter;
    _setter = setter;
    _targetPosition = t;
  }

  @override
  bool get isActive => _isActive;
  bool _isActive;

  @override
  void setActiveState(bool newState) => _isActive = newState;

  @override
  void dispose() => setActiveState(false);
}

class _ResetReturnStrategy extends _Base {
  _ResetReturnStrategy(super.isActive);
  
  @override
  void setActiveState(bool newState) {    
    super.setActiveState(newState);

    if(!_isActive) return;
    _setter!(_targetPosition!);
  }
}

class _NoneReturnStrategy extends _Base {
  _NoneReturnStrategy(super.isActive);
}

class _SmoothReturnStrategy extends _Base {
  _SmoothReturnStrategy(super.isActive, this.period, this.deltaValue);

  StreamSubscription? _sub;
  Stream? _stream;
  final Duration period;
  final double deltaValue;

  @override
  void init(GetValue<double> getter, SetValue<double> setter, double t) {    
    super.init(getter, setter, t);
    _sub?.cancel();

    _stream = Stream.periodic(period);
    _sub = _stream?.listen((_) => _onTick());
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  double _calculate() {
    final actual = _getter!();
    if(actual == _targetPosition) return actual;
    if((actual - _targetPosition!).abs() < deltaValue) return _targetPosition!;

    return actual + (actual < _targetPosition! ? deltaValue : -deltaValue);
  }

  void _onTick() {
    if(!isActive) return;

    final newValue = _calculate();
    if(_getter!() == newValue) return;

    _setter!(newValue);
  }
}
