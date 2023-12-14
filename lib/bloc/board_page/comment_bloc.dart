// ignore_for_file: unnecessary_null_comparison

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

abstract class CommentState {}

class CommentInitial extends CommentState {}

class CommentSuccess extends CommentState {}

class CommentError extends CommentState {
  final String errorMessage;

  CommentError(this.errorMessage);
}

class CommentBloc {
  String _comment = "";
  bool _isAnonymous = false;
  bool _isRecomment = false;
  final int _commentNo = 0;

  String get comment => _comment;
  bool get isAnonymous => _isAnonymous;
  bool get isRecomment => _isRecomment;
  int get commentNo => _commentNo;

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
      String formattedDate = DateFormat('MM/dd').format(DateTime.now().toLocal());
      String formattedTime = DateFormat('HH:mm').format(DateTime.now().toLocal());

      User? user = FirebaseAuth.instance.currentUser;
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .get();

      if (!userDoc.exists) {
        return CommentError('사용자 정보를 찾을 수 없습니다.');
      }
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

      int currentCommentNo = await _getCurrentCommentNo(boardId, postId);

      DocumentReference commentRef = await FirebaseFirestore.instance
          .collection('Board')
          .doc(boardId)
          .collection('Post')
          .doc(postId)
          .collection('Comment')
          .add({
        'commentNo': currentCommentNo + 1,
        'comment': _comment,
        'date': formattedDate,
        'isAnonymous': _isAnonymous,
        'isRecomment': _isRecomment,
        'like': 0,
        'time': formattedTime,
        'writer': userData['nickname'],
        'writerid': userData['email']
      });

      // 게시글 작성자에게 알림 추가
      DocumentSnapshot postDoc = await FirebaseFirestore.instance
          .collection('Board')
          .doc(boardId)
          .collection('Post')
          .doc(postId)
          .get();

      if (postDoc.exists) {
        Map<String, dynamic> postData = postDoc.data() as Map<String, dynamic>; // 캐스팅 추가
        String postWriterId = postData['writerid'];

        if (postWriterId != null && postWriterId != user?.uid) { // 자신의 글에는 알림을 보내지 않음
          FirebaseFirestore.instance.collection('user_alarms').doc(postWriterId)
              .set({'commentIds': FieldValue.arrayUnion([commentRef.id])}, SetOptions(merge: true));
        }
      }

      return CommentSuccess();
    } catch (e) {
      return CommentError('댓글 작성에 실패했습니다.');
    }
  }

  Future<int> _getCurrentCommentNo(String boardId, String postId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance
              .collection('Board')
              .doc(boardId)
              .collection('Post')
              .doc(postId)
              .collection('Comment')
              .orderBy('commentNo', descending: true)
              .limit(1)
              .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs[0]['commentNo'];
      } else {
        return 0;
      }
    } catch (e) {
      return 0;
    }
  }

  Future<CommentState> likeComment(
      String boardId, String postId, String commentId) async {
    try {
      var commentDoc = await FirebaseFirestore.instance
          .collection('Board')
          .doc(boardId)
          .collection('Post')
          .doc(postId)
          .collection('Comment')
          .doc(commentId)
          .get();

      if (commentDoc.exists) {
        int currentLikes = commentDoc['like'] ?? 0;
        currentLikes++;

        await FirebaseFirestore.instance
            .collection('Board')
            .doc(boardId)
            .collection('Post')
            .doc(postId)
            .collection('Comment')
            .doc(commentId)
            .update({'like': currentLikes});

        return CommentSuccess();
      } else {
        return CommentError('댓글이 존재하지 않습니다.');
      }
    } catch (e) {
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
        String userEmail = userData['email'];
        if (userEmail == writerId) {
          await FirebaseFirestore.instance
              .collection('Board')
              .doc(boardId)
              .collection('Post')
              .doc(postId)
              .collection('Comment')
              .doc(commentId)
              .delete();
          return CommentSuccess();
        } else {
          return CommentError('댓글 삭제 권한이 없습니다.');
        }
      } else {
        return CommentError('댓글이 존재하지 않습니다.');
      }
    } catch (e) {
      return CommentError('댓글 삭제에 실패했습니다.');
    }
  }
}
