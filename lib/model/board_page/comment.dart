class Comment {
  String commentwriter;
  String commentcontents;
  String commentime;
  int commentlike;
  bool isanonymous;
  bool isrecomment;

  Comment(
    this.commentwriter,
    this.commentcontents,
    this.commentime,
    this.commentlike,
    this.isanonymous,
    this.isrecomment,
  );

  Comment.clone(Comment comment)
      : this(
          comment.commentwriter,
          comment.commentcontents,
          comment.commentime,
          comment.commentlike,
          comment.isanonymous,
          comment.isrecomment,
        );
}
