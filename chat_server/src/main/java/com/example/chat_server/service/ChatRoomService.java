package com.example.chat_server.service;

import com.example.chat_server.dto.ChatRoom;
import com.example.chat_server.repository.ChatRoomRepository;
import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.ApplicationEvent;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.stereotype.Service;

import java.util.*;

@Slf4j
@RequiredArgsConstructor
@Service
public class ChatRoomService {
    private final ApplicationEventPublisher applicationEventPublisher;
    private final ChatRoomRepository chatRoomRepository;
    private Map<String, ChatRoom> chatRooms;

    @PostConstruct
    private void init() {
        chatRooms = new LinkedHashMap<>();
        List<ChatRoom> rooms = chatRoomRepository.findAll();
        for (ChatRoom room : rooms) {
            chatRooms.put(room.getRoomId(), room);
        }
    }

    public List<ChatRoom> findAllRoom() {
        return new ArrayList<>(chatRooms.values());
    }

    public ChatRoom findRoomById(String roomId) {
        return chatRooms.get(roomId);
    }

    public ChatRoom createRoom(String roomName) {
        String randomId = UUID.randomUUID().toString();
        ChatRoom chatRoom = ChatRoom.builder()
                .roomId(randomId)
                .roomName(roomName)
                .build();
        chatRooms.put(randomId, chatRoom);

        chatRoomRepository.save(chatRoom);

        applicationEventPublisher.publishEvent(new ChatRoomCreatedEvent(this)); // 이벤트 발행

        return chatRoom;
    }

    // 순환참조를 피하기 위한 이벤트 기반 아키텍처
    public class ChatRoomCreatedEvent extends ApplicationEvent {
        public ChatRoomCreatedEvent(Object source) {
            super(source);
        }
    }
}
