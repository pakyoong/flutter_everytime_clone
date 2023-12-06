
import 'package:everytime/bloc/board_page/comment_bloc.dart';
import 'package:everytime/bloc/board_page/post_bloc.dart';
import 'package:everytime/model/board_page/post.dart';
import 'package:everytime/ui/board_page/secret_board_page/secret_board_page.dart';
import 'package:everytime/ui/board_page/secret_board_page/secret_comment_detail.dart';
import 'package:flutter/material.dart';

class SecretBoardDetail extends StatefulWidget {
  final Post post;

  const SecretBoardDetail({super.key, required this.post});

  @override
  State<SecretBoardDetail> createState() => _SecretBoardDetailState(post: post);
}

class _SecretBoardDetailState extends State<SecretBoardDetail> {
  late Post post;
  late String postId;
  late String boardId = 'Secret';
  late int like; // postId 추가
 CommentBloc commentBloc = CommentBloc();
PostBloc secretBoardBloc = PostBloc();
  TextEditingController _commentController = TextEditingController();

  _SecretBoardDetailState({required this.post}) {
    postId = post.postId; // postId 초기화
    like = post.like;
  }

  @override
  void initState() {
    super.initState();
    commentBloc = CommentBloc();
    isAnonymous = commentBloc.isAnonymous;
    isRecomment = commentBloc.isRecomment;
  }

  bool isAnonymous = false;
  bool isAlarm = false;

