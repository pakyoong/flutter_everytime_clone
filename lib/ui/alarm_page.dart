import 'package:everytime/bloc/tab_navigation_bloc.dart';
import 'package:everytime/component/custom_tabbar.dart';
import 'package:everytime/component/custom_tabbar_view.dart';
import 'package:everytime/ui/alarm_page/alarm_note_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AlarmPage extends StatefulWidget {
  const AlarmPage({Key? key}) : super(key: key);

  @override
  State<AlarmPage> createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  final _tabBarBloc = TabNavigationBloc();
  Stream<DocumentSnapshot>? alarmsStream;
  String? userEmail;

  @override
  void initState() {
    super.initState();
    userEmail = FirebaseAuth.instance.currentUser?.email ?? '';
    alarmsStream = FirebaseFirestore.instance
        .collection('user_alarms')
        .doc(userEmail)
        .snapshots();
  }

  void removeAlarm(String commentId) async {
    await FirebaseFirestore.instance
        .collection('user_alarms')
        .doc(userEmail)
        .update({
      'commentIds': FieldValue.arrayRemove([commentId])
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomTabBar(
              tabBarBloc: _tabBarBloc,
              buttonTitleList: const ['알림', '쪽지함'],
            ),
            CustomTabBarView(
              tabBarBloc: _tabBarBloc,
              tabs: [
                StreamBuilder<DocumentSnapshot>(
                  stream: alarmsStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.data() == null) {
                      return Center(child: Text('새로운 알람이 없습니다.'));
                    }
                    var alarmData = snapshot.data!.data() as Map<String, dynamic>;
                    List<dynamic> commentIds = alarmData['commentIds'] ?? [];

                    return ListView.builder(
                      itemCount: commentIds.length,
                      itemBuilder: (context, index) {
                        return Container(
                          color: index % 2 == 0 ? Colors.grey[200] : Colors.white, // 배경색 번갈아가며 설정
                          child: ListTile(
                            leading: Icon(Icons.notifications), // 종 모양 아이콘 추가
                            title: Text('게시글에 새로운 댓글이 달렸습니다.'),
                            onTap: () {
                              String commentId = commentIds[index];
                              removeAlarm(commentId); // 알림 제거
                              // TODO: 게시글 상세 페이지로 이동
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
                AlarmNotePage(),
              ],
            ),
          ],
        ),
      ),
    );
  }

}

