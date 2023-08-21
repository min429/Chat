package com.example.chat_server.dto;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "user")
@Getter
@Setter
public class User {
    @Id
    @Column(name = "userId")
    private String userId;

    @Column(name = "userPwd")
    private String userPwd;

    @Column(name = "userName")
    private String userName;

}
