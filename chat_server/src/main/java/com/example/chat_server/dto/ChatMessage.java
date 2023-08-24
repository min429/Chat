package com.example.chat_server.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ChatMessage {
    private MessageType type;
    private String roomId;
    private String senderId;
    private String sender; // 닉네임
    private String message;

    public enum MessageType{
        ENTER, TALK
    }
}
