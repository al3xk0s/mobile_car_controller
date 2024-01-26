import 'dart:async';
import 'dart:io';

import 'package:mobile_car_controller_app/entities/actions/data/websocket_connection.dart';
import 'package:udp/udp.dart';

abstract class IGate {
  FutureOr<void> send(String data);
}

class WebsocketGate implements IGate {
  const WebsocketGate(this.connection);

  final IWebsocketConnection connection;

  @override
  FutureOr<void> send(String data) => Future.sync(() => connection.socket.sink.add(data));
}

class UdpGate implements IGate {
  const UdpGate(this.connection, this.address, this.port);

  final RawDatagramSocket connection;
  final InternetAddress address;
  final int port;

  @override
  FutureOr<void> send(String data) async {
    connection.send(data.codeUnits, address, port);
  }
}
