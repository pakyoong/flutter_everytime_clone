import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:everytime/ui/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChangeEmailPage extends StatefulWidget {
  @override
  _ChangeEmailPageState createState() => _ChangeEmailPageState();
}

class _ChangeEmailPageState extends State<ChangeEmailPage> {
  final _formKey = GlobalKey<FormState>();
  String currentPassword = '';
  String newEmail = '';
  bool isLoading = false; // 로딩 상태를 나타내는 변수

  Future<void> updateEmailInFirestore(String newEmail) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Firestore 내 사용자 문서의 이메일 필드 업데이트
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'email': newEmail,
      }).catchError((error) {
        // 오류 처리
        print("Error updating email in Firestore: $error");
      });
    }
  }

  // 이메일 변경 함수
  Future<void> changeEmail() async {
    setState(() {
      isLoading = true; // 이메일 변경 프로세스가 시작되었음을 나타냄
    });
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null && newEmail.isNotEmpty) {
        // 현재 비밀번호를 사용하여 재인증
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
        );

        await user.reauthenticateWithCredential(credential);

        // 새 이메일로 업데이트
        await user.updateEmail(newEmail);
        await user.sendEmailVerification();

        // Firestore 내 사용자 문서의 이메일 필드 업데이트
        await updateEmailInFirestore(newEmail);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('이메일 주소가 변경되었습니다. 이메일을 확인하여 인증해주세요.')),
        );

        // 로그인 페이지로 이동
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AuthWidget()),
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('이메일 변경에 실패했습니다: ${e.message}')),
      );
    } finally {
      setState(() {
        isLoading = false; // 이메일 변경 프로세스가 완료되었음을 나타냄
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('이메일 변경'),
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
                  decoration: InputDecoration(labelText: '새 이메일 주소'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '이메일 주소를 입력해주세요.';
                    }
                    // 이메일 형식 검증 로직을 추가할 수 있음
                    return null;
                  },
                  onChanged: (value) => newEmail = value,
                ),
                SizedBox(height: 32.0),
                isLoading
                    ? Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      changeEmail();
                    }
                  },
                  child: Text('이메일 변경'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
