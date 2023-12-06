import 'package:everytime/bloc/user_profile_management_bloc.dart';
import 'package:everytime/global_variable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class KeyboardActionAtGradeCalculatorPage extends StatelessWidget {
  const KeyboardActionAtGradeCalculatorPage({
    super.key,
    required this.userBloc,
  });

  final UserProfileManagementBloc userBloc;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: userBloc.isShowingKeyboard,
      builder: (_, isShowingKeyboardSnapshot) {
        if (isShowingKeyboardSnapshot.hasData) {
          return Visibility(
            visible: isShowingKeyboardSnapshot.data!,
            child: Container(
              color: Theme.of(context).colorScheme.background,
              alignment: Alignment.centerRight,
              height: isShowingKeyboardSnapshot.data!
                  ? paddingBottom + appHeight * 0.015
                  : 0,
              child: CupertinoButton(
                child: const Text(
                  '완료',
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
                onPressed: () {
                  _hideKeyboardAction();
                  if (primaryFocus?.hasFocus ?? false) {
                    primaryFocus?.unfocus();
                  }
                },
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  void _hideKeyboardAction() {
    userBloc.updateIsShowingKeyboard(false);
  }
}
