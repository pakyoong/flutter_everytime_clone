class Post {
  String title;
  String contents;
  String writer;
  String time;
  int like;
  int comment;
  bool isanonymous;

  Post(
    this.title,
    this.contents,
    this.writer,
    this.time,
    this.like,
    this.comment,
    this.isanonymous,
  );

  Post.clone(Post post)
      : this(
          post.title,
          post.contents,
          post.writer,
          post.time,
          post.like,
          post.comment,
          post.isanonymous
        );
}