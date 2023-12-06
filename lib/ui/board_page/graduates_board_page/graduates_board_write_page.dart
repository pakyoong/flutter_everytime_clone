import 'package:everytime/bloc/board_page/post_bloc.dart';
import 'package:everytime/ui/board_page/graduates_board_page/graduates_board_page.dart';
import 'package:flutter/material.dart';

class GraduatesBoardWrite extends StatefulWidget {
  final PostBloc graduatesBoardBloc;
  const GraduatesBoardWrite({super.key, required this.graduatesBoardBloc});

  @override
  State<GraduatesBoardWrite> createState() => GraduatesBoardWriteState();
}

class GraduatesBoardWriteState extends State<GraduatesBoardWrite> {
  late PostBloc graduatesBoardWriteBloc = PostBloc();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  late String boardId='Graduates';
  late bool isAnonym = false;

  @override
  void initState() {
    super.initState();
    graduatesBoardWriteBloc = PostBloc();
    // _titleController.text = widget.graduatesBoardWriteBloc.title;
    // _contentController.text = widget.graduatesBoardWriteBloc.content;
    isAnonym = widget.graduatesBoardBloc.isAnonymous;
  }

  bool isQuestion = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: const Text("글 쓰기"),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            color: Colors.black,
            icon: const Icon(Icons.close)),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: ElevatedButton(
              onPressed: () {
                // 입력된 제목과 내용을 가져와서 updateTitle, updateContent 메서드로 전달
                String title = _titleController.text;
                String content = _contentController.text;

                // 글 작성 전에 빈 값인지 확인
                if (title.trim().isEmpty || content.trim().isEmpty) {
                  // 제목 또는 내용이 비어있는 경우 메시지 표시
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("입력 오류"),
                        content: const Text("제목과 내용을 입력하세요."),
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
                  // GraduatesBoardWriteBloc에 제목과 내용 업데이트
                  widget.graduatesBoardBloc.updateTitle(title);
                  widget.graduatesBoardBloc.updateContent(content);

                  widget.graduatesBoardBloc.submitPost(boardId).then((_) {
                    // 글이 추가된 후에 새로고침
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            GraduatesBoard(BoardBloc: widget.graduatesBoardBloc),
                      ),
                    );
                    _titleController.clear();
                    _contentController.clear();
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: const Color.fromARGB(255, 201, 28, 28),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                '완료',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color.fromARGB(255, 255, 255, 255)),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
                child: TextField(
                  controller: _titleController,
                  cursorColor: Colors.redAccent,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w800),
                  decoration: const InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    hintText: '제목',
                  ),
                )),
            Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: TextField(
                  controller: _contentController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  minLines: 6,
                  cursorColor: Colors.redAccent,
                  style: const TextStyle(fontSize: 15),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: '내용을 입력하세요.',
                  ),
                )),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: const Color.fromARGB(255, 242, 242, 242),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      '커뮤니티 이용규칙 전체 보기 >',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color.fromARGB(255, 54, 54, 54)),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "에브리타임은 누구나 기분 좋게 참여할 수 있는 커뮤니티를 만들기 위해 커뮤니티 이용규칙을 제정하여 운영하고 있습니다.위반 시 게시물이 삭제되고 서비스 이용이 일정 기간 제한될 수 있습니다.",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  // Text(
                  //   "\n아래는 이 게시판에 해당하는 핵심 내용에 대한 요약 사항이며,게시물 작성 전 커뮤니티 이용규칙 전문을 반드시 확인하시기 바랍니다.",
                  //   style: TextStyle(fontSize: 12, color: Colors.grey),
                  // ),
                  // Text(
                  //   "\n※정치·사회 관련 행위 금지",
                  //   style: TextStyle(fontSize: 12, color: Colors.grey),
                  // ),
                  // Text(
                  //   "- 국가기관(정부·공무원), 정치 관련 단체(정치인·정당·시민단체), 언론, 시민단체에 대한 언급 혹은 이와 관련한 행위\n- 정책·외교 또는 정치·정파에 대한 의견, 주장 및 이념, 가치관을 드러내는 행위\n- 성별, 종교, 인종, 출신, 지역, 직업, 이념 등 사회적 이슈에 대한 언급 혹은 이와 관련한 행위\n- 위와 같은 내용으로 유추될 수 있는 비유, 은어 사용 행위",
                  //   style: TextStyle(fontSize: 12, color: Colors.grey),
                  // ),
                  // Text(
                  //   "*해당 게시물은 시사·이슈 게시판에만 작성 가능합니다.",
                  //   style: TextStyle(fontSize: 12, color: Colors.grey),
                  // ),
                  // Text(
                  //   "\n※홍보 및 판매 관련 금지 행위",
                  //   style: TextStyle(fontSize: 12, color: Colors.grey),
                  // ),
                  // Text(
                  //   "- 영리 여부와 관계없이 사업체·기관·단체·개인에게 직간접적으로 영향을 줄 수 있는 게시물 작성 행위\n- 위와 관련된 것으로 의심되거나 예상될 수 있는 바이럴 홍보 및 명칭·단어 언급 행위",
                  //   style: TextStyle(fontSize: 12, color: Colors.grey),
                  // ),
                  // Text(
                  //   "*해당 게시물은 홍보게시판에만 작성 가능합니다.",
                  //   style: TextStyle(fontSize: 12, color: Colors.grey),
                  // ),
                  // Text(
                  //   "\n※불법촬영물 유통 금지",
                  //   style: TextStyle(fontSize: 12, color: Colors.grey),
                  // ),
                  // Text(
                  //   "불법촬영물등을 기재할 경우 전기통신사업법에 따라 삭제 조치 및 서비스 이용이 영구적으로 제한될 수 있으며 관련 법률에 따라 처벌받을 수 있습니다.",
                  //   style: TextStyle(fontSize: 12, color: Colors.grey),
                  // ),
                  // Text(
                  //   "\n※그 밖의 규칙 위반",
                  //   style: TextStyle(fontSize: 12, color: Colors.grey),
                  // ),
                  // Text(
                  //   "- 타인의 권리 침해하거나 불쾌감을 주는 행위\n- 범죄,불법 행위 등 법형을 위반하는 행위\n- 욕설,비하,차별,혐오,자살,폭력 관련 애용을 포함한 게시물 작성 행위",
                  //   style: TextStyle(fontSize: 12, color: Colors.grey),
                  // ),
                ],
              ),
            )
          ],
        ),
      ),
      bottomSheet: BottomAppBar(
        clipBehavior: Clip.none,
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: SizedBox(
            height: 60,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      icon: const Icon(Icons.camera_alt_outlined,
                          size: 25, color: Colors.red),
                      onPressed: () {
                        //앨범 기능 추가
                      }),
                  Row(
                    children: [
                      Row(
                        children: <Widget>[
                          isQuestion
                              ? IconButton(
                                  iconSize: 50,
                                  icon: const Icon(Icons.check_box_outlined,
                                      size: 25, color: Colors.cyan),
                                  onPressed: () {
                                    setState(() {
                                      isQuestion = !isQuestion;
                                    });
                                  })
                              : IconButton(
                                  iconSize: 50,
                                  icon: const Icon(
                                      Icons.check_box_outline_blank,
                                      size: 25,
                                      color: Colors.grey),
                                  onPressed: () {
                                    setState(() {
                                      isQuestion = !isQuestion;
                                    });
                                  }),
                          Text(
                            '질문',
                            style: TextStyle(
                              color: isQuestion ? Colors.cyan : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          isAnonym
                              ? IconButton(
                                  iconSize: 50,
                                  icon: const Icon(Icons.check_box_outlined,
                                      size: 25, color: Colors.red),
                                  onPressed: () {
                                    setState(() {
                                      isAnonym = !isAnonym;
                                      widget.graduatesBoardBloc
                                          .updateIsAnonymous(isAnonym);
                                    });
                                  })
                              : IconButton(
                                  iconSize: 50,
                                  icon: const Icon(
                                      Icons.check_box_outline_blank,
                                      size: 25,
                                      color: Colors.grey),
                                  onPressed: () {
                                    setState(() {
                                      isAnonym = !isAnonym;
                                      widget.graduatesBoardBloc
                                          .updateIsAnonymous(isAnonym);
                                    });
                                  }),
                          Text(
                            '익명',
                            style: TextStyle(
                              color: isAnonym ? Colors.red : Colors.grey,
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                ]),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}
