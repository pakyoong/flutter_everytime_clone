import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

abstract class CommentEvent {}

class CommentWrittenEvent extends CommentEvent {
  final String commen;

  CommentWrittenEvent(this.commen);
}

class CommentLikeEvent extends CommentEvent {
  final String commentId;

  CommentLikeEvent(this.commentId);
}

class CommentDeleteEvent extends CommentEvent {
  final String commentId;

  CommentDeleteEvent(this.commentId);
}

// 상태 정의
abstract class CommentState {}

class CommentInitial extends CommentState {}

class CommentSuccess extends CommentState {}

class CommentError extends CommentState {
  final String errorMessage;

  CommentError(this.errorMessage);
}

// BLoC 클래스 정의
class CommentBloc {
  String _comment = "";
  bool _isAnonymous = false;
  bool _isRecomment = false;

  String get comment => _comment;
  bool get isAnonymous => _isAnonymous;
  bool get isRecomment => _isRecomment;

  // 내용 업데이트
  void updateComment(String comment) {
    _comment = comment;
  }

  void updateIsAnonymous(bool isAnonymous) {
    _isAnonymous = isAnonymous;
  }

  void updateisRecomment(bool isRecomment) {
    _isRecomment = isRecomment;
  }

  Future<CommentState> writeComment(String boardId, String postId) async {
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
        return CommentError('사용자 정보를 찾을 수 없습니다.');
      }
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

      // Firestore에 댓글 추가
      await FirebaseFirestore.instance
          .collection('Board')
          .doc(boardId)
          .collection('Post')
          .doc(postId)
          .collection('Comment')
          .add({
        'comment': _comment,
        'date': formattedDate,
        'isAnonymous': _isAnonymous,
        'isRecomment': _isRecomment,
        'like': 0,
        'time': formattedTime,
        'writer': userData['nickname'],
        'writerid': userData['email']
      });

      // 성공 상태를 발생시킴
      return CommentSuccess();
    } catch (e) {
      // 실패 상태를 발생시킴
      return CommentError('댓글 작성에 실패했습니다.');
    }
  }

  Future<CommentState> likeComment(
      String boardId, String postId, String commentId) async {
    try {
      // Firestore에서 해당 댓글 가져오기
      var commentDoc = await FirebaseFirestore.instance
          .collection('Board')
          .doc(boardId)
          .collection('Post')
          .doc(postId)
          .collection('Comment')
          .doc(commentId)
          .get();

      // 댓글이 존재하는지 확인
      if (commentDoc.exists) {
        // 좋아요 수 증가
        int currentLikes = commentDoc['like'] ?? 0;

        // Firestore에 좋아요 수 업데이트 (FieldValue.increment 사용)
        await FirebaseFirestore.instance
            .collection('Board')
            .doc(boardId)
            .collection('Post')
            .doc(postId)
            .collection('Comment')
            .doc(commentId)
            .update({'like': FieldValue.increment(1)});

        // 성공 상태를 발생시킴
        return CommentSuccess();
      } else {
        // 댓글이 존재하지 않는 경우 실패 상태를 발생시킴
        return CommentError('댓글이 존재하지 않습니다.');
      }
    } catch (e) {
      // 실패 상태를 발생시킴
      return CommentError('좋아요 처리에 실패했습니다.');
    }
  }

  Future<CommentState> deleteComment(
      String boardId, String postId, String commentId) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .get();
      if (!userDoc.exists) {
        // 사용자 정보를 찾을 수 없는 경우 처리
        return CommentError('사용자 정보를 찾을 수 없습니다.');
      }
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      DocumentSnapshot commentSnapshot = await FirebaseFirestore.instance
          .collection('Board')
          .doc(boardId)
          .collection('Post')
          .doc(postId)
          .collection('Comment')
          .doc(commentId)
          .get();
      if (commentSnapshot.exists) {
        String writerId = commentSnapshot['writerid'];

        // 현재 사용자의 이메일 주소 가져오기
        String userEmail = userData['email'];
        if (userEmail == writerId) {
          // Firestore에서 댓글 삭제
          await FirebaseFirestore.instance
              .collection('Board')
              .doc(boardId)
              .collection('Post')
              .doc(postId)
              .collection('Comment')
              .doc(commentId)
              .delete();

          // 성공 상태를 발생시킴
          return CommentSuccess();
        } else {
          // 사용자가 작성자가 아닌 경우 권한이 없다는 오류 상태를 반환합니다.
          return CommentError('댓글 삭제 권한이 없습니다.');
        }
      } else {
        // 댓글이 존재하지 않는 경우 오류 상태를 반환합니다.
        return CommentError('댓글이 존재하지 않습니다.');
      }
    } catch (e) {
      // 삭제 중 오류가 발생한 경우 오류 상태를 반환합니다.
      return CommentError('댓글 삭제에 실패했습니다.');
    }
  }
}
