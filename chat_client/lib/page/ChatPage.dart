import 'package:chat_client/page/MainPage.dart';
import 'package:flutter/material.dart';

import '../dto/chatmessage/ChatMessage.dart';
import '../websocket/WebSocketManager.dart';
import 'package:chat_client/config/AppConfig.dart';

class ChatPage extends StatefulWidget {
  final WebSocketManager webSocketManager;
  final String roomId;

  const ChatPage({Key? key, required WebSocketManager manager, required this.roomId})
      : webSocketManager = manager,
        super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _textFocus = FocusNode(); // 텍스트 입력 창에 포커스
  final List<String> _messages = <String>[];

  void sendMessage(MessageType messageType, String userId, String userName) {
    if (_controller.text.isNotEmpty) {
      final chatMessage = ChatMessage(
        type: messageType,
        roomId: widget.roomId,
        senderId: userId,
        sender: userName,
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
          title: Text('Chat'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(8.0),
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
                      decoration: InputDecoration(labelText: 'Send a message'),
                      onSubmitted: (text) {
                        sendMessage(MessageType.TALK, AppConfig.userId, AppConfig.userName);
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () => sendMessage(MessageType.TALK, AppConfig.userId, AppConfig.userName),
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
