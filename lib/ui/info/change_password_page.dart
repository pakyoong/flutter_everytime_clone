import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:everytime/ui/login_page.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String currentPassword = '';
  String newPassword = '';
  String confirmPassword = '';

  // 비밀번호 변경 함수
  Future<void> passwordUpdate() async {
    User? user = _firebaseAuth.currentUser;
    if (user != null && newPassword == confirmPassword) {
      try {
        // 현재 사용자를 재인증
        final cred = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
        );
        await user.reauthenticateWithCredential(cred);

        // 새 비밀번호로 업데이트
        await user.updatePassword(newPassword);

        // 비밀번호 변경 성공 메시지 표시
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('비밀번호가 성공적으로 변경되었습니다. 다시 로그인하세요.')),
        );

        // 로그인 페이지로 이동
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AuthWidget()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('비밀번호 변경에 실패했습니다: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('새 비밀번호가 일치하지 않습니다.')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('비밀번호 변경'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: '현재 비밀번호'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '현재 비밀번호를 입력해주세요.';
                    }
                    return null;
                  },
                  onChanged: (value) => currentPassword = value,
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  decoration: InputDecoration(labelText: '새 비밀번호'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '새 비밀번호를 입력해주세요.';
                    }
                    return null;
                  },
                  onChanged: (value) => newPassword = value,
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  decoration: InputDecoration(labelText: '새 비밀번호 확인'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '새 비밀번호 확인을 입력해주세요.';
                    } else if (value != newPassword) {
                      return '새 비밀번호와 일치하지 않습니다.';
                    }
                    return null;
                  },
                  onChanged: (value) => confirmPassword = value,
                ),
                SizedBox(height: 32.0),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      passwordUpdate();
                    }
                  },
                  child: Text('비밀번호 변경'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
