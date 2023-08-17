package com.example.chat.dto;

import com.example.chat.service.ChatService;
import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.Builder;
import lombok.Getter;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.socket.WebSocketSession;

import java.util.HashSet;
import java.util.Set;

@Slf4j
@Getter
public class ChatRoom {
    private String roomId;
    private String roomName;
    @JsonIgnore
    private Set<WebSocketSession> sessions = new HashSet<>(); // 해당 방의 세션 리스트

    @Builder
    public ChatRoom(String roomId, String roomName) {
        this.roomId = roomId;
        this.roomName = roomName;
    }

    public void handlerActions(WebSocketSession session, ChatMessage chatMessage, ChatService chatService) {
        if (chatMessage.getType().equals(ChatMessage.MessageType.ENTER)) {
            sessions.add(session);
            chatMessage.setMessage(chatMessage.getSender() + "님이 입장했습니다.");
        }
        sendMessage(chatMessage, chatService);
    }

    private <T> void sendMessage(T message, ChatService chatService) {
        sessions.parallelStream()
                .filter(session -> session.isOpen()) // 열려 있는 세션만 필터링
                .forEach(session -> chatService.sendMessage(session, message));
    }

}