import 'package:everytime/ui/board_page/freeBoard.dart';
import 'package:flutter/material.dart';

class BoardPage extends StatefulWidget {
  const BoardPage({Key? key}) : super(key: key);

  @override
  _Board createState() => _Board();
}
//즐겨찾기 기능은 보류
//게시판 아이콘은 추가가능 하지만 코드가 복잡해지므로 일단 제외

class _Board extends State<BoardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 10, top: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  const Text(
                    "게시판",
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  Container(width: 60, height: 2, color: Colors.black),
                ],
              ),
              const SizedBox(
                width: 15,
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: Container(
                  height: 250,
                  alignment: Alignment.topLeft,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.3),
                        width: 1,
                      )),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        board(context, "내가 쓴 글"),
                        board(context, "댓글 단 글"),
                        board(context, "스크랩"),
                        board(context, "HOT 게시판"),
                        board(context, "BEST 게시판"),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: Container(
                  height: 300,
                  alignment: Alignment.topLeft,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.3),
                        width: 1,
                      )),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        board(context, "자유게시판"),
                        board(context, "비밀게시판"),
                        board(context, "졸업생게시판"),
                        board(context, "새내기게시판"),
                        board(context, "시사・이슈"),
                        board(context, "정보게시판"),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final boardPages = {
  // "내가 쓴 글": freeBoard(), //MyPostBoard(),
  // "댓글 단 글": freeBoard(), //MyCommentBoard(),
  // "스크랩": freeBoard(), //ScrapBoard(),
  // "HOT 게시판": freeBoard(), //HotBoard(),
  // "BEST 게시판": freeBoard(), //BestBoard(),
  "자유게시판": const freeBoard(),
  // "비밀게시판": freeBoard(), //SecretBoard(),
  // "졸업생게시판": freeBoard(), //GraduatesBoard(),
  // "새내기게시판": freeBoard(), //FreshmenBoard(),
  // "시사・이슈": freeBoard(), //CurrentIssues(),
  // "정보게시판": freeBoard(), //InfoBoard(),
};


Widget board(BuildContext context, String title) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      GestureDetector(
        onTap: () {
          if (boardPages.containsKey(title)) {
            var page = boardPages[title];
            if (page != null) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => page),
              );
            }
          }
        },
        child: Text(title,
            textAlign: TextAlign.start,
            style: const TextStyle(color: Colors.black, fontSize: 15.0)),
      )
    ],
  );
}
