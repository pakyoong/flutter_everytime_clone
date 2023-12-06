import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:everytime/bloc/board_page/comment_bloc.dart';
import 'package:everytime/model/board_page/post.dart';
import 'package:everytime/ui/board_page/secret_board_page/secret_board_detail_page.dart';
import 'package:flutter/material.dart';

bool isRecomment = false;

class SecretCommentDetail extends StatefulWidget {
  const SecretCommentDetail(
      {super.key, required this.post, required this.commentBloc});
  final Post post;
  final CommentBloc commentBloc;

  @override
  State<SecretCommentDetail> createState() => _SecretCommentDetailState(post: post);
}

class _SecretCommentDetailState extends State<SecretCommentDetail> {
  late Post post;
  late String postId;
  late List<DocumentSnapshot> commentList = [];
  late List<String> commentIdList;
  late String boardId = 'Secret';

  _SecretCommentDetailState({required this.post}) {
    postId = post.postId; // postId 초기화
  }
  @override
  void initState() {
    super.initState();
    loadComments();
  }

  void loadComments() async {
    var commentsSnapshot = await FirebaseFirestore.instance
        .collection('Board')
        .doc(boardId)
        .collection('Post')
        .doc(postId)
        .collection('Comment')
        .get();

    setState(() {
      commentList = commentsSnapshot.docs;
       commentIdList = commentsSnapshot.docs.map((doc) => doc.id).toList(); 
    });
  }

  @override
  Widget build(BuildContext context) {
      void commentLike(int index) {
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
                onPressed: () async {
              // Firestore에서 like 카운트 업데이트
              await widget.commentBloc.likeComment(boardId,postId, commentIdList[index]);

              // Firestore에서 업데이트된 댓글을 가져옴
              var updatedComment = await FirebaseFirestore.instance
                  .collection('Board')
                  .doc('Secret')
                  .collection('Post')
                  .doc(postId)
                  .collection('Comment')
                  .doc(commentIdList[index])
                  .get();
 Navigator.pop(context);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SecretBoardDetail(post: post),
                  ),
                );
              // 새로운 like 카운트로 로컬 상태 업데이트
              setState(() {
                commentList[index] = updatedComment;
              });

             
            },
              ),
            ],
          );
        });
  }

  void commentreport() {
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

  void recomment() {
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
                    // isRecomment = !isRecomment;
                    // widget.commentBloc.updateisRecomment(isRecomment);
                  });
                },
              ),
            ],
          );
        });
  }

  void commentMore(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                    width: double.infinity,
                    height: 30,
                    child: const Text(
                      '대댓글 알림',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  onPressed: () {
                    //isRecommentAlarm = !isRecommentAlarm
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    commentreport();
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
                TextButton(
              onPressed: () async {
                await widget.commentBloc.deleteComment(boardId, postId, commentIdList[index]);
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SecretBoardDetail(post: post),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                width: double.infinity,
                height: 30,
                child: const Text(
                  "삭제",
                  style: TextStyle(fontSize: 18),
                ),
              ),)
              ],
            ),
          );
        });
  }
    return ListView.builder(
      reverse: true,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: commentList.length,
      itemBuilder: (BuildContext context, index) {
        final comment = commentList[index]; // 개별 댓글에 접근

        return Padding(
          padding: const EdgeInsets.all(2.0),
          child: Row(
            children: [
              Column(
                children: [
                  if (comment != null && comment['isRecomment'] == true)
                    const Icon(
                      Icons.subdirectory_arrow_right_rounded,
                      color: Colors.black54,
                    ),
                  if (comment != null && comment['isRecomment'] == true)
                    const SizedBox(
                      height: 50,
                    )
                ],
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: comment != null && comment['isRecomment']
                        ? Colors.black12
                        : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(6, 0, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (comment != null && comment['isRecomment'] == false)
                          Container(
                            height: 1.0,
                            color: Colors.black12,
                          ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    image: const DecorationImage(
                                      image: AssetImage('assets/anonymous.jpg'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  comment != null &&
                                          comment['isAnonymous'] == true
                                      ? "익명"
                                      : comment['writer'],
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
                                    color: const Color.fromARGB(
                                        255, 250, 250, 250),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    if (comment != null &&
                                        comment['isRecomment'] == false)
                                      IconButton(
                                        constraints: const BoxConstraints(),
                                        onPressed: () {
                                          recomment();
                                        },
                                        icon: const Icon(
                                          Icons.messenger_outline,
                                          size: 12,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    if (comment != null &&
                                        comment['isRecomment'] == false)
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 0, 0),
                                        child: Container(
                                          height: 12.0,
                                          width: 1.0,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    IconButton(
                                      constraints: const BoxConstraints(),
                                      onPressed: () {
                                        commentLike(index);
                                      },
                                      icon: const Icon(
                                        Icons.thumb_up_outlined,
                                        size: 12,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      child: Container(
                                        height: 12.0,
                                        width: 1.0,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    IconButton(
                                      constraints: const BoxConstraints(),
                                      onPressed: () {
                                        commentMore(index);
                                      },
                                      icon: const Icon(
                                        Icons.more_vert,
                                        size: 15,
                                        color: Colors.black54,
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
                          comment != null ? comment['comment'] : '',
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Text(comment != null ? comment['date'] : '',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                )),
                            Text(comment != null ? comment['time'] : '',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                )),
                            if (comment != null && comment['like'] != 0)
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
                                    comment['like'].toString(),
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
