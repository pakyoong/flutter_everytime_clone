import 'package:everytime/bloc/tab_navigation_bloc.dart';
import 'package:flutter/material.dart';

class CustomTabBarView extends StatelessWidget {
  const CustomTabBarView({
    Key? key,
    required this.tabs,
    required this.tabBarBloc,
  }) : super(key: key);

  final List<Widget> tabs;
  final TabNavigationBloc tabBarBloc;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder(
        stream: tabBarBloc.currentIndexStream,
        builder: (context, AsyncSnapshot<int> snapshot) {
          if (snapshot.hasData) {
            return IndexedStack(
              index: snapshot.data,
              children: tabs,
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
