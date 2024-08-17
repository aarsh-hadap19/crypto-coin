import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class AmpiyWebSocket {
  final _channel = WebSocketChannel.connect(Uri.parse('ws://prereg.ex.api.ampiy.com/prices'));
  final _streamController = StreamController<List<dynamic>>();

  AmpiyWebSocket() {
    _connectAndSubscribe();
    _listenForData();
  }

  void _connectAndSubscribe() async {
    String subscriptionMessage = jsonEncode({
      "method": "SUBSCRIBE",
      "params": ["all@ticker"],
      "cid": 1,
    });
    _channel.sink.add(subscriptionMessage);
  }

  void _listenForData() {
    _channel.stream.listen((message) {
      final data = jsonDecode(message) as Map<String, dynamic>;
      if (data['stream'] == 'all@fpTckr') {
        _streamController.add(data['data']);
      }
    });
  }

  Stream<List<dynamic>> get coinDataStream => _streamController.stream;

  void dispose() {
    _channel.sink.close();
    _streamController.close();
  }
}