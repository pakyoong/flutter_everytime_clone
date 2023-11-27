import '../../../bloc/clas_timetable_management_bloc.dart';
import 'package:everytime/component/custom_picker_modal_bottom_sheet.dart';
import 'package:everytime/screen_dimensions.dart';
import 'package:flutter/material.dart';

class PickerBottomPaddingAtGradeCalculatorPage extends StatelessWidget {
  const PickerBottomPaddingAtGradeCalculatorPage({
    Key? key,
    required this.gradeCalculatorBloc,
  }) : super(key: key);

  final GradeManagementBloc gradeCalculatorBloc;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: gradeCalculatorBloc.showingGradeSelector,
      builder: (isShowingSelecteGradeContext, isShowingSelectGradeSnapshot) {
        if (isShowingSelectGradeSnapshot.hasData) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: isShowingSelectGradeSnapshot.data!
                ? CustomPickerModalBottomSheet.sheetHeight - bottomPadding
                : 0,
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
