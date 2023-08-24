package com.example.chat_server.service;

import com.example.chat_server.dto.User;
import com.example.chat_server.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.mindrot.jbcrypt.BCrypt;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;
import java.util.Optional;

@Slf4j
@RequiredArgsConstructor
@Service
public class UserService {
    private final UserRepository userRepository;

    public ResponseEntity<?> createUser(User user) {
        // 빈칸이 존재하는지 확인
        if(user.getUserId().equals("") || user.getUserPwd().equals("") || user.getUserName().equals("")){
            return new ResponseEntity<>("빈칸 존재", HttpStatus.BAD_REQUEST);
        }
        // userId가 이미 존재하는지 확인
        if(userRepository.existsById(user.getUserId())) {
            return new ResponseEntity<>("이미 존재하는 아이디", HttpStatus.BAD_REQUEST);
        }
        // userName이 이미 존재하는지 확인
        if(userRepository.existsByUserName(user.getUserName())) {
            return new ResponseEntity<>("이미 존재하는 닉네임", HttpStatus.BAD_REQUEST);
        }
        // 사용자의 비밀번호를 해싱하여 저장
        String hashedPassword = BCrypt.hashpw(user.getUserPwd(), BCrypt.gensalt());
        user.setUserPwd(hashedPassword);
        userRepository.save(user);
        User savedUser = userRepository.save(user);
        return new ResponseEntity<>(savedUser, HttpStatus.OK);
    }

    public ResponseEntity<List<User>> getAllUsers() {
        List<User> users = userRepository.findAll();
        return new ResponseEntity<>(users, HttpStatus.OK);
    }

    public ResponseEntity<User> getUserById(String id) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("User not found with id: " + id));
        return new ResponseEntity<>(user, HttpStatus.OK);
    }

    public ResponseEntity<?> login(String id, Map<String, String> passwordData) {
        Optional<User> userOptional = userRepository.findById(id);
        if (userOptional.isPresent()) {
            User user = userOptional.get();

            // 비밀번호 확인
            if (BCrypt.checkpw(passwordData.get("userPwd"), user.getUserPwd())) {
                return new ResponseEntity<>(user, HttpStatus.OK);
            }
        }
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
    }
}
