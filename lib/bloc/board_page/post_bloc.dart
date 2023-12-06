import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

// 이벤트 정의
abstract class PostEvent {}

class PostWrittenEvent extends PostEvent {
  final String title;
  final String content;

  PostWrittenEvent(this.title, this.content);
}

// 상태 정의
abstract class PostState {}

class PostInitial extends PostState {}

class PostSuccess extends PostState {}

class PostError extends PostState {
  final String errorMessage;

  PostError(this.errorMessage);
}

// BLoC 클래스 정의
class PostBloc {
  // 다른 필요한 상태나 메서드들을 추가할 수 있습니다.

  String _title = "";
  String _content = "";
  bool _isAnonymous = false;

  String get title => _title;

  String get content => _content;

  bool get isAnonymous => _isAnonymous;

  // 제목 업데이트
  void updateTitle(String title) {
    _title = title;
  }

  // 내용 업데이트
  void updateContent(String content) {
    _content = content;
  }

  // 익명 여부 업데이트
  void updateIsAnonymous(bool isAnonymous) {
    _isAnonymous = isAnonymous;
  }

  Future<PostState> submitPost(String boardId) async {
    try {
      String formattedDate =
          DateFormat('MM/dd').format(DateTime.now().toLocal());
                 String formattedTime =
        DateFormat('HH:mm').format(DateTime.now().toLocal());
      User? user = FirebaseAuth.instance.currentUser;
      // 사용자 UID로 /users 컬렉션에서 사용자 정보 가져오기
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .get();

      if (!userDoc.exists) {
        // 사용자 정보를 찾을 수 없는 경우 처리
        return PostError('사용자 정보를 찾을 수 없습니다.');
      }
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

      // Firestore에 게시글 추가
      await FirebaseFirestore.instance
          .collection('Board')
          .doc(boardId)
          .collection('Post')
          .add({
        'title': _title,
        'content': _content,
        'date': formattedDate,
        'time': formattedTime,
        'writer': userData['nickname'], // 작성자 정보를 여기에 추가
        'isAnonymous': _isAnonymous,
        'like': 0,
        'writerid':userData['email']
      });

      // 성공 상태를 발생시킴
      return PostSuccess();
    } catch (e) {
      // 실패 상태를 발생시킴
      return PostError('게시글 작성에 실패했습니다.');
    }
  }

  Future<PostState> deletePost(String boardId, String postId) async {
  try {
    // 현재 사용자 정보 가져오기
    User? user = FirebaseAuth.instance.currentUser;

    // 사용자 UID로 /users 컬렉션에서 사용자 정보 가져오기
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get();

    if (!userDoc.exists) {
      // 사용자 정보를 찾을 수 없는 경우 처리
      return PostError('사용자 정보를 찾을 수 없습니다.');
    }

    // 사용자 정보를 가져온 경우
    Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

    // 게시물 데이터를 가져옵니다.
    DocumentSnapshot postSnapshot = await FirebaseFirestore.instance
        .collection('Board')
        .doc(boardId)
        .collection('Post')
        .doc(postId)
        .get();

    // 게시물이 존재하는지 확인합니다.
    if (postSnapshot.exists) {
      // 게시물에서 작성자의 사용자 ID를 가져옵니다.
      String writerId = postSnapshot['writerid'];

      // 현재 사용자의 이메일 주소 가져오기
      String userEmail = userData['email'];

      // 요청한 사용자가 게시물 작성자인지 확인합니다.
      if (userEmail == writerId) {
        // 사용자가 작성자이므로 삭제를 진행합니다.
        await FirebaseFirestore.instance
            .collection('Board')
            .doc(boardId)
            .collection('Post')
            .doc(postId)
            .delete();

        // 성공 상태를 반환합니다.
        return PostSuccess();
      } else {
        // 사용자가 작성자가 아닌 경우 권한이 없다는 오류 상태를 반환합니다.
        return PostError('게시글 삭제 권한이 없습니다.');
      }
    } else {
      // 게시물이 존재하지 않는 경우 오류 상태를 반환합니다.
      return PostError('게시글이 존재하지 않습니다.');
    }
  } catch (e) {
    // 삭제 중 오류가 발생한 경우 오류 상태를 반환합니다.
    return PostError('게시글 삭제에 실패했습니다.');
  }
}

  Future<PostState> sendLike(String boardId, String postId) async {
    try {
      // Firestore에서 해당 게시글 가져오기
      var postDoc = await FirebaseFirestore.instance
          .collection('Board')
          .doc(boardId)
          .collection('Post')
          .doc(postId)
          .get();

      // 게시글이 존재하는지 확인
      if (postDoc.exists) {
        // 좋아요 수 증가
        int currentLikes = postDoc['like'] ?? 0;
        currentLikes++;

        // Firestore에 좋아요 수 업데이트
        await FirebaseFirestore.instance
            .collection('Board')
            .doc(boardId)
            .collection('Post')
            .doc(postId)
            .update({'like': currentLikes});

        // 성공 상태를 발생시킴
        return PostSuccess();
      } else {
        // 게시글이 존재하지 않는 경우 실패 상태를 발생시킴
        return PostError('게시글이 존재하지 않습니다.');
      }
    } catch (e) {
      // 실패 상태를 발생시킴
      return PostError('좋아요 처리에 실패했습니다.');
    }
  }


}
