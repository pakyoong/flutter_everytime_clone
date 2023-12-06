import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String commentId;
  final String comment;
  final String date;
  final bool isAnonymous;
  final bool isRecomment;
  final int like;
  final String time;
  final String writer;
  final String writerid;


  Comment({
    required this.commentId,
    required this.comment,
    required this.date,
    required this.isAnonymous,
    required this.isRecomment,
    required this.like,
    required this.time,
    required this.writer,
    required this.writerid,
  });

  factory Comment.fromFirestore(
      QueryDocumentSnapshot<Map<String, dynamic>> commentDoc) {
    final data = commentDoc.data();
    return Comment(
      commentId: commentDoc.id,
      comment: data['comment'] ?? '',
      date: data['date'] ?? '',
      isAnonymous: data['isAnonymous'] ?? false,
      isRecomment: data['isRecomment'] ?? false,
      like: data['like'] ?? 0,
      time: data['time'] ?? '',
      writer: data['writer'] ?? '',
      writerid: data['writerid'] ?? '',
    );
  }
  static Future<List<Comment>> fetchComments(
      DocumentReference postReference) async {
    final commentsCollection = await postReference.collection('Comment').get();
    return commentsCollection.docs
        .map((commentDoc) => Comment.fromFirestore(commentDoc))
        .toList();
  }
}
