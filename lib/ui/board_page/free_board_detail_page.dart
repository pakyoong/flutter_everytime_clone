import 'package:flutter/material.dart';
import 'free_board_page.dart';
import 'package:everytime/model/board_page/comment.dart';

bool isRecomment = false;

Comment comment1 = Comment("닉네임", "댓글입니다.1", "11/30 12:27", 2, true, false);
Comment comment2 = Comment("닉네임2", "댓글입니다.2", "11/30 12:27", 2, false, false);
Comment comment3 = Comment("닉네임3", "댓글입니다.3", "11/30 12:27", 2, true, true);
Comment comment4 = Comment.clone(comment1);
Comment comment5 = Comment.clone(comment2);
Comment comment6 = Comment.clone(comment3);


List<Comment> commentSet = [
  comment1,
  comment2,
  comment3,
  comment4,
  comment5,
  comment6,
];

class FreeBoardDetail extends StatefulWidget {
  const FreeBoardDetail({super.key});

  @override
  State<FreeBoardDetail> createState() => _FreeBoardDetailState();
}

class _FreeBoardDetailState extends State<FreeBoardDetail> {
  bool isAnonym = false;
  bool isAlarm = false;
  @override
  Widget build(BuildContext context) {
    //추천 기능
    void checkPosvote() {
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
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    elevation: 0,
                  ),
                  child: const Text(
                    "취소",
                    style: TextStyle(color: Color.fromARGB(255, 206, 67, 67)),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    elevation: 0,
                  ),
                  child: const Text(
                    "확인",
                    style: TextStyle(color: Color.fromARGB(255, 206, 67, 67)),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          });
    }

    //신고 기능
    void checkReport() {
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
    void checkScrap() {
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
              Text('자유게시판',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900)),
              SizedBox(
                height: 3,
              ),
              Text('금오공대',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w100,
                      color: Color.fromARGB(255, 142, 141, 141)))
            ]),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
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
            onSelected: (int more) async {
              if (more == 1) {
                //새로 고침 기능 추가
              }
              if (more == 2) {
                checkReport();
              }
              if (more == 3) {
                // URL 공유 추가
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
              const PopupMenuItem<int>(value: 1, child: Text("새로고침")),
              const PopupMenuItem<int>(value: 2, child: Text("신고")),
              const PopupMenuItem<int>(value: 3, child: Text("URL 공유")),
            ],
          ),
          const SizedBox(
            width: 10,
            height: 10,
          ),
        ],
      ),
      body: ListView(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.asset(
                            'assets/anonymous.jpg',
                            width: 40,
                            height: 40,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              postSet[0].isanonymous == true
                                  ? "익명"
                                  : postSet[0].writer,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              postSet[0].time,
                              style:
                              const TextStyle(fontSize: 13, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Text(
                      postSet[0].title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      postSet[0].contents,
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.asset('assets/img10.jpg'),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.thumb_up_outlined,
                            size: 12, color: Colors.red),
                        Text(
                          " ",
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          "0",
                          style: TextStyle(fontSize: 12, color: Colors.red),
                        ),
                        Text(
                          "  ",
                          style: TextStyle(fontSize: 12),
                        ),
                        Icon(Icons.messenger_outline,
                            size: 12, color: Colors.cyan),
                        Text(
                          " ",
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          "12",
                          style: TextStyle(fontSize: 12, color: Colors.cyan),
                        ),
                        Text(
                          "  ",
                          style: TextStyle(fontSize: 12),
                        ),
                        Icon(Icons.star_outline_rounded,
                            size: 12, color: Colors.yellow),
                        Text(
                          " ",
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          "0",
                          style: TextStyle(fontSize: 12, color: Colors.yellow),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                              const Color.fromARGB(255, 242, 242, 242),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.thumb_up_outlined,
                                    color: Color(0xFF424242), size: 12),
                                Text(
                                  ' 공감',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF424242),
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            onPressed: () {
                              checkPosvote();
                            }),
                        const SizedBox(width: 5),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.star_outline_rounded,
                                    size: 12, color: Color(0xFF424242)),
                                Text(
                                  ' 스크랩',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF424242),
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            onPressed: () {
                              checkScrap();
                            }),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const CommentDetail(),
                    const SizedBox(
                      height: 80,
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
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
                    isAnonym
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
                              isAnonym = !isAnonym;
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
                              isAnonym = !isAnonym;
                            });
                          }),
                    ),
                    Text(
                      '익명',
                      style: TextStyle(
                        color: isAnonym ? Colors.red : Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextField(
                    style: const TextStyle(fontSize: 17.0),
                    cursorColor: Colors.red,
                    cursorHeight: 22.5,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: '댓글을 입력하세요.',
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      suffixIcon: Transform.scale(
                        scale: 0.7,
                        child: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.send_outlined,
                              size: 25,
                              color: Colors.red,
                            )),
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

class CommentDetail extends StatefulWidget {
  const CommentDetail({super.key});

  @override
  State<CommentDetail> createState() => _CommentDetailState();
}

class _CommentDetailState extends State<CommentDetail> {
  @override
  Widget build(BuildContext context) {
    void commentPosvote() {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Column(
                children: <Widget>[
                  Text("이 댓글에 공감하시겠습니까?"),
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
                    //commentSet[0].commentlike++;
                  },
                ),
              ],
            );
          });
    }

    void checkReport() {
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

    void commentMore() {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                      width: double.infinity,
                      height: 30,
                      child: const Text(
                        '대댓글 알림',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      checkReport();
                    },
                    child: Container(
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                        width: double.infinity,
                        height: 30,
                        child: const Text(
                          "신고",
                          style: TextStyle(fontSize: 18),
                        )),
                  ),
                ],
              ),
            );
          });
    }

    void checkRecomment() {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Column(
                children: <Widget>[
                  Text("대댓글을 작성하시겠습니까?"),
                ],
              ),
              //
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
                    setState(() {
                      isRecomment = !isRecomment;
                    });
                  },
                ),
              ],
            );
          });
    }

    int count = 0;
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: commentSet.length,
      itemBuilder: (BuildContext context, index) {
        if (commentSet[index].isanonymous == true) { count++; }
        return Padding(
          padding: const EdgeInsets.all(2.0),
          child: Row(
            children: [
              Column(
                children: [
                  if (commentSet[index].isrecomment == true)
                    const Icon(
                      Icons.subdirectory_arrow_right_rounded,
                      color: Colors.black54,
                    ),
                  if (commentSet[index].isrecomment == true)
                    const SizedBox(
                      height: 50,
                    )
                ],
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: commentSet[index].isrecomment ? Colors.grey : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(6, 0, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (commentSet[index].isrecomment == false)
                          Container(
                            height: 1.0,
                            color: Colors.grey,
                          ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                //if (commentSet[index].isanonymous == true)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.asset(
                                    'assets/anonymous.jpg',
                                    width: 30,
                                    height: 30,
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  commentSet[index].isanonymous == true
                                      ? "익명$count"
                                      : commentSet[index].commentwriter,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    if (commentSet[index].isrecomment == false)
                                      IconButton(
                                        constraints: const BoxConstraints(),
                                        onPressed: () {
                                          checkRecomment();
                                        },
                                        icon: const Icon(
                                          Icons.messenger_outline,
                                          size: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    if (commentSet[index].isrecomment == false)
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 0, 0),
                                        child: Container(
                                          height: 12.0,
                                          width: 1.0,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    IconButton(
                                      constraints: const BoxConstraints(),
                                      onPressed: () {
                                        commentPosvote();
                                      },
                                      icon: const Icon(
                                        Icons.thumb_up_outlined,
                                        size: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      child: Container(
                                        height: 12.0,
                                        width: 1.0,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    IconButton(
                                      constraints: const BoxConstraints(),
                                      onPressed: () {
                                        commentMore();
                                      },
                                      icon: const Icon(
                                        Icons.more_vert,
                                        size: 15,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          commentSet[index].commentcontents,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Text(postSet[index].time,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                )),
                            const Text(" 18:24",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                )),
                            if (commentSet[index].commentlike != 0)
                              Row(
                                children: [
                                  const SizedBox(width: 5),
                                  const Icon(Icons.thumb_up_outlined,
                                      size: 12, color: Colors.red),
                                  const Text(
                                    " ",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  Text(
                                    commentSet[index].commentlike.toString(),
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.red),
                                  ),
                                ],
                              )
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
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
