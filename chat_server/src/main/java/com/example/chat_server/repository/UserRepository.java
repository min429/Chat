package com.example.chat_server.repository;

import com.example.chat_server.dto.User;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepository extends JpaRepository<User, String> {
    boolean existsByUserName(String userName);
}
