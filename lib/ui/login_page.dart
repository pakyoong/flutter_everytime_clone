// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:everytime/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


showToast(String msg) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 1,
    backgroundColor: Color(0xFFC62818),
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

class AuthWidget extends StatefulWidget {
  const AuthWidget({super.key});

  @override
  AuthWidgetState createState() => AuthWidgetState();
}


class AuthWidgetState extends State<AuthWidget> {
  final _formKey = GlobalKey<FormState>();

  late String name='';
  late String university='';
  late String nickname='';
  late String email='';
  late String password='';
  bool isInput = true; // false - result
  bool isSignIn = true; // false - SignUp

  // login
  signIn() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        print(value);

        // 여기에 사용자 정보 갱신 로직 추가
        await value.user!.reload();
        User? user = FirebaseAuth.instance.currentUser;

        if (user!.emailVerified) {
          // 이메일 인증 여부 확인
          setState(() {
            isInput = false;
          });
          showToast('에브리타임 로그인 성공');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const MainPage(),
            ),
          );
        } else {
          showToast('이메일 인증 오류');
        }
        return value;
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        // 오류수정
        showToast('계정을 찾을 수 없습니다.');
      } else if (e.code == 'invalid-password') {
        showToast('잘못된 비밀번호');
      } else {
        print(e.code);
      }
    }
  }

  // logout
  signOut() async {
    await FirebaseAuth.instance.signOut();
    setState(() => isInput = true);
  }

  // register
  signUp() async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        if (value.user!.email != null) {
          // Firestore에 사용자 정보 업데이트 (회원가입 시에 필요한 정보 추가)
          await FirebaseFirestore.instance.collection('users').doc(value.user!.uid).set({
            'name': name, // 이름 추가
            'university': university, // 대학교 추가
            'nickname': nickname, // 닉네임 추가
            'email': email,
          });
          // 이메일 인증 보내기
          await value.user!.sendEmailVerification();

          setState(() => isInput = false);
        }
        return value;
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showToast('약한 비밀번호');
      } else if (e.code == 'email-already-in-use') {
        showToast('이미 사용 중인 이메일');
      } else {
        showToast('다른 오류');
        print(e.code);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  List<Widget> getInputWidget() {
    return [
      Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Image.asset(
          'assets/everytime.jpg', // 이미지 경로에 맞게 수정
          height: 150.0,
        ),
      ),
      Form(
        key: _formKey,
        child: Column(
          // 회원가입 시에만 필요한 정보 입력 폼
          children: [
            if (!isSignIn) ...[
              SizedBox(height: 10.0),
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                child: TextFormField(
                  // <- name
                  decoration: InputDecoration(
                    labelText: '이름',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? false) {
                      return '이름을 입력해주세요';
                    }
                    return null;
                  },
                  onSaved: (String? value) {
                    name = value ?? "";
                  },
                ),
              ),
              SizedBox(height: 10.0),
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                child: TextFormField(
                  // <- university
                  decoration: InputDecoration(
                    labelText: '대학교',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? false) {
                      return '대학교를 입력해주세요';
                    }
                    return null;
                  },
                  onSaved: (String? value) {
                    university = value ?? "";
                  },
                ),
              ),
              SizedBox(height: 10.0),
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                child: TextFormField(
                  // <- nickname
                  decoration: InputDecoration(
                    labelText: '닉네임',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? false) {
                      return '닉네임을 입력해주세요';
                    }
                    return null;
                  },
                  onSaved: (String? value) {
                    nickname = value ?? "";
                  },
                ),
              ),
            ],
            // 공통 입력 폼
            SizedBox(height: 10.0),
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              child: TextFormField(
                // <- email
                decoration: InputDecoration(
                  labelText: '이메일',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? false) {
                    return '이메일을 입력해주세요';
                  }
                  return null;
                },
                onSaved: (String? value) {
                  email = value ?? "";
                },
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              child: TextFormField(
                // <- password
                decoration: InputDecoration(
                  labelText: '비밀번호',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                obscureText: true,
                validator: (value) {
                  if (value?.isEmpty ?? false) {
                    return '비밀번호를 입력해주세요';
                  }
                  return null;
                },
                onSaved: (String? value) {
                  password = value ?? "";
                },
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: 10.0),
      Container(
        width: MediaQuery.of(context).size.width * 0.7,
        child: ElevatedButton(
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              _formKey.currentState?.save();
              print(
                  'name: $name, university: $university, nickname: $nickname, email: $email, password : $password');
              (isSignIn) ? signIn() : signUp();
            }
          },
          style: ElevatedButton.styleFrom(
            primary: Color(0xFFC62818),
          ),
          child: Text(
            isSignIn ? '에브리타임 로그인' : '에브리타임 회원가입',
            style: TextStyle(
              color: Colors.white, // 흰색으로 변경
              fontWeight: FontWeight.bold, // 굵게 변경
            ),
          ),
        ),
      ),
      SizedBox(height: 10.0),
      RichText(
        textAlign: TextAlign.right,
        text: TextSpan(
          text: isSignIn
              ? '에브리타임에 처음이신가요? '
              : '이미 회원이신가요? ',
          style: Theme.of(context).textTheme.bodyLarge,
          children: <TextSpan>[
            TextSpan(
              text: isSignIn ? '회원가입' : '로그인',
              style: const TextStyle(
                color: Color(0xFFC62818),
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  setState(() => isSignIn = !isSignIn);
                },
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> getResultWidget() {
    String resultEmail = FirebaseAuth.instance.currentUser!.email!;
    return [
      Text(
        isSignIn
            ? "$resultEmail 로 로그인 하셨습니다.!"
            : "$resultEmail 로 회원가입 하셨습니다.! 이메일 인증을 거쳐야 로그인이 가능합니다.",
        style: const TextStyle(
          color: Colors.black54,
          fontWeight: FontWeight.bold,
        ),
      ),
      ElevatedButton(
        onPressed: () {
          if (isSignIn) {
            signOut();
          } else {
            setState(() {
              isInput = true;
              isSignIn = true;
            });
          }
        },
        child: Text(isSignIn ? '에브리타임 로그인' : '에브리타임 회원가입'),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: isInput ? getInputWidget() : getResultWidget(),
          ),
        ),
      ),
    );
  }
}
