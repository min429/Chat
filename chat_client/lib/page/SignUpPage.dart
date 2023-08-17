import 'package:chat_client/dto/User.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../config/AppConfig.dart';
import 'MainPage.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isLoading = false; // 로딩 상태

  Future<String?> _signUp() async {
    var user = User(
      userId: emailController.text,
      userPwd: passwordController.text,
      userName: usernameController.text,
    );

    final response = await http.post(
      Uri.parse('http://localhost:8080/ws/user'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user),
    );

    if (response.statusCode == 200) {
      AppConfig.userName = user.userId;
      return 'success';
    } else {
      return 'fail';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: usernameController,
              decoration: InputDecoration(hintText: 'Username'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(hintText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(hintText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: isLoading
                  ? null // isLoading이 true일 때 버튼 비활성화
                  : () async { // isLoading이 false일 때 버튼 클릭 이벤트를 처리
                setState(() {
                  isLoading = true; // 로딩 상태 시작
                });
                String? result = await _signUp(); // 회원 가입 요청
                if (!mounted) return; // 현재 위젯이 마운트 상태가 아니면 함수 종료
                setState(() {
                  isLoading = false; // 로딩 상태 종료
                });
                if (result == 'success') {
                  // 회원가입이 성공했을 때 메세지 표시, 메인 페이지로 이동
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('회원가입 성공')),
                  );
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MainPage()),
                  );
                } else {
                  // 회원가입이 실패했을 때 메세지 표시
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('회원가입 실패')),
                  );
                }
              },
              child: isLoading
                  ? CircularProgressIndicator(color: Colors.white) // 로딩 중일 때 표시될 위젯
                  : Text('Sign Up'), // 로딩 중이 아닐 때 표시될 위젯
            )
          ],
        ),
      ),
    );
  }
}


