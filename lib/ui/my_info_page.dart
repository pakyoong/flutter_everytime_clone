import 'package:everytime/bloc/user_profile_management_bloc.dart';
import 'package:everytime/component/custom_container.dart';
import 'package:everytime/component/custom_container_content_button.dart';
import 'package:everytime/component/custom_container_title.dart';
import 'package:everytime/global_variable.dart';
import 'package:flutter/material.dart';
import 'package:everytime/ui/info/change_password_page.dart';
import 'package:everytime/ui/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:everytime/ui/info/change_email_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:everytime/ui/info/change_nickname_page.dart';


class MyInfoPage extends StatefulWidget {
  const MyInfoPage({
    Key? key,
    required this.userBloc,
  }) : super(key: key);

  final UserProfileManagementBloc userBloc;

  @override
  State<MyInfoPage> createState() => _MyInfoPageState();
}


class _MyInfoPageState extends State<MyInfoPage> {
  final double _buttonWidth = appWidth * 0.15;
  final EdgeInsets _customContainerContentMargin = EdgeInsets.only(
    top: appHeight * 0.01,
    left: appWidth * 0.05,
    right: appWidth * 0.05,
  );



  final Map<String, List<ButtonInfo>> _data = {
    '계정': [
      ButtonInfo(
        title: '학교 인증',
        onPressed: () {},
      ),
      ButtonInfo(
        title: '비밀번호 변경',
        onPressed: () {},
      ),
      ButtonInfo(
        title: '이메일 변경',
        onPressed: () {},
      ),
    ],
    '커뮤니티': [
      ButtonInfo(
        title: '닉네임 설정',
        onPressed: () {},
      ),
      ButtonInfo(
        title: '프로필 이미지 변경',
        onPressed: () {},
      ),
      ButtonInfo(
        title: '이용 제한 내역',
        onPressed: () {},
      ),
      ButtonInfo(
        title: '쪽지 설정',
        onPressed: () {},
      ),
      ButtonInfo(
        title: '커뮤니티 이용규칙',
        onPressed: () {},
      ),
    ],
    '앱 설정': [
      ButtonInfo(
        title: '다크 모드',
        data: '시스템 설정',
        onPressed: () {},
      ),
      ButtonInfo(
        title: '알림 설정',
        onPressed: () {},
      ),
      ButtonInfo(
        title: '암호 잠금',
        onPressed: () {},
      ),
      ButtonInfo(
        title: '캐시 삭제',
        onPressed: () {},
      ),
    ],
    '이용 안내': [
      ButtonInfo(
        title: '앱 버전',
        data: '6.2.23(2022062319)',
        onPressed: () {},
      ),
      ButtonInfo(
        title: '문의하기',
        onPressed: () {},
      ),
      ButtonInfo(
        title: '공지사항',
        onPressed: () {},
      ),
      ButtonInfo(
        title: '서비스 이용약관',
        onPressed: () {},
      ),
      ButtonInfo(
        title: '개인정보 처리방침',
        onPressed: () {},
      ),
      ButtonInfo(
        title: '오픈소스 라이선스',
        onPressed: () {},
      ),
    ],
    '기타': [
      ButtonInfo(
        title: '정보 동의 설정',
        onPressed: () {},
      ),
      ButtonInfo(
        title: '회원 탈퇴',
        onPressed: () {},
      ),
      ButtonInfo(
        title: '로그아웃',
        onPressed: () {},
      ),
    ],
  };
  Future<void> deleteUserAccount() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Firestore에서 사용자 데이터 삭제
      await FirebaseFirestore.instance.collection('users').doc(user.uid).delete();

      // Firebase Authentication에서 사용자 삭제
      await user.delete();

      // 성공적으로 삭제 처리 후 로그인 페이지로 이동
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => AuthWidget()),
      );
    }
  }


  @override
  void initState() {
    super.initState();

    // '계정' 키에 대한 null 체크와 리스트 길이 확인
    if (_data.containsKey('계정') && _data['계정']!.length > 1) {
      // '비밀번호 변경' 버튼의 onPressed 수정
      _data['계정']![1] = ButtonInfo(
        title: '비밀번호 변경',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChangePasswordPage()),
          );
        },
      );

      // '이메일 변경' 버튼의 onPressed 수정
      int emailChangeIndex = _data['계정']!.indexWhere((buttonInfo) => buttonInfo.title == '이메일 변경');
      if (emailChangeIndex != -1) {
        _data['계정']![emailChangeIndex] = ButtonInfo(
          title: '이메일 변경',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChangeEmailPage()),
            );
          },
        );
      }
    }

    // '기타' 키에 대한 null 체크와 리스트 길이 확인
    if (_data.containsKey('기타')) {
      int logoutIndex = _data['기타']!.indexWhere((buttonInfo) => buttonInfo.title == '로그아웃');
      if (logoutIndex != -1) {
        _data['기타']![logoutIndex] = ButtonInfo(
          title: '로그아웃',
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => AuthWidget()), // AuthWidget은 로그인 페이지 위젯의 이름입니다.
            );
          },
        );
      }
    }
    // '기타' 키에 대한 null 체크와 리스트 길이 확인
    if (_data.containsKey('기타')) {
      int deleteAccountIndex = _data['기타']!.indexWhere((buttonInfo) => buttonInfo.title == '회원 탈퇴');
      if (deleteAccountIndex != -1) {
        _data['기타']![deleteAccountIndex] = ButtonInfo(
          title: '회원 탈퇴',
          onPressed: () {
            // 회원 탈퇴 전에 사용자에게 확인을 요청하는 대화상자 표시
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('회원 탈퇴'),
                  content: Text('정말로 계정을 삭제하시겠습니까? 이 작업은 되돌릴 수 없습니다.'),
                  actions: <Widget>[
                    TextButton(
                      child: Text('취소'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text('탈퇴'),
                      onPressed: () {
                        // 대화상자를 닫고 회원 탈퇴 처리
                        Navigator.of(context).pop();
                        deleteUserAccount();
                      },
                    ),
                  ],
                );
              },
            );
          },
        );
      }
    }

    // '커뮤니티' 키에 대한 null 체크와 리스트 길이 확인
    if (_data.containsKey('커뮤니티')) {
      int nicknameIndex = _data['커뮤니티']!.indexWhere((buttonInfo) => buttonInfo.title == '닉네임 설정');
      if (nicknameIndex != -1) {
        _data['커뮤니티']![nicknameIndex] = ButtonInfo(
          title: '닉네임 설정',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChangeNicknamePage()),
            );
          },
        );
      }
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: ListView(
                children: [
                  SizedBox(
                    height: appHeight * 0.0025,
                  ),
                  _buildUserInfo(),
                  ..._buildSections(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SizedBox(
      height: appHeight * 0.055,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: _buttonWidth,
            child: MaterialButton(
              padding: EdgeInsets.only(
                right: appWidth * 0.07,
              ),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: const Icon(Icons.arrow_back_ios_outlined),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          const Text(
            '내 정보',
            style: TextStyle(
              fontSize: 22,
            ),
          ),
          SizedBox(
            width: _buttonWidth,
          ),
        ],
      ),
    );
  }

  double _calculateContainerHeight(List<dynamic> list) {
    return list.length * (appHeight * 0.0625) - appHeight * 0.0375;
  }

  Widget _buildUserInfo() {
    return CustomContainer(
      usePadding: false,
      height: appHeight * 0.115,
      child: Container(
        padding: EdgeInsets.only(
          left: appWidth * 0.04,
          right: appWidth * 0.04,
        ),
        child: Row(
          children: [
            Container(
              width: appWidth * 0.15,
              height: appWidth * 0.15,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: appHeight * 0.025,
                left: appWidth * 0.025,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildUserId(),
                  _buildUserNameNickName(),
                  _buildUserUniv(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserId() {
    return StreamBuilder(
      stream: widget.userBloc.id,
      builder: (_, idSnapshot) {
        if (idSnapshot.hasData) {
          return Text(
            idSnapshot.data!,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildUserNameNickName() {
    return StreamBuilder(
      stream: widget.userBloc.name,
      builder: (_, nameSnapshot) {
        if (nameSnapshot.hasData) {
          return StreamBuilder(
            stream: widget.userBloc.nickName,
            builder: (__, nickNameSnapshot) {
              if (nickNameSnapshot.hasData) {
                return Text(
                  '${nameSnapshot.data!} / ${nickNameSnapshot.data!}',
                  style: TextStyle(
                    color: Theme.of(context).hintColor,
                    fontSize: 15,
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildUserUniv() {
    return StreamBuilder(
      stream: widget.userBloc.univ,
      builder: (_, univSnapshot) {
        if (univSnapshot.hasData) {
          return StreamBuilder(
            stream: widget.userBloc.year,
            builder: (__, yearSnapshot) {
              if (yearSnapshot.hasData) {
                return Text(
                  '${univSnapshot.data!} ${yearSnapshot.data}학번',
                  style: TextStyle(
                    color: Theme.of(context).hintColor,
                    fontSize: 15,
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  List<Widget> _buildSections() {
    return List.generate(
      _data.length,
          (dataIndex) {
        return CustomContainer(
          usePadding: true,
          // height: appHeight * 0.2875,
          child: Column(
            children: [
              CustomContainerTitle(
                title: _data.keys.elementAt(dataIndex),
                type: CustomContainerTitleType.none,
              ),
              Container(
                height: _calculateContainerHeight(
                    _data.values.elementAt(dataIndex)),
                margin: _customContainerContentMargin,
                child: Column(
                  children: List.generate(
                    _data.values.elementAt(dataIndex).length,
                        (buttonListIndex) {
                      return CustomContainerContentButton(
                        buttonInfoList: _data.values.elementAt(dataIndex),
                        currentIndex: buttonListIndex,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ButtonInfo {
  final String title;
  final String? data;
  final Function? onPressed;

  ButtonInfo({
    required this.title,
    this.data,
    this.onPressed,
  });
}
