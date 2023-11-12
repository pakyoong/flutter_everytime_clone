import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import '../../component/dynamic_app_bar.dart';
import '../../component/scroll_responsive_app_bar.dart';
import '../../component/app_bar_button.dart';
import '../../screen_dimensions.dart'; // screen_dimensions.dart 파일의 경로를 확인하세요.

class TimeTable extends StatefulWidget {
  const TimeTable({Key? key, required this.scrollController}) : super(key: key);
  final ScrollController scrollController;

  @override
  State<TimeTable> createState() => _TimeTableState();
}

class _TimeTableState extends State<TimeTable> with AutomaticKeepAliveClientMixin {
  final BehaviorSubject<double> _scrollOffset = BehaviorSubject.seeded(0);

  List<Widget> get _actions => [
    AppBarButton(
      icon: Icons.add,
      onPressed: () => log('Add button pressed'),
    ),
    AppBarButton(
      icon: Icons.settings,
      onPressed: () => log('Settings button pressed'),
    ),
    AppBarButton(
      icon: Icons.list,
      onPressed: () => log('List button pressed'),
    ),
  ];

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(() {
      _scrollOffset.sink.add(widget.scrollController.offset);
    });
  }

  @override
  void dispose() {
    _scrollOffset.close();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            ScrollResponsiveAppBar(
              scrollOffsetStream: _scrollOffset.stream,
              title: '2023년 2학기',
            ),
            DynamicAppBar(
              title: '시간표',
              actions: _actions, // 수정된 부분
            ),
            Expanded(
              child: CustomScrollView(
                controller: widget.scrollController,
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: List.generate(
                        200,
                            (index) => SizedBox(
                          height: 100,
                          width: availableWidth,
                          child: Center(child: Text('$index')),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
