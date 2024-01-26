import 'package:web_socket_channel/web_socket_channel.dart';

abstract class IWebsocketConnection {
  bool get hasConnection;
  Future<bool> find();
  WebSocketChannel get socket;
}

class WebsocketConnection implements IWebsocketConnection {
  @override
  WebSocketChannel get socket => _channel!;

  WebSocketChannel? _channel;

  @override
  Future<bool> find() async {
    try {
      _channel = null;
      _channel = WebSocketChannel.connect(Uri.parse('ws://192.168.0.66:13000'));
      return hasConnection;
    } catch(e) {
      return hasConnection;
    }
  }

  @override
  bool get hasConnection => _channel != null;

}