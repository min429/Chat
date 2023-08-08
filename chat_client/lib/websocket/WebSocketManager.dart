import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

import '../dto/chatmessage/ChatMessage.dart';

class WebSocketManager {
  final WebSocketChannel channel;
  final _chatMessageStreamController = StreamController<ChatMessage>.broadcast();
  final _roomCreatedStreamController = StreamController<void>.broadcast(); // 새로운 방 생성 알림용

  WebSocketManager(this.channel) {
    // websocket stream 리스너 등록
    channel.stream.asBroadcastStream().listen((message) {
      if (message == "A new room has been created") {
        _roomCreatedStreamController.sink.add(message); // 새로운 방 생성 이벤트 트리거
        return;
      }
      final chatMessage = ChatMessage.fromJson(jsonDecode(message));
      _chatMessageStreamController.sink.add(chatMessage);
    });
  }

  Stream<void> get roomCreated => _roomCreatedStreamController.stream;
  Stream<ChatMessage> get messages => _chatMessageStreamController.stream;

  void sendMessage(ChatMessage chatMessage) {
    channel.sink.add(jsonEncode(chatMessage.toJson()));
  }

  void dispose() {
    _chatMessageStreamController.close();
    channel.sink.close();
  }
}
