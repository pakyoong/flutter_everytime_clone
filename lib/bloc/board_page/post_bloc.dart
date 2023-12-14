import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;

abstract class PostEvent {}

class PostWrittenEvent extends PostEvent {
  final String title;
  final String content;

  PostWrittenEvent(this.title, this.content);
}

abstract class PostState {}

class PostInitial extends PostState {}

class PostSuccess extends PostState {}

class PostError extends PostState {
  final String errorMessage;

  PostError(this.errorMessage);
}

class PostBloc {
  String _title = "";
  String _content = "";
  bool _isAnonymous = false;
  final int _postNo = 0;

  String get title => _title;
  String get content => _content;
  bool get isAnonymous => _isAnonymous;
  int get postNo => _postNo;

  void updateTitle(String title) {
    _title = title;
  }

  void updateContent(String content) {
    _content = content;
  }

  void updateIsAnonymous(bool isAnonymous) {
    _isAnonymous = isAnonymous;
  }

  //게시글 등록
  Future<PostState> submitPost(String boardId) async {
    try {
      String formattedDate =
          DateFormat('MM/dd').format(DateTime.now().toLocal());
      String formattedTime =
          DateFormat('HH:mm').format(DateTime.now().toLocal());
      User? user = FirebaseAuth.instance.currentUser;

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .get();

      if (!userDoc.exists) {
        return PostError('사용자 정보를 찾을 수 없습니다.');
      }
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

      int currentPostNo = await _getCurrentPostNo(boardId);

      DocumentReference postRef = await FirebaseFirestore.instance
          .collection('Board')
          .doc(boardId)
          .collection('Post')
          .add({
        'postNo': currentPostNo + 1,
        'title': _title,
        'content': _content,
        'date': formattedDate,
        'time': formattedTime,
        'writer': userData['nickname'],
        'isAnonymous': _isAnonymous,
        'like': 0,
        'writerid': userData['email'],
        'picture': null
      });

      String postId = postRef.id;
      String userId = user?.uid ?? '';
      FirebaseFirestore.instance.collection('user_alarms').doc(userId).set({
        'postIds': FieldValue.arrayUnion([postId])
      }, SetOptions(merge: true));

      return PostSuccess();
    } catch (e) {
      return PostError('게시글 작성에 실패했습니다.');
    }
  }

  Future<PostState> submitPostWithImage(String boardId, File image) async {
    try {
      String imageName = path.basename(image.path);
      Reference storageReference =
          FirebaseStorage.instance.ref().child("images/$boardId/$imageName");
      UploadTask uploadTask = storageReference.putFile(image);
      TaskSnapshot snapshot = await uploadTask;

      String imageUrl = await snapshot.ref.getDownloadURL();

      PostState result = await _submitPostWithImage(boardId, imageUrl);

      return result;
    } catch (e) {
      print("Firebase Storage 업로드 오류: $e");
      return PostError('게시글 작성에 실패했습니다.');
    }
  }

  Future<PostState> _submitPostWithImage(
      String boardId, String imageUrl) async {
    try {
      String formattedDate =
          DateFormat('MM/dd').format(DateTime.now().toLocal());
      String formattedTime =
          DateFormat('HH:mm').format(DateTime.now().toLocal());
      User? user = FirebaseAuth.instance.currentUser;

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .get();

      if (!userDoc.exists) {
        return PostError('사용자 정보를 찾을 수 없습니다.');
      }
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

      int currentPostNo = await _getCurrentPostNo(boardId);

      await FirebaseFirestore.instance
          .collection('Board')
          .doc(boardId)
          .collection('Post')
          .add({
        'postNo': currentPostNo + 1,
        'title': _title,
        'content': _content,
        'date': formattedDate,
        'time': formattedTime,
        'writer': userData['nickname'],
        'isAnonymous': _isAnonymous,
        'like': 0,
        'writerid': userData['email'],
        'picture': imageUrl,
      });

      return PostSuccess();
    } catch (e) {
      return PostError('게시글 작성에 실패했습니다.');
    }
  }

  Future<int> _getCurrentPostNo(String boardId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('Board')
          .doc(boardId)
          .collection('Post')
          .orderBy('postNo', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs[0]['postNo'];
      } else {
        return 0;
      }
    } catch (e) {
      return 0;
    }
  }

  //게시글 삭제
  Future<PostState> deletePost(String boardId, String postId) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .get();

      if (!userDoc.exists) {
        return PostError('사용자 정보를 찾을 수 없습니다.');
      }

      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

      DocumentSnapshot postSnapshot = await FirebaseFirestore.instance
          .collection('Board')
          .doc(boardId)
          .collection('Post')
          .doc(postId)
          .get();

      if (!postSnapshot.exists) {
        return PostError('게시글이 존재하지 않습니다.');
      }

      String writerId = postSnapshot['writerid'];
      String userEmail = userData['email'];

      if (userEmail == writerId) {
        await FirebaseFirestore.instance
            .collection('Board')
            .doc(boardId)
            .collection('Post')
            .doc(postId)
            .delete();

        if (postSnapshot['picture'] != null) {
          await _deleteImage(postSnapshot['picture']);
        }

        return PostSuccess();
      } else {
        return PostError('게시글 삭제 권한이 없습니다.');
      }
    } catch (e) {
      return PostError('게시글 삭제에 실패했습니다.');
    }
  }

  Future<void> _deleteImage(String imageUrl) async {
    try {
      Reference storageReference =
          FirebaseStorage.instance.refFromURL(imageUrl);
      await storageReference.delete();
    } catch (e) {
      print("이미지 삭제 오류: $e");
    }
  }

  //게시글 공감
  Future<PostState> postLike(String boardId, String postId) async {
    try {
      var postDoc = await FirebaseFirestore.instance
          .collection('Board')
          .doc(boardId)
          .collection('Post')
          .doc(postId)
          .get();

      if (postDoc.exists) {
        int currentLikes = postDoc['like'] ?? 0;
        currentLikes++;
        await FirebaseFirestore.instance
            .collection('Board')
            .doc(boardId)
            .collection('Post')
            .doc(postId)
            .update({'like': currentLikes});
        return PostSuccess();
      } else {
        return PostError('게시글이 존재하지 않습니다.');
      }
    } catch (e) {
      return PostError('좋아요 처리에 실패했습니다.');
    }
  }
}
