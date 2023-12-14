import 'package:everytime/bloc/user_profile_management_bloc.dart';
import 'package:everytime/model/board_page/comment.dart';
import 'package:everytime/model/board_page/post.dart';
import 'package:everytime/ui/board_page/freshmen_board_page/freshmen_board_detail_page.dart';
import 'package:everytime/ui/board_page/freshmen_board_page/freshmen_board_write_page.dart';
import 'package:everytime/ui/home_page/search_page/search_page.dart';
import 'package:flutter/material.dart';
import 'package:everytime/bloc/board_page/post_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FreshmenBoard extends StatefulWidget {
  final PostBloc boardBloc;
  const FreshmenBoard({super.key, required this.boardBloc});

  @override
  State<FreshmenBoard> createState() => _FreshmenBoardState();
}

class _FreshmenBoardState extends State<FreshmenBoard> {
  late UserProfileManagementBloc userBloc = UserProfileManagementBloc();
  late PostBloc freshmenBoardBloc = PostBloc();
  List<Post> postList = [];
  late String boardId = 'Freshmen';
  Future<void> _loadDataFromFirestore() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance
            .collection('Board')
            .doc(boardId)
            .collection('Post')
            .orderBy('postNo', descending: true) 
            .get();

    setState(() {
      postList = snapshot.docs.map((doc) {
        Post post = Post.fromFirestore(doc);

        FirebaseFirestore.instance
            .collection('Board')
            .doc(boardId)
            .collection('Post')
            .doc(doc.id)
            .collection('Comment')
            .get()
            .then((commentSnapshot) {
          post.comments = commentSnapshot.docs.map((commentDoc) {
            return Comment.fromFirestore(commentDoc);
          }).toList();
          setState(() {
            postList = postList;
          });
        });

        return post;
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _loadDataFromFirestore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('새내기게시판',
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.bold)),
            SizedBox(
              height: 3,
            ),
            Text('금오공대', style: TextStyle(fontSize: 12, color: Colors.grey))
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, size: 20),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        SearchPage(userBloc: userBloc)), // 검색기능은 구현 안했습니다.
              );
            },
          ),
          PopupMenuButton<int>(
            icon: const Icon(Icons.more_vert, size: 20),
            onSelected: (int item) async {
              if (item == 1) {
                // 새로 고침 기능
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FreshmenBoard(
                            boardBloc: freshmenBoardBloc,
                          )),
                );
              } else if (item == 2) {
                //글쓰기 기능
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FreshmenBoardWrite(
                            freshmenBoardBloc: freshmenBoardBloc,
                          )),
                );
              } else if (item == 3) {
                // 즐겨찾기 기능 보류
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
              const PopupMenuItem<int>(
                value: 1,
                child: Text("새로고침"),
              ),
              const PopupMenuItem<int>(
                value: 2,
                child: Text("글 쓰기"),
              ),
              const PopupMenuItem<int>(
                value: 3,
                child: Text("즐겨찾기에서 제거"),
              ),
            ],
          ),
          const SizedBox(
            width: 10,
            height: 10,
          ),
        ],
      ),
      body: Detail(postList: postList),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 15.0),
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => FreshmenBoardWrite(
                        freshmenBoardBloc: freshmenBoardBloc,
                      )),
            );
          },
          label: const Text(
            '글 쓰기',
            style: TextStyle(
              fontSize: 13,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          icon: const Icon(Icons.edit, size: 20, color: Colors.red),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: const BorderSide(
              width: 1,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}

class Detail extends StatelessWidget {
  final List<Post> postList;
  const Detail({
    Key? key,
    required this.postList,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemExtent: 80,
            itemCount: postList.length,
            itemBuilder: (BuildContext context, index) {
              Post post = postList[index];

              return Column(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FreshmenBoardDetail(post: post),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: SizedBox(
                              width: double.infinity,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    postList[index].title,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    postList[index].content,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Row(
                                        children: [
                                          const Text(
                                            "  ",
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          const Icon(
                                            Icons.thumb_up_outlined,
                                            size: 12,
                                            color: Colors.red,
                                          ),
                                          const Text(
                                            " ",
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          Text(
                                            postList[index].like.toString(),
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.red,
                                            ),
                                          ),
                                          const Text(
                                            "  ",
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          const Icon(
                                            Icons.messenger_outline,
                                            size: 12,
                                            color: Colors.cyan,
                                          ),
                                          const Text(
                                            " ",
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          Text(
                                            postList[index]
                                                .comments
                                                .length
                                                .toString(),
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.cyan,
                                            ),
                                          ),
                                          const Text(
                                            "    ",
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          Text(
                                            postList[index].date,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          const Text(
                                            ' | ',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Text(
                                            postList[index].isAnonymous == true
                                                ? "익명"
                                                : postList[index].writer,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (postList[index].picture != null)
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  image: DecorationImage(
                                    image:
                                        NetworkImage(postList[index].picture ?? ''),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    color: Colors.grey,
                    height: 0,
                    thickness: 0.5,
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
