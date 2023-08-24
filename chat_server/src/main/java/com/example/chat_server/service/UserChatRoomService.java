package com.example.chat_server.service;

import com.example.chat_server.dto.ChatMessage;
import com.example.chat_server.dto.UserChatRoom;
import com.example.chat_server.repository.UserChatRoomRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;

@Slf4j
@RequiredArgsConstructor
@Service
public class UserChatRoomService {
    private final UserChatRoomRepository userChatRoomRepository;

    public void saveUserChatRoom(ChatMessage chatMessage){
        UserChatRoom userChatRoom = new UserChatRoom();
        userChatRoom.setUserId(chatMessage.getSenderId());
        userChatRoom.setRoomId(chatMessage.getRoomId());
        userChatRoomRepository.save(userChatRoom);
    }

    public List<String> findChatRoomsByUserId(String userId) {
        return userChatRoomRepository.findRoomIdsByUserId(userId);
    }
}
