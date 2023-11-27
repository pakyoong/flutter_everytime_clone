import '../../../bloc/user_profile_management_bloc.dart';
import '../../../bloc/clas_timetable_management_bloc.dart';
import 'package:everytime/screen_dimensions.dart';
import 'package:flutter/material.dart';

class TermListAtGradeCalculatorPage extends StatelessWidget {
  const TermListAtGradeCalculatorPage({
    Key? key,
    required this.termScrollController,
    required this.gradeCalculatorBloc,
    required this.userBloc,
  }) : super(key: key);

  final ScrollController termScrollController;
  final GradeManagementBloc gradeCalculatorBloc;
  final EverytimeUserBloc userBloc;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: availableHeight * 0.065,
      child: StreamBuilder(
        stream: gradeCalculatorBloc.selectedTerm,
        builder: (streamContext, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              controller: termScrollController,
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(
                left: availableWidth * 0.04,
                right: availableWidth * 0.04,
              ),
              itemCount: userBloc.getTermsLength,
              itemBuilder: (listViewContext, index) => SizedBox(
                width: (userBloc.getTerm(index).termName.length == 7)
                    ? availableWidth * 0.205
                    : availableWidth * 0.165,
                child: MaterialButton(
                  padding: EdgeInsets.zero,
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        userBloc.getTerm(index).termName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: (snapshot.data! == index)
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      Container(
                        height: 2,
                        width: availableWidth *
                                0.0215 *
                                userBloc.getTerm(index).termName.length +
                            availableWidth * 0.02,
                        margin: EdgeInsets.only(top: availableHeight * 0.005),
                        color: (index == snapshot.data!)
                            ? Theme.of(context).highlightColor
                            : null,
                      ),
                    ],
                  ),
                  onPressed: () {
                    if (FocusScope.of(context).hasFocus) {
                      FocusScope.of(context).unfocus();
                      _hideKeyboardAction();
                    }

                    userBloc.getTerm(snapshot.data!).removeEmptySubjects();
                    gradeCalculatorBloc.updateSelectedTerm(index);

                    //TODO: 나중에 글자 수가 다른 학기가 추가된다면 수정해야 할 수도 있다.
                    if (termScrollController.position.maxScrollExtent <
                        availableWidth * 0.205 * index) {
                      termScrollController.jumpTo(
                          termScrollController.position.maxScrollExtent);
                    } else {
                      termScrollController.jumpTo(availableWidth * 0.205 * index);
                    }
                  },
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _hideKeyboardAction() {
    userBloc.updateIsShowingKeyboard(false);
  }
}
