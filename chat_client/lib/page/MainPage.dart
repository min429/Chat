import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:logger/logger.dart';

import '../config/AppConfig.dart';
import '../dto/chatmessage/ChatMessage.dart';
import 'ChatPage.dart';
import '../dto/ChatRoom.dart';
import '../websocket/WebSocketManager.dart';

final log = Logger();

void sendEnterMessage(ChatRoom chatRoom, WebSocketManager manager, String userName) {
  final chatMessage = ChatMessage(
    type: MessageType.ENTER,
    roomId: chatRoom.roomId,
    sender: userName,
    message: '',
  );
  manager.sendMessage(chatMessage);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  WebSocketManager? webSocketManager;
  ChatPage? chatPage;
  List<ChatRoom> chatRooms = [];
  List<ChatPage> chatPages = [];
  int count = 1;

  @override
  void initState() {
    super.initState();
    // 웹소켓 연결
    try {
      final channel = WebSocketChannel.connect(
        Uri.parse(AppConfig.webSocketUrl),
      );
      webSocketManager = WebSocketManager(channel!);

      // 웹소켓 채팅방 리스트 리스너 등록
      webSocketManager?.roomCreated.listen((_) {
        _getChatRooms();
      });
      log.i("WebSocket 연결 성공");
    } catch (e) {
      log.e('WebSocket 연결 실패: $e');
      Navigator.of(context).pop();
    }

    _getChatRooms();
  }

  Future<void> _getChatRooms() async {
    final response = await http.get(
      Uri.parse(AppConfig.httpUrl+"chat"),
    );

    // 응답 확인
    if (response.statusCode == 200) {
      List<dynamic> roomsJson = jsonDecode(response.body);
      chatRooms = roomsJson.map((room) => ChatRoom.fromJson(room)).toList();
      chatPages = chatRooms.map((chatRoom) => ChatPage(manager: webSocketManager!, roomId: chatRoom.roomId)).toList();
      setState(() {}); // 채팅방 목록 업데이트를 위해 화면 갱신
    } else {
      log.e('Failed to load rooms. ErrorCode: ${response.statusCode}');
    }
  }

  Future<void> _createChatRoom(String roomName) async {
    // HTTP 요청 보내기
    final response = await http.post(
      Uri.parse('http://localhost:8080/chat'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: roomName,
    );

    if(response.statusCode != 200){
      log.e('Failed to create room. ErrorCode: ${response.statusCode}');
    }
  }

  ChatPage _enterChatPage(index) {
    sendEnterMessage(chatRooms[index], webSocketManager!, AppConfig.userName);
    return chatPages[index];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Page'),
      ),
      body: ListView.builder(
        itemCount: chatRooms.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(chatRooms[index].roomName),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => _enterChatPage(index),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createChatRoom('테스트 채팅방 ${count++}'),
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    webSocketManager?.dispose();
    super.dispose();
  }
}
