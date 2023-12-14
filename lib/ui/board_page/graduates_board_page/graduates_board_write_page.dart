import 'package:everytime/ui/board_page/graduates_board_page/graduates_board_page.dart';
import 'package:flutter/material.dart';
import 'package:everytime/bloc/board_page/post_bloc.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class GraduatesBoardWrite extends StatefulWidget {
  final PostBloc graduatesBoardBloc;
  const GraduatesBoardWrite({super.key, required this.graduatesBoardBloc});

  @override
  State<GraduatesBoardWrite> createState() => GraduatesBoardWriteState();
}

class GraduatesBoardWriteState extends State<GraduatesBoardWrite> {
  //late PostBloc graduatesBoardWriteBloc = PostBloc();
  late String boardId = 'Graduates';
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  bool isAnonym = false;
  File? _selectedImage;
  Future<File?> _pickImageFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      return File(pickedFile.path);
    } else {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    //graduatesBoardWriteBloc = PostBloc();
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
              onPressed: () async{
                String title = _titleController.text;
                String content = _contentController.text;

                if (title.trim().isEmpty || content.trim().isEmpty) {
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
                  widget.graduatesBoardBloc.updateTitle(title);
                  widget.graduatesBoardBloc.updateContent(content);

                  if (_selectedImage != null) {
                    await widget.graduatesBoardBloc.submitPostWithImage(boardId, _selectedImage!);
                  } else {
                    await widget.graduatesBoardBloc.submitPost(boardId);
                  }

                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GraduatesBoard(boardBloc: widget.graduatesBoardBloc),
                    ),
                  );
                  _titleController.clear();
                  _contentController.clear();
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
                    "에브리타임은 누구나 기분 좋게 참여할 수 있는 커뮤니티를 만들기 위해 커뮤니티 이용규칙을 제정하여 운영하고 있습니다.",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    "위반 시 게시물이 삭제되고 서비스 이용이 일정 기간 제한될 수 있습니다.",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            if (_selectedImage != null)
              Image.file(_selectedImage!),
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
                    onPressed: () async {
                      File? image = await _pickImageFromGallery();

                      if (image != null) {
                        setState(() {
                          _selectedImage = image;
                        });
                      }
                    },
                  ),
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
