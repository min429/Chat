import 'package:json_annotation/json_annotation.dart';

part 'ChatMessage.g.dart'; // 코드 분리 및 자동 생성

@JsonSerializable()
class ChatMessage {
  final MessageType type;
  final String roomId;
  final String senderId;
  final String sender;
  final String message;

  ChatMessage({required this.type, required this.roomId, required this.senderId, required this.sender, required this.message});

  factory ChatMessage.fromJson(Map<String, dynamic> json) => _$ChatMessageFromJson(json);
  Map<String, dynamic> toJson() => _$ChatMessageToJson(this);
}

enum MessageType {
  @JsonValue("ENTER")
  ENTER,
  @JsonValue("TALK")
  TALK
}
