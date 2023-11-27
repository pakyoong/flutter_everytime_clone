import 'package:flutter/material.dart';
import 'bloc/navigation_bloc.dart';
import 'ui/pages/alarm.dart';
import 'ui/pages/board.dart';
import 'ui/pages/campus.dart';
import 'ui/pages/main_page.dart';
import 'ui/pages/myInfo.dart';
import 'ui/pages/time_table.dart';
import 'bloc/user_profile_management_bloc.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Navigation Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final NavigationBloc _navigationBloc = NavigationBloc();
  late final ScrollController _timeTableScrollController = ScrollController();
  late final List<Widget> _pages;

  final _userBloc = EverytimeUserBloc();

  @override
  void initState() {
    super.initState();
    _pages = [
      const MainPage(),
      TimeTablePage(scrollController: _timeTableScrollController, userBloc: _userBloc, isOnScreen: false,), // 수정된 부분
      const Board(),
      const CampusPick(),
      const Alarm(),
      const MyInfo(),
    ];
  }

  final List<IconData> _bottomNavIcons = const [
    Icons.home_outlined,
    Icons.table_chart_outlined,
    Icons.article_outlined,
    Icons.notifications_active_outlined,
    Icons.person_outline,
  ];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: _navigationBloc.currentIndexStream,
      builder: (context, snapshot) {
        int currentIndex = snapshot.data ?? 0;
        return Scaffold(
          body: _pages[currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: _navigationBloc.onNavigationIconTapped,
            selectedItemColor: Colors.blue, // 선택된 아이템 색상
            unselectedItemColor: Colors.grey, // 선택되지 않은 아이템 색상
            items: _bottomNavIcons.map((iconData) => BottomNavigationBarItem(
              icon: Icon(iconData),
              label: '',
            )).toList(),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _timeTableScrollController.dispose(); // ScrollController를 정리
    _navigationBloc.dispose();
    super.dispose();
  }
}