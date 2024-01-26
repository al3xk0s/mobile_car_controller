import 'dart:convert';

import 'package:mobile_car_controller_app/entities/actions/core/action.dart';
import 'package:mobile_car_controller_app/entities/actions/data/gate.dart';

abstract class IActionDataSender {
  Future<void> call(IAction action);
}

class BatchingActionDataSender implements IActionDataSender {
  BatchingActionDataSender(this.connection, Duration batchingPeriod) {
    _periodic = Stream.periodic(batchingPeriod);
    _periodic!.listen((_) => _onPeriodCall());
  }
  final IGate connection;

  Stream? _periodic;
  List<String> _currentMessages = [];

  void _onPeriodCall() {
    if(_currentMessages.isEmpty) return;
    
    final data = _currentMessages;
    _currentMessages = [];

    connection.send(jsonEncode(data));
  }

  @override
  Future<void> call(IAction action) async {
    _currentMessages.add(_toMessage([action.type.value, action.id, _toMessagePayload(action)]));
  }

  String _toMessagePayload(IAction action) {
    if(action is IAxisAction) return _toPayload([action.axisType.value, action.value]);
    if(action is IButtonAction) return _toPayload([action.isPressed ? 1 : 0]);

    throw Exception('Unknown action ${action.runtimeType}');
  }

  String _toPayload(List<dynamic> data) => data.join(',');
  String _toMessage(List<dynamic> data) => data.join('|');
}

