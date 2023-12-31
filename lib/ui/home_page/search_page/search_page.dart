import 'package:everytime/bloc/user_profile_management_bloc.dart';
import 'package:everytime/component/custom_appbar_with_text_field.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({
    Key? key,
    required this.userBloc,
  }) : super(key: key);

  final UserProfileManagementBloc userBloc;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            CustomAppBarWithTextField(
              userBloc: widget.userBloc,
            ),
          ],
        ),
      ),
    );
  }
}
