// ignore_for_file: must_call_super

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:everytime/bloc/user_profile_management_bloc.dart';
import 'package:everytime/component/custom_appbar.dart';
import 'package:everytime/component/custom_appbar_animation.dart';
import 'package:everytime/component/custom_appbar_button.dart';
import 'package:everytime/ui/home_page/search_page/search_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:url_launcher/url_launcher.dart';

import '../board_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
    required this.scrollController,
    required this.userBloc,
  }) : super(key: key);

  final ScrollController scrollController;
  final UserProfileManagementBloc userBloc;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  final BehaviorSubject<double> _scrollOffset = BehaviorSubject.seeded(0);

  @override
  void initState() {
    super.initState();

    widget.scrollController.addListener(() {
      _scrollOffset.sink.add(widget.scrollController.offset);
    });
  }

  @override
  void dispose() {
    super.dispose();

    widget.scrollController.removeListener(() {
      _scrollOffset.sink.add(widget.scrollController.offset);
    });

    _scrollOffset.close();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    // ... (existing code)

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBarAnimation(
              scrollOffsetStream: _scrollOffset.stream,
              title: "에브리타임",
            ),
            StreamBuilder(
              stream: widget.userBloc.univ,
              builder: (_, univSnapshot) {
                if (univSnapshot.hasData) {
                  return Column(
                    children: [
                      CustomAppBar(
                        title: univSnapshot.data!,
                        buttonList: [
                          CustomAppBarButton(
                            icon: Icons.search_rounded,
                            onPressed: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (BuildContext pageContext) {
                                    return SearchPage(
                                      userBloc: widget.userBloc,
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      // Add 7 buttons below the title
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              _launchURL('https://www.kumoh.ac.kr/ko/index.do');
                            },
                            child: Image.asset(
                              'assets/home.png',
                              width: 80.0,
                              height: 80.0,
                            ), // Image path for button 1
                          ),
                          GestureDetector(
                            onTap: () {
                              _launchURL(
                                  'https://www.kumoh.ac.kr/bus/index.do');
                            },
                            child: Image.asset(
                              'assets/bus.png',
                              width: 80.0,
                              height: 80.0,
                            ), // Image path for button 2
                          ),
                          GestureDetector(
                            onTap: () {
                              _launchURL(
                                  'https://www.kumoh.ac.kr/ko/sub06_01_01_01.do');
                            },
                            child: Image.asset(
                              'assets/gongji.png',
                              width: 80.0,
                              height: 80.0,
                            ), // Image path for button 3
                          ),
                          GestureDetector(
                            onTap: () {
                              _launchURL(
                                  'https://www.kumoh.ac.kr/ko/schedule.do');
                            },
                            child: Image.asset(
                              'assets/plan.png',
                              width: 80.0,
                              height: 80.0,
                            ), // Image path for button 4
                          ),
                          GestureDetector(
                            onTap: () {
                              _launchURL(
                                  'https://mail.kumoh.ac.kr/account/login.do');
                            },
                            child: Image.asset(
                              'assets/mail.png',
                              width: 80.0,
                              height: 80.0,
                            ), // Image path for button 5
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Container(
                              padding: EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 0.5,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      const Text(
                                        '즐겨찾는 게시판',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 23.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 20), // 원하는 간격 설정
                                      TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (BuildContext pageContext) {
                                                return const BoardPage();
                                              },
                                            ),
                                          );
                                        },
                                        child: const Text(
                                          '더 보기 >',
                                          style: TextStyle(
                                            color: Color(0xFFC62818),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  // Add buttons for each board
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          var page = boardPages['자유게시판'];
                                          if (page != null) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => page),
                                            );
                                          }
                                        },
                                        child: Row(
                                          children: [
                                            const Text('자유게시판   ',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                )
                                              ),
                                            const SizedBox(width: 70),
                                            FutureBuilder<DocumentSnapshot>(
                                              future: _fetchMostRecentPostTitle(
                                                  'Free'),
                                              builder: (_, freeBoardSnapshot) {
                                                String freeBoardTitle =
                                                    freeBoardSnapshot
                                                            .data?['title'] ??
                                                        'No Title';

                                                return Text(freeBoardTitle,
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                )                                          
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          var page = boardPages['비밀게시판'];
                                          if (page != null) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => page),
                                            );
                                          }
                                        },
                                        child: Row(
                                          children: [
                                            const Text('비밀게시판   ',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                )
                                              ),
                                            const SizedBox(width: 75),
                                            FutureBuilder<DocumentSnapshot>(
                                              future: _fetchMostRecentPostTitle(
                                                  'Secret'),
                                              builder:
                                                  (_, secretBoardSnapshot) {
                                                String secretBoardTitle =
                                                    secretBoardSnapshot
                                                            .data?['title'] ??
                                                        'No Title';

                                                return Text(secretBoardTitle,
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                )
                                              );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          var page = boardPages['졸업생게시판'];
                                          if (page != null) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => page),
                                            );
                                          }
                                        },
                                        child: Row(
                                          children: [
                                            const Text('졸업생게시판  ',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                )
                                              ),
                                            const SizedBox(width: 65),
                                            FutureBuilder<DocumentSnapshot>(
                                              future: _fetchMostRecentPostTitle(
                                                  'Graduates'),
                                              builder:
                                                  (_, graduatesBoardSnapshot) {
                                                String graduatesBoardTitle =
                                                    graduatesBoardSnapshot
                                                            .data?['title'] ??
                                                        'No Title';

                                                return Text(
                                                    graduatesBoardTitle,
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                )
                                              );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          var page = boardPages['새내기게시판'];
                                          if (page != null) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => page),
                                            );
                                          }
                                        },
                                        child: Row(
                                          children: [
                                            const Text('새내기게시판  ',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                )
                                              ),
                                            const SizedBox(width: 65),
                                            FutureBuilder<DocumentSnapshot>(
                                              future: _fetchMostRecentPostTitle(
                                                  'Freshmen'),
                                              builder:
                                                  (_, freshmenBoardSnapshot) {
                                                String freshmenBoardTitle =
                                                    freshmenBoardSnapshot
                                                            .data?['title'] ??
                                                        'No Title';

                                                return Text(freshmenBoardTitle,
                                                style: const  TextStyle(
                                                  color: Colors.grey,
                                                )
                                              );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          var page = boardPages['시사・이슈'];
                                          if (page != null) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => page),
                                            );
                                          }
                                        },
                                        child: Row(
                                          children: [
                                            const Text('시사・이슈          ',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                )
                                              ),
                                            const SizedBox(width: 50),
                                            FutureBuilder<DocumentSnapshot>(
                                              future: _fetchMostRecentPostTitle(
                                                  'CurrentIssues'),
                                              builder: (_,
                                                  currentissuesBoardSnapshot) {
                                                String currentissuesBoardTitle =
                                                    currentissuesBoardSnapshot
                                                            .data?['title'] ??
                                                        'No Title';

                                                return Text(
                                                    currentissuesBoardTitle,
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                )
                                              );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          var page = boardPages['정보게시판'];
                                          if (page != null) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => page),
                                            );
                                          }
                                        },
                                        child: Row(
                                          children: [
                                            const Text('정보게시판   ',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                )
                                              ),
                                            const SizedBox(width: 75),
                                            FutureBuilder<DocumentSnapshot>(
                                              future: _fetchMostRecentPostTitle(
                                                  'Info'),
                                              builder: (_, infoBoardSnapshot) {
                                                String infoBoardTitle =
                                                    infoBoardSnapshot
                                                            .data?['title'] ??
                                                        'No Title';

                                                return Text(infoBoardTitle,
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                )
                                              );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }
                return CustomAppBar(
                  title: "로딩중..",
                  buttonList: const [],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconTextSet(
    IconData icon,
    String url,
    String buttonText,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomAppBarButton(
          icon: icon,
          onPressed: () {
            _launchURL(url);
          },
        ),
        Text(
          buttonText,
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  // URL을 열기 위한 함수
  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

Future<DocumentSnapshot> _fetchMostRecentPostTitle(String boardType) async {
  CollectionReference postsCollection = FirebaseFirestore.instance
      .collection('Board')
      .doc(boardType)
      .collection('Post');

  QuerySnapshot postQuery =
      await postsCollection.orderBy('postNo', descending: true).limit(1).get();

  if (postQuery.docs.isNotEmpty) {
    return postQuery.docs.first;
  } else {
    // Handle the case where there are no posts
    return Future.value(null);
  }
}
