// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ChatMessage.dart'; // ChatMessage.dart 에서 자동 생성됨

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) => ChatMessage(
      type: $enumDecode(_$MessageTypeEnumMap, json['type']),
      roomId: json['roomId'] as String,
      senderId: json['senderId'] as String,
      sender: json['sender'] as String,
      message: json['message'] as String,
    );

Map<String, dynamic> _$ChatMessageToJson(ChatMessage instance) =>
    <String, dynamic>{
      'type': _$MessageTypeEnumMap[instance.type]!,
      'roomId': instance.roomId,
      'senderId': instance.senderId,
      'sender': instance.sender,
      'message': instance.message,
    };

const _$MessageTypeEnumMap = {
  MessageType.ENTER: 'ENTER',
  MessageType.TALK: 'TALK',
};
