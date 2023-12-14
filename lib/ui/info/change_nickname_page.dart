import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChangeNicknamePage extends StatefulWidget {
  @override
  _ChangeNicknamePageState createState() => _ChangeNicknamePageState();
}

class _ChangeNicknamePageState extends State<ChangeNicknamePage> {
  final _formKey = GlobalKey<FormState>();
  String newNickname = '';

  Future<void> updateNickname() async {
    if (newNickname.isNotEmpty) {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Firestore에서 사용자 닉네임 업데이트
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'nickname': newNickname,
        });

        // 성공적으로 업데이트 처리 후 이전 페이지로 이동
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('닉네임 변경'),
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
                  decoration: InputDecoration(labelText: '새 닉네임'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '닉네임을 입력해주세요.';
                    }
                    return null;
                  },
                  onChanged: (value) => newNickname = value,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      updateNickname();
                    }
                  },
                  child: Text('닉네임 변경'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
