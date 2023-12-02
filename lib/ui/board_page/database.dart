//firebase연결 후 삭제
import 'package:everytime/model/board_page/post.dart';
import 'package:everytime/model/board_page/comment.dart';

Post post1 = Post("제목", "내용", null, "닉네임1", "11/30", 2, true, commentSet1);
//Post post2 = Post("제목2", "내용2", "assets/img10.jpg","닉네임2", "11/20", 5, false,commentSet2);
Post post2 = Post("제목2", "내용2", null, "닉네임2", "11/20", 5, false, commentSet2);
Post post3 = Post("제목3", "내용3", "https://picsum.photos/200/300", "닉네임3",
    "11/10", 20, true, commentSet2);
Post post4 = Post("제목4", "내용4", "https://picsum.photos/200", "닉네임4", "11/11",
    10, false, commentSet1);
Post post5 = Post.clone(post1);
Post post6 = Post.clone(post1);
Post post7 = Post.clone(post1);
Post post8 = Post.clone(post1);
Post post9 = Post.clone(post1);
Post post10 = Post.clone(post1);

List<Post> postSet = [
  post1,
  post2,
  post3,
  post4,
  post5,
  post6,
  post7,
  post8,
  post9,
  post10,
];

Comment comment1 = Comment("닉네임", "댓글입니다.1", "11/30", "13:27", 2, true, false);
Comment comment2 =
    Comment("닉네임2", "댓글입니다.2", "12/01", "00:27", 2, false, false);
Comment comment3 = Comment("닉네임3", "댓글입니다.3", "12/01", "23:27", 2, true, true);
Comment comment4 = Comment.clone(comment1);
Comment comment5 = Comment.clone(comment2);
Comment comment6 = Comment.clone(comment3);

List<Comment> commentSet0 = [
];

List<Comment> commentSet1 = [
  comment1,
  comment2,
  comment3,
  comment4,
  comment5,
  comment6,
];

List<Comment> commentSet2 = [
  comment2,
  comment3,
];
