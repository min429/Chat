class ChatRoom {
  final String roomId;
  final String name;

  ChatRoom({required this.roomId, required this.name});

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      roomId: json['roomId'],
      name: json['name'],
    );
  }
}
