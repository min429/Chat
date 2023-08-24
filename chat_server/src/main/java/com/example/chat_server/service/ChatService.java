package com.example.chat_server.service;

import com.example.chat_server.dto.ChatMessage;
import com.example.chat_server.dto.ChatRoom;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.context.event.EventListener;

import java.io.IOException;
import java.util.*;

@Slf4j
@RequiredArgsConstructor
@Service
public class ChatService {
    private final ObjectMapper objectMapper;
    private final UserChatRoomService userChatRoomService;
    private final ChatRoomService chatRoomService;
    private List<WebSocketSession> sessions = new ArrayList<>(); // 전체 세션 리스트

    public void addSession(WebSocketSession session) {
        sessions.add(session);
    }

    public void removeSession(WebSocketSession session) {
        sessions.remove(session);
    }

    public void broadcastMessage(String message) {
        sessions.parallelStream()
                .forEach(session -> sendMessage(session, message));
    }

    /** 웹소켓 메세지 처리 **/
    public void handlerActions(WebSocketSession session, ChatMessage chatMessage) {
        ChatRoom chatRoom = chatRoomService.findRoomById(chatMessage.getRoomId());
        if (chatMessage.getType().equals(ChatMessage.MessageType.ENTER)) {
                chatRoom.addSession(session);
                List<String> roomList = userChatRoomService.findChatRoomsByUserId(chatMessage.getSenderId());
                if(!roomList.contains(chatMessage.getRoomId())){
                    chatMessage.setMessage(chatMessage.getSender() + "님이 입장했습니다.");
                    sendMessage(chatMessage, chatRoom);
                    userChatRoomService.saveUserChatRoom(chatMessage);
                }
        }
        else{
            sendMessage(chatMessage, chatRoom);
        }
    }

    private <T> void sendMessage(T message, ChatRoom chatRoom) {
        chatRoom.getSessions().parallelStream()
                .filter(session -> session.isOpen()) // 열려 있는 세션만 필터링
                .forEach(session -> sendMessage(session, message));
    }

    public <T> void sendMessage(WebSocketSession session, T message) {
        try{
            session.sendMessage(new TextMessage(objectMapper.writeValueAsString(message)));
        } catch (IOException e) {
            log.error(e.getMessage(), e);
        }
    }

    public void sendMessage(WebSocketSession session, String message) {
        try {
            session.sendMessage(new TextMessage(message));
        } catch (IOException e) {
            log.error(e.getMessage(), e);
        }
    }

    // 이벤트 구독
    @EventListener
    public void handleChatRoomCreatedEvent(ChatRoomService.ChatRoomCreatedEvent event) {
        broadcastMessage("new room");
    }
}