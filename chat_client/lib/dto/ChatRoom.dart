import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ChatRoom {
  final String roomId;
  final String roomName;

  ChatRoom({required this.roomId, required this.roomName});

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      roomId: json['roomId'],
      roomName: json['roomName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roomId': roomId,
      'roomName': roomName,
    };
  }
}
