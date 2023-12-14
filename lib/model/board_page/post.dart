import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:everytime/model/board_page/comment.dart';

class Post {
  final String postId;
  final int postNo;
  final String content;
  final String date;
  final String time;
  final bool isAnonymous;
  int like;
  final String? picture;
  final String title;
  final String writer;
  final String writerid;
  List<Comment> comments;

  Post({
    required this.postId,
    required this.postNo,
    required this.content,
    required this.date,
    required this.time,
    required this.isAnonymous,
    required this.like,
    required this.picture,
    required this.title,
    required this.writer,
    required this.writerid,
    required this.comments,
  });

  factory Post.fromFirestore(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Post._(
      postId: doc.id,
      postNo: data['postNo'] ?? 0, 
      content: data['content'] ?? '',
      date: data['date'] ?? '',
      time: data['time'] ?? '',
      isAnonymous: data['isAnonymous'] ?? false,
      like: data['like'] ?? 0,
      picture: data['picture'],
      title: data['title'] ?? '',
      writer: data['writer'] ?? '',
      writerid: data['writerid'] ?? '',
      comments: [],
    );
  }

  static Future<Post> fromFirestoreWithComments(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) async {
    final data = doc.data() as Map<String, dynamic>;

    final comments = await Comment.fetchComments(doc.reference);

    return Post._(
      postId: doc.id,
      postNo: data['postNo'] ?? 0,
      content: data['content'] ?? '',
      date: data['date'] ?? '',
      time: data['time'] ?? '',
      isAnonymous: data['isAnonymous'] ?? false,
      like: data['like'] ?? 0,
      picture: data['picture'],
      title: data['title'] ?? '',
      writer: data['writer'] ?? '',
      writerid: data['writerid'] ?? '',
      comments: comments,
    );
  }

  Post._({
    required this.postId,
    required this.postNo,
    required this.content,
    required this.date,
    required this.time,
    required this.isAnonymous,
    required this.like,
    required this.picture,
    required this.title,
    required this.writer,
    required this.writerid,
    required this.comments,
  });
}
