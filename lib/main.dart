import 'package:flutter/material.dart';
import 'bloc/navigation_bloc.dart';
import 'ui/pages/alarm_page.dart';
import 'ui/pages/board_page.dart';
import 'ui/pages/campus_page.dart';
import 'ui/pages/main_page.dart';
import 'ui/pages/my_info_page.dart';
import 'ui/pages/time_table_page.dart';

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
  final List<Widget> _pages = [
    const MainPage(),
    const TimeTablePage(),
    const CampusPickPage(),
    const AlarmPage(),
    const MyInfoPage(),
  ];

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
    _navigationBloc.dispose();
    super.dispose();
  }
}