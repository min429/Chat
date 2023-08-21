import 'dart:convert';

import 'package:chat_client/config/AppConfig.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../dto/User.dart';
import 'MainPage.dart';
import 'SignUpPage.dart';

void main() {
  runApp(
    const MaterialApp(
      home: LoginPage(),
    ),
  );
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _userPwdController = TextEditingController();

  Future<bool> _login() async {
    final userId = _userIdController.text;
    final userPwd = _userPwdController.text;

    final response = await http.post(
      Uri.parse('${AppConfig.httpUrl}user/$userId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'userPwd': userPwd}),
    );

    if (response.statusCode == 200) {
      final user = User.fromJson(jsonDecode(response.body));
      AppConfig.userName = user.userName;
      return true;
    }
    return false;
  }

  void _handleLoginResponse(bool success) {
    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('아이디 또는 비밀번호가 일치하지 않습니다')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _userIdController,
              decoration: InputDecoration(hintText: 'Id'),
            ),
            TextField(
              controller: _userPwdController,
              decoration: InputDecoration(hintText: 'Password'),
              obscureText: true,
              onSubmitted: (_) async {  // 추가된 부분
                bool success = await _login();
                _handleLoginResponse(success);
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                bool success = await _login();
                _handleLoginResponse(success);
              },
              child: Text('Login'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpPage()),
                );
              },
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
