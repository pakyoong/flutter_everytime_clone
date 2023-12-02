import 'package:everytime/model/board_page/comment.dart';

class Post {
  String posttitle;
  String postcontent;
  String? postpicture;
  String postwriter;
  String postdate;
  int postlike;
  bool isanonymous;
  List<Comment> commentList;

  Post(
    this.posttitle,
    this.postcontent,
    this.postpicture,
    this.postwriter,
    this.postdate,
    this.postlike,
    this.isanonymous,
    this.commentList,
  );

  Post.clone(Post post)
      : this(
          post.posttitle,
          post.postcontent,
          post.postpicture,
          post.postwriter,
          post.postdate,
          post.postlike,
          post.isanonymous,
          List<Comment>.from(post.commentList)
        );
}