package com.example.chat_server.repository;

import com.example.chat_server.dto.UserChatRoom;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface UserChatRoomRepository extends JpaRepository<UserChatRoom, String> {
    @Query("SELECT u.roomId FROM UserChatRoom u WHERE u.userId = :userId")
    List<String> findRoomIdsByUserId(@Param("userId") String userId);
}