  @override
  Widget build(BuildContext context) {
    //추천 기능
    void pressLike() {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Column(
                children: <Widget>[
                  Text("이 글을 공감하시겠습니까?"),
                ],
              ),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    elevation: 0,
                  ),
                  child: const Text(
                    "취소",
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    elevation: 0,
                  ),
                  child: const Text(
                    "확인",
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () async {
                    await secretBoardBloc.sendLike(boardId, post.postId);
                    Navigator.pop(context);
                    setState(() {
                      // 가정: Post 객체에 좋아요 수를 나타내는 변수가 있다고 가정
                      post.like++;
                    });
                  },
                ),
              ],
            );
          });
    }

    //신고 기능
    void report() {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("신고 사유 선택"),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                        width: double.infinity,
                        height: 30,
                        child: const Text(
                          "낚시/놀람/도배",
                          style: TextStyle(fontSize: 18),
                        )),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                        width: double.infinity,
                        height: 30,
                        child: const Text(
                          "욕설/비하",
                          style: TextStyle(fontSize: 18),
                        )),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                        width: double.infinity,
                        height: 30,
                        child: const Text(
                          "게시판 성격에 부적절함",
                          style: TextStyle(fontSize: 18),
                        )),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                        width: double.infinity,
                        height: 30,
                        child: const Text(
                          "상업적 광고 및 판매",
                          style: TextStyle(fontSize: 18),
                        )),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                        width: double.infinity,
                        height: 30,
                        child: const Text(
                          "음란물/불건전한 만남 및 대화",
                          style: TextStyle(fontSize: 18),
                        )),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                        width: double.infinity,
                        height: 30,
                        child: const Text(
                          "정담/정치인 비하 및 선거운동",
                          style: TextStyle(fontSize: 18),
                        )),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                        width: double.infinity,
                        height: 30,
                        child: const Text(
                          "유출/사칭/사기",
                          style: TextStyle(fontSize: 18),
                        )),
                  ),
                ],
              ),
            );
          });
    }

    //스크랩
    void pressScrap() {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Column(
                children: <Widget>[
                  Text("이 글을 스크랩하시겠습니까?"),
                ],
              ),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    elevation: 0,
                  ),
                  child: const Text(
                    "취소",
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    elevation: 0,
                  ),
                  child: const Text(
                    "확인",
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          });
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 60,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('비밀게시판',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
              SizedBox(
                height: 3,
              ),
              Text('금오공대',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w100,
                      color: Colors.black87))
            ]),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => SecretBoard(BoardBloc: secretBoardBloc),
              ),
            );
          },
        ),
        actions: [
          isAlarm
              ? IconButton(
                  constraints: const BoxConstraints(),
                  iconSize: 50,
                  icon: const Icon(
                    Icons.alarm_on,
                    size: 25,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    setState(() {
                      isAlarm = !isAlarm;
                    });
                  })
              : IconButton(
                  constraints: const BoxConstraints(),
                  iconSize: 50,
                  icon: const Icon(
                    Icons.alarm_off,
                    size: 25,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      isAlarm = !isAlarm;
                    });
                  }),
          PopupMenuButton(
            child: const Icon(Icons.more_vert, size: 20),
            onSelected: (int item) async {
              if (item == 1) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SecretBoardDetail(post: post)),
                );
              }
              if (item == 2) {
                report();
              }
              if (item == 3) {
                //삭제기능 추가
                await secretBoardBloc.deletePost(boardId, post.postId);
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SecretBoard(BoardBloc: secretBoardBloc),
                  ),
                );
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
              const PopupMenuItem<int>(value: 1, child: Text("새로고침")),
              const PopupMenuItem<int>(value: 2, child: Text("신고")),
              const PopupMenuItem<int>(value: 3, child: Text("삭제")),
            ],
          ),
          const SizedBox(
            width: 10,
            height: 10,
          ),
        ],
      ),
      body: SingleChildScrollView(
          child: Column(children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 1,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              image: const DecorationImage(
                                image: AssetImage('assets/anonymous.jpg'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.post.isAnonymous == true
                                    ? "익명"
                                    : widget.post.writer,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                "${widget.post.date} ${widget.post.time}",
                                style: const TextStyle(
                                    fontSize: 13, color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Text(
                        widget.post.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        widget.post.content,
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      if (widget.post.picture != null)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              image: DecorationImage(
                                //image: AssetImage(widget.post.picture ?? ''),//제목2
                                image: NetworkImage(widget.post.picture), //제목3
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(Icons.thumb_up_outlined,
                              size: 12, color: Colors.red),
                          const Text(
                            " ",
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            widget.post.like.toString(),
                            style: const TextStyle(
                                fontSize: 12, color: Colors.red),
                          ),
                          const Text(
                            "  ",
                            style: TextStyle(fontSize: 12),
                          ),
                          const Icon(Icons.messenger_outline,
                              size: 12, color: Colors.cyan),
                          const Text(
                            " ",
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            widget.post.comments.length.toString(),
                            style: const TextStyle(
                                fontSize: 12, color: Colors.cyan),
                          ),
                          const Text(
                            "  ",
                            style: TextStyle(fontSize: 12),
                          ),
                          const Icon(Icons.star_outline_rounded,
                              size: 12, color: Colors.yellow),
                          const Text(
                            " ",
                            style: TextStyle(fontSize: 12),
                          ),
                          const Text(
                            "0", //스크랩 변수 추가시 텍스트 가져올 수 있도록
                            style:
                                TextStyle(fontSize: 12, color: Colors.yellow),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black12,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.thumb_up_outlined,
                                      color: Colors.black54, size: 12),
                                  Text(
                                    ' 공감',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              onPressed: () {
                                pressLike();
                              }),
                          const SizedBox(width: 5),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black12,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.star_outline_rounded,
                                      size: 12, color: Colors.black54),
                                  Text(
                                    ' 스크랩',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              onPressed: () {
                                pressScrap();
                              }),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      SecretCommentDetail(
                        post: post,
                        commentBloc: commentBloc,
                      ),
                      const SizedBox(
                        height: 80,
                      )
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ])),
      bottomSheet: BottomAppBar(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: <Widget>[
                    isAnonymous
                        ? Transform.scale(
                            scale: 1.0,
                            child: IconButton(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                iconSize: 50,
                                icon: const Icon(Icons.check_box_outlined,
                                    size: 25, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    isAnonymous = !isAnonymous;
                                    commentBloc.updateIsAnonymous(isAnonymous);
                                  });
                                }),
                          )
                        : Transform.scale(
                            scale: 1.0,
                            child: IconButton(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                iconSize: 50,
                                icon: const Icon(Icons.check_box_outline_blank,
                                    size: 25, color: Colors.grey),
                                onPressed: () {
                                  setState(() {
                                    isAnonymous = !isAnonymous;
                                    commentBloc.updateIsAnonymous(isAnonymous);
                                  });
                                }),
                          ),
                    Text(
                      '익명',
                      style: TextStyle(
                        color: isAnonymous ? Colors.red : Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    style: const TextStyle(fontSize: 15.0),
                    cursorColor: Colors.red,
                    cursorHeight: 22,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: '댓글을 입력하세요.',
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      suffixIcon: Transform.scale(
                        scale: 1,
                        child: IconButton(
  onPressed: () {
    String comment = _commentController.text;
    if (comment.trim().isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("입력 오류"),
            content: const Text("댓글을 입력하세요."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("확인"),
              ),
            ],
          );
        },
      );
    } else {
      commentBloc.updateComment(comment);
      if (commentBloc.comment != null) {
        commentBloc.writeComment(boardId, postId).then((_) {
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SecretBoardDetail(post: post),
            ),
          );
          _commentController.clear();
        });
      } else {
        print("Comment content is null");
      }
    }
  },
  icon: const Icon(
    Icons.send,
    size: 25,
    color: Colors.red,
  ),
),

                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
