// import 'package:everytime/ui/pages/board/freeboarddetail.dart';
// import 'package:everytime/ui/pages/board/freeboardwrite.dart';
// import 'package:flutter/material.dart';
//
// class freeBoard extends StatefulWidget {
//   const freeBoard({super.key});
//
//   @override
//   State<freeBoard> createState() => _freeBoard();
// }
//
// class _freeBoard extends State<freeBoard> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: const Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text('자유게시판',
//                   style: TextStyle(
//                       fontSize: 15,
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold)),
//               SizedBox(
//                 height: 3,
//               ),
//               Text('금오공대', style: TextStyle(fontSize: 12, color: Colors.grey))
//             ]),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.search, size: 20),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => const freeBoardWrite()),
//               );
//             },
//           ),
//           PopupMenuButton<int>(
//             icon: const Icon(Icons.more_vert, size: 20),
//             onSelected: (int item) async {
//               if (item == 1) {
//                 // 새로 고침 기능 추가
//               }
//               if (item == 2) {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const freeBoardWrite()),
//                 );
//               }
//               if (item == 3) {
//                 // 즐겨찾기 기능 추가
//               }
//             },
//             itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
//               const PopupMenuItem<int>(
//                 value: 1,
//                 child: Text("새로고침"),
//               ),
//               const PopupMenuItem<int>(
//                 value: 2,
//                 child: Text("글 쓰기"),
//               ),
//               const PopupMenuItem<int>(
//                 value: 3,
//                 child: Text("즐겨찾기"),
//               ),
//             ],
//           ),
//           const SizedBox(
//             width: 10,
//             height: 10,
//           ),
//         ],
//       ),
//       body: Stack(
//           children: [
//             const Detail(),
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: Padding(
//                 padding: const EdgeInsets.only(bottom: 15.0),
//                 child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       side: const BorderSide(
//                           width: 1, // the thickness
//                           color: Colors.grey // the color of the border
//                           ),
//                       backgroundColor: Colors.white,
//                       minimumSize: const Size(80, 50),
//                       elevation: 0,
//                       maximumSize: const Size(110, 50),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                     ),
//                     child: const Row(
//                       children: [
//                         Icon(Icons.edit, size: 20, color: Colors.red),
//                         Text(
//                           '  글 쓰기',
//                           style: TextStyle(
//                               fontSize: 13,
//                               color: Colors.black,
//                               fontWeight: FontWeight.bold),
//                         ),
//                       ],
//                     ),
//                     onPressed: () {
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: ((context) => const freeBoardWrite())));
//                     }),
//               ),
//             )
//           ],
//         ),
//     );
//   }
// }
//
//
// const title = [
//   "기이이이이인아속보12345이ㅗㄴㅁ옿ㄴㅁ오ㅓㅁㄴㅇㅁㅇ넘ㅇ넘ㄴ엄ㄴ어ㅏ",
//   "속보2",
//   "기이이이이인 속보1234",
//   "기이이이이인 속보기이이이이인 속보아ㅇㄴㄴㅁㅇㅇㄴㅁ",
//   "속보1",
//   "속보2",
//   "속보3",
//   "기이이이이인 속보",
//   "기이이이이인아속보12345이ㅗㄴㅁ옿ㄴㅁ오ㅓㅁㄴㅇㅁㅇ넘ㅇ넘ㄴ엄ㄴ어ㅏ",
//   "속보2",
//   "기이이이이인 속보1234",
//   "기이이이이인 속보기이이이이인 속보아ㅇㄴㄴㅁㅇㅇㄴㅁ",
//   "속보1",
//   "속보2",
//   "속보3",
//   "기이이이이인 속보",
// ];
// const text = [
//   "유익한 정보1",
//   "유익한 정보2",
//   "유익한 정보3ㅁ옿ㅁㄴ온몬ㅁ온너ㅗㅎㅇㄴㅁㄹ욪뎌ㅓ점ㄴㅇㅎㅂㅈ",
//   "기이이인 정보",
//   "유익한 정보1",
//   "유익한 정보2",
//   "유익한 정보3",
//   "기이이인 정보",
//   "유익한 정보1",
//   "유익한 정보2",
//   "유익한 정보3ㅁ옿ㅁㄴ온몬ㅁ온너ㅗㅎㅇㄴㅁㄹ욪뎌ㅓ점ㄴㅇㅎㅂㅈ",
//   "기이이인 정보",
//   "유익한 정보1",
//   "유익한 정보2",
//   "유익한 정보3",
//   "기이이인 정보",
// ];
// const date = [
//   "01/02",
//   "01/02",
//   "01/02",
//   "01/02",
//   "01/02",
//   "01/02",
//   "01/02",
//   "01/02",
//   "01/02",
//   "01/02",
//   "01/02",
//   "01/02",
//   "01/02",
//   "01/02",
//   "01/02",
//   "01/02",
// ];
// const name = [
//   "익명",
//   "익명",
//   "익명",
//   "익명",
//   "익명",
//   "익명",
//   "익명",
//   "익명",
//   "익명",
//   "익명",
//   "익명",
//   "익명",
//   "익명",
//   "익명",
//   "익명",
//   "익명",
// ];
// const picture = [
//   null,
//   null,
//   null,
//   null,
//   null,
//   null,
//   null,
//   null,
//   null,
//   null,
//   null,
//   null,
//   null,
//   null,
//   null,
//   null,
// ];
// const comment = [
//   "4",
//   "2",
//   "1",
//   "2",
//   "4",
//   "2",
//   "1",
//   "2",
//   "4",
//   "2",
//   "1",
//   "2",
//   "4",
//   "2",
//   "1",
//   "2",
// ];
// const good = [
//   "3",
//   "2",
//   "1",
//   "4",
//   "3",
//   "2",
//   "1",
//   "4",
//   "3",
//   "2",
//   "1",
//   "4",
//   "3",
//   "2",
//   "1",
//   "4",
// ];
// const image_index = [
//   "1",
//   "0",
//   "1",
//   "0",
//   "1",
//   "0",
//   "1",
//   "0",
//   "1",
//   "0",
//   "1",
//   "0",
//   "1",
//   "0",
//   "1",
//   "0",
// ];
//
// class Detail extends StatelessWidget {
//   const Detail({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: title.length,
//       itemBuilder: (BuildContext context, index) {
//         return InkWell(
//           onTap: () {
//             Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: ((context) => const freeBoardDetail())));
//           },
//           child: Container(
//             padding: const EdgeInsets.only(left: 15, right: 15),
//             height: 60,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Expanded(
//                   child: SizedBox(
//                     width: double.infinity,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           title[index],
//                           overflow: TextOverflow.ellipsis,
//                           style: const TextStyle(
//                               fontSize: 16, color: Colors.black),
//                         ),
//                         const SizedBox(
//                           height: 5,
//                         ),
//                         Text(
//                           text[index],
//                           overflow: TextOverflow.ellipsis,
//                           style:
//                               const TextStyle(fontSize: 12, color: Colors.grey),
//                         ),
//                         const SizedBox(
//                           height: 5,
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           children: [
//                             Row(children: [
//                               Text(
//                                 date[index],
//                                 style: const TextStyle(
//                                     fontSize: 12, color: Colors.grey),
//                               ),
//                               const Text(
//                                 ' | ',
//                                 style:
//                                     TextStyle(fontSize: 12, color: Colors.grey),
//                               ),
//                               Text(
//                                 name[index],
//                                 style: const TextStyle(
//                                     fontSize: 12, color: Colors.grey),
//                               ),
//                             ]),
//                             Row(
//                               children: [
//                                 // if (picture[index] != null)
//                                 //   const Icon(Icons.photo, size: 12),
//                                 // if (picture[index] != null)
//                                 //   const Text(
//                                 //     "  ",
//                                 //     style: TextStyle(fontSize: 12),
//                                 //   ),
//                                 // if (picture[index] != null)
//                                 //   Text(
//                                 //     image_index[index],
//                                 //     style: const TextStyle(
//                                 //         fontSize: 12, color: Colors.grey),
//                                 //   ),
//                                 const Text(
//                                   "  ",
//                                   style: TextStyle(fontSize: 12),
//                                 ),
//                                 const Icon(Icons.thumb_up_outlined,
//                                     size: 12, color: Colors.red),
//                                 const Text(
//                                   " ",
//                                   style: TextStyle(fontSize: 12),
//                                 ),
//                                 Text(comment[index],
//                                     style: const TextStyle(
//                                         fontSize: 12, color: Colors.red)),
//                                 const Text(
//                                   "  ",
//                                   style: TextStyle(fontSize: 12),
//                                 ),
//                                 const Icon(Icons.messenger_outline,
//                                     size: 12, color: Colors.cyan),
//                                 const Text(
//                                   " ",
//                                   style: TextStyle(fontSize: 12),
//                                 ),
//                                 Text(comment[index],
//                                     style: const TextStyle(
//                                         fontSize: 12, color: Colors.cyan)),
//                                 const Text(
//                                   "    ",
//                                   style: TextStyle(fontSize: 12),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//                 // if (picture[index] != null)
//                 //   ClipRRect(
//                 //     borderRadius: BorderRadius.circular(10.0),
//                 //     child: Image.asset(picture[index]!),
//                 //   )
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
import 'package:everytime/ui//board_page/freeBoardDetail.dart';
import 'package:everytime/ui/board_page/freeBoardWrite.dart';
import 'package:flutter/material.dart';
//import 'package:everytime/model/Post.dart';

//db로 대체해야함.
const title = [
  "기이",
  "속보2",
  "기이",
  "기이",
  "속보1",
  "속보2",
  "속보3",
  "속보",
  "어ㅏ",
  "속보2",
  "이인",
  "보기",
  "속보1",
  "속보2",
  "속보3",
  "속보",
];
const text = [
  "유익한 정보1",
  "유익한 정보2",
  "유익한 정보3",
  "기이이인 정보",
  "유익한 정보1",
  "유익한 정보2",
  "유익한 정보3",
  "기이이인 정보",
  "유익한 정보1",
  "유익한 정보2",
  "유익한 정보3",
  "기이이인 정보",
  "유익한 정보1",
  "유익한 정보2",
  "유익한 정보3",
  "기이이인 정보",
];
const date = [
  "01/02",
  "01/02",
  "01/02",
  "01/02",
  "01/02",
  "01/02",
  "01/02",
  "01/02",
  "01/02",
  "01/02",
  "01/02",
  "01/02",
  "01/02",
  "01/02",
  "01/02",
  "01/02",
];
const name = [
  "익명",
  "익명",
  "익명",
  "익명",
  "익명",
  "익명",
  "익명",
  "익명",
  "익명",
  "익명",
  "익명",
  "익명",
  "익명",
  "익명",
  "익명",
  "익명",
];
const picture = [
  null,
  null,
  null,
  null,
  null,
  null,
  null,
  null,
  null,
  null,
  null,
  null,
  null,
  null,
  null,
  null,
];
const comment = [
  "4",
  "2",
  "1",
  "2",
  "4",
  "2",
  "1",
  "2",
  "4",
  "2",
  "1",
  "2",
  "4",
  "2",
  "1",
  "2",
];
const good = [
  "3",
  "2",
  "1",
  "4",
  "3",
  "2",
  "1",
  "4",
  "3",
  "2",
  "1",
  "4",
  "3",
  "2",
  "1",
  "4",
];
const image_index = [
  "1",
  "0",
  "1",
  "0",
  "1",
  "0",
  "1",
  "0",
  "1",
  "0",
  "1",
  "0",
  "1",
  "0",
  "1",
  "0",
];

class freeBoard extends StatefulWidget {
  const freeBoard({Key? key});

  @override
  State<freeBoard> createState() => _freeBoardState();
}

class _freeBoardState extends State<freeBoard> {
  @override
   Widget build(BuildContext context) {
  //   Post post1 = Post("제목", "내용", "시간", "닉네임", "null", 2, 1, 1);
  //   Post post2 = Post.clone(post1);
  //   Post post3 = Post.clone(post1);
  //   Post post4 = Post.clone(post1);
  //   Post post5 = Post.clone(post1);
  //   Post post6 = Post.clone(post1);
  //   Post post7 = Post.clone(post1);
  //   Post post8 = Post.clone(post1);
  //   Post post9 = Post.clone(post1);
  //   Post post10 = Post.clone(post1);

  //   List<Post> postSet = [
  //     post1,
  //     post2,
  //     post3,
  //     post4,
  //     post5,
  //     post6,
  //     post7,
  //     post8,
  //     post9,
  //     post10,
  //   ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('자유게시판',
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.bold)),
            SizedBox(
              height: 3,
            ),
            Text('금오공대', style: TextStyle(fontSize: 12, color: Colors.grey))
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, size: 20),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const freeBoard()),//검색 기능 일단 없음
              );
            },
          ),
          PopupMenuButton<int>(
            icon: const Icon(Icons.more_vert, size: 20),
            onSelected: (int item) async {
              if (item == 1) {
                // 새로 고침 기능 이거 아닌거 같음 새로 고칠것
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const freeBoard()),
                );
              } else if (item == 2) {
                //글쓰기 기능
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const freeBoardWrite()),
                );
              } else if (item == 3) {
                // 즐겨찾기 기능 보류
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
              const PopupMenuItem<int>(
                value: 1,
                child: Text("새로고침"),
              ),
              const PopupMenuItem<int>(
                value: 2,
                child: Text("글 쓰기"),
              ),
              const PopupMenuItem<int>(
                value: 3,
                child: Text("즐겨찾기"),
              ),
            ],
          ),
          const SizedBox(
            width: 10,
            height: 10,
          ),
        ],
      ),
      body: const Detail(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 15.0),
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const freeBoardWrite()),
            );
          },
          label: const Text(
            '글 쓰기',
            style: TextStyle(
              fontSize: 13,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          icon: const Icon(Icons.edit, size: 20, color: Colors.red),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: const BorderSide(
              width: 1,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}

class Detail extends StatelessWidget {
  const Detail({Key? key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemExtent: 80,
      itemCount: title.length,
      itemBuilder: (BuildContext context, index) {
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const freeBoardDetail(),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title[index],
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          text[index],
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Text(
                                  date[index],
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                const Text(
                                  ' | ',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  name[index],
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Text(
                                  "  ",
                                  style: TextStyle(fontSize: 12),
                                ),
                                const Icon(
                                  Icons.thumb_up_outlined,
                                  size: 12,
                                  color: Colors.red,
                                ),
                                const Text(
                                  " ",
                                  style: TextStyle(fontSize: 12),
                                ),
                                Text(
                                  good[index].toString(),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.red,
                                  ),
                                ),
                                const Text(
                                  "  ",
                                  style: TextStyle(fontSize: 12),
                                ),
                                const Icon(
                                  Icons.messenger_outline,
                                  size: 12,
                                  color: Colors.cyan,
                                ),
                                const Text(
                                  " ",
                                  style: TextStyle(fontSize: 12),
                                ),
                                Text(
                                  comment[index].toString(),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.cyan,
                                  ),
                                ),
                                const Text(
                                  "    ",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
