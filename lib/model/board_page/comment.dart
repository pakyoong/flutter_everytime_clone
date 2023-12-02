class Comment {
  String commentwriter;
  String commentcontents;
  String commentdate;
  String commenttime;
  int commentlike;
  bool isanonymous;
  bool isrecomment;

  Comment(
    this.commentwriter,
    this.commentcontents,
    this.commentdate,
    this.commenttime,
    this.commentlike,
    this.isanonymous,
    this.isrecomment,
  );

  Comment.clone(Comment comment)
      : this(
          comment.commentwriter,
          comment.commentcontents,
          comment.commentdate,
          comment.commenttime,
          comment.commentlike,
          comment.isanonymous,
          comment.isrecomment,
        );
}
