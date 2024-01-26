import 'dart:io';

import 'package:get/get.dart';
import 'package:mobile_car_controller_app/entities/actions/data/action_data_sender.dart';
import 'package:mobile_car_controller_app/entities/actions/data/gate.dart';
import 'package:mobile_car_controller_app/entities/actions/data/websocket_connection.dart';
import 'package:udp/udp.dart';

class InitialBindings implements Bindings {
  const InitialBindings();

  @override
  Future<void> dependencies() async {
    Get.lazyPut(_createActionDataSender);
    // await Get.put(_createConnection(), permanent: true)
    //   .find();
    
    // Get.lazyPut(_createWebsocketGate);
    await Get.putAsync(_createUdpGate);
  }

  IActionDataSender _createActionDataSender()
    => BatchingActionDataSender(Get.find(), const Duration(milliseconds: 10));

  IGate _createWebsocketGate()
    => WebsocketGate(Get.find());

  Future<IGate> _createUdpGate() async {
    final c = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 13001);
    return UdpGate(c, InternetAddress('192.168.0.66'), 13000);
  }

  IWebsocketConnection _createConnection()
    => WebsocketConnection();
}
