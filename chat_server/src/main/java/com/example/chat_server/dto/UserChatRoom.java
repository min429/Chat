package com.example.chat_server.dto;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;


@Entity
@Getter
@Setter
@Table(name = "user_chatroom")
public class UserChatRoom {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "user_chatroom_id")
    private Long userChatRoomId;

    @Column(name = "user_id")
    private String userId;

    @Column(name = "room_id")
    private String roomId;
}
