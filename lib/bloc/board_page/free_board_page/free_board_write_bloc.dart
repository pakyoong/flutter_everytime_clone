import 'package:everytime/model/board_page/post.dart';
import 'package:everytime/ui/board_page/database.dart';

// 이벤트 정의
abstract class FreeBoardWriteEvent {}

class PostWrittenEvent extends FreeBoardWriteEvent {
  final String title;
  final String content;

  PostWrittenEvent(this.title, this.content);
}

// 상태 정의
abstract class FreeBoardWriteState {}

class FreeBoardWriteInitial extends FreeBoardWriteState {}

class FreeBoardWriteSuccess extends FreeBoardWriteState {}

class FreeBoardWriteError extends FreeBoardWriteState {
  final String errorMessage;

  FreeBoardWriteError(this.errorMessage);
}

// BLoC 클래스 정의
class FreeBoardWriteBloc {
  // 다른 필요한 상태나 메서드들을 추가할 수 있습니다.

  String _title = "";
  String _content = "";
  bool _isanonymous = false;

  String get title => _title;

  String get content => _content;

  bool get isAnonym => _isanonymous;

  // 제목 업데이트
  void updateTitle(String title) {
    _title = title;
  }

  // 내용 업데이트
  void updateContent(String content) {
    _content = content;
  }
  
  //isanonymous 업데이트
  void updateIsanonymous(bool isanonymous) {
    _isanonymous = isanonymous;
  }

  // 게시글 작성 및 Post에 추가
  Future<void> submitPost() async {
    // Post에 추가하는 로직을 여기에 구현
    Post newPost =
        Post(_title, _content, null, "user", "12/02", 0, _isanonymous, commentSet0
            // 다른 필요한 정보들도 추가할 수 있습니다.
            );

    // 추가한 Post를 어딘가에 저장하고, 화면 갱신 등의 작업 수행
    // 예를 들어, postSet.add(newPost);와 같이 리스트에 추가할 수 있습니다.
    postSet.insert(0, newPost);
}
}