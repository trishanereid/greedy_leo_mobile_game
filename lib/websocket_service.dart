import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  final String url;
  late WebSocketChannel _channel;
  Function(int)? onTimeUpdate;

  WebSocketService({required this.url});

  void connect() {
    _channel = WebSocketChannel.connect(Uri.parse(url));
    _channel.stream.listen((message) {
      _handleMessage(message);
    }, onError: (error) {
      print("WebSocket error: $error");
    }, onDone: () {
      print("WebSocket connection closed.");
    });
  }

  void _handleMessage(String message) {
    try {
      final data = json.decode(message);

      if (data.containsKey('timeRemaining') && onTimeUpdate != null) {
        onTimeUpdate!(data['timeRemaining']);
      }
    } catch (e) {
      print("Error processing WebSocket message: $e");
    }
  }

  void disconnect() {
    _channel.sink.close();
  }
}