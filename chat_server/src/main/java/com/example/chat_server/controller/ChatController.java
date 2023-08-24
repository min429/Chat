package com.example.chat_server.controller;

import com.example.chat_server.dto.ChatRoom;
import com.example.chat_server.service.ChatRoomService;
import com.example.chat_server.service.ChatService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping("/chat")
@CrossOrigin(origins = "*")
public class ChatController {
    private final ChatRoomService chatRoomService;

    @PostMapping
    public ChatRoom createRoom(@RequestBody String roomName) {
        return chatRoomService.createRoom(roomName);
    }

    @GetMapping
    public List<ChatRoom> findAllRoom() {
        return chatRoomService.findAllRoom();
    }
}