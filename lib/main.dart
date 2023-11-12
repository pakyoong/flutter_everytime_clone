import 'package:flutter/material.dart';
import 'bloc/navigation_bloc.dart';
import 'ui/pages/Alarm.dart';
import 'ui/pages/Board.dart';
import 'ui/pages/Campus.dart';
import 'ui/pages/Main.dart';
import 'ui/pages/MyInfo.dart';
import 'ui/pages/time_table.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Navigation Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final NavigationBloc _navigationBloc = NavigationBloc();
  late final ScrollController _timeTableScrollController = ScrollController();
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const MainPage(),
      TimeTable(scrollController: _timeTableScrollController), // 수정된 부분
      const Board(),
      const CampusPick(),
      const Alarm(),
      const MyInfo(),
    ];
  }

  final List<IconData> _bottomNavIcons = const [
    Icons.home_outlined,
    Icons.table_chart_outlined,
    Icons.dashboard_outlined,
    Icons.notifications_active_outlined,
    Icons.alternate_email_outlined,
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