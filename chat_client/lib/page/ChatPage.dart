import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../dto/chatmessage/ChatMessage.dart';
import '../websocket/WebSocketManager.dart';

class ChatPage extends StatefulWidget {
  final WebSocketManager webSocketManager;
  final String roomId;

  ChatPage({Key? key, required WebSocketManager manager, required this.roomId})
      : webSocketManager = manager,
        super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _textFocus = FocusNode(); // 텍스트 입력 창에 포커스
  final List<String> _messages = <String>[];

  void sendMessage(MessageType messageType, String name) {
    if (_controller.text.isNotEmpty) {
      final chatMessage = ChatMessage(
        type: messageType,
        roomId: widget.roomId,
        sender: name,
        message: _controller.text,
      );

      widget.webSocketManager.sendMessage(chatMessage);
      _controller.clear();
      _textFocus.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(); // 이전 화면으로 이동
        return true; // default 뒤로가기 가능
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Chat'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: widget.webSocketManager?.messages,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      ChatMessage chatMessage = snapshot.data as ChatMessage;
                      _messages.add(chatMessage.message);
                    }
                    return ListView.builder(
                      itemCount: _messages.length,
                      itemBuilder: (context, index) => Text(_messages[index]),
                    );
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      focusNode: _textFocus,
                      decoration: const InputDecoration(labelText: 'Send a message'),
                      onSubmitted: (text) {
                        sendMessage(MessageType.TALK, "seungmin");
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () => sendMessage(MessageType.TALK, "seungmin"),
                  )
                ],
              )
            ],
          ),
        ),
      )
    );
  }

  @override
  void dispose() {
    // sendOutMessage()
    _textFocus.dispose();
    super.dispose();
  }
}
