import 'package:everytime/bloc/user_profile_management_bloc.dart';
import 'package:everytime/bloc/grade_management_bloc.dart';
import 'package:everytime/global_variable.dart';
import 'package:flutter/material.dart';

class SummeryOfTermAtGradeCalculatorPage extends StatelessWidget {
  const SummeryOfTermAtGradeCalculatorPage({
    super.key,
    required this.userBloc,
    required this.gradeCalculatorBloc,
  });

  final UserProfileManagementBloc userBloc;
  final GradeManagementBloc gradeCalculatorBloc;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: appHeight * 0.11,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildSummaryColumn(context),
          //TODO: 시간표 불러오기 기능 만들기
          Container(
            margin: EdgeInsets.only(
              right: appWidth * 0.05,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryColumn(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: appHeight * 0.025,
        left: appWidth * 0.05,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTermStreamBuilder(),
          SizedBox(
            height: appHeight * 0.0075,
          ),
          _buildGradeRow(context),
        ],
      ),
    );
  }

  Widget _buildTermStreamBuilder() {
    return StreamBuilder(
      stream: gradeCalculatorBloc.selectedTerm,
      builder: (streamBuilderContext, snapshot) {
        if (snapshot.hasData) {
          return Text(
            userBloc.getTerm(snapshot.data!).term,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 26,
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildGradeRow(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          '평점',
          style: TextStyle(
            fontSize: 14,
          ),
        ),
        _buildCreditStreamBuilder(context, "totalGradeAve"),
        const Text(
          '전공',
          style: TextStyle(
            fontSize: 14,
          ),
        ),
        _buildCreditStreamBuilder(context, "majorGradeAve"),
        const Text(
          '취득',
          style: TextStyle(
            fontSize: 14,
          ),
        ),
        _buildCreditStreamBuilder(context, "creditAmount"),
      ],
    );
  }

  Widget _buildCreditStreamBuilder(BuildContext context, String type) {
    return StreamBuilder(
      stream: gradeCalculatorBloc.selectedTerm,
      builder: (currentTermIndexContext, currentTermIndexSnapshot) {
        if (currentTermIndexSnapshot.hasData) {
          Stream<num> stream;
          switch (type) {
            case "totalGradeAve":
              stream = userBloc.getTotalGradeAve(currentTermIndexSnapshot.data!);
              break;
            case "majorGradeAve":
              stream = userBloc.getMajorGradeAve(currentTermIndexSnapshot.data!);
              break;
            case "creditAmount":
              stream = userBloc.getCreditAmount(currentTermIndexSnapshot.data!);
              break;
            default:
              stream = Stream.empty();
          }
          return StreamBuilder<num>(
            stream: stream,
            builder: (valueContext, valueSnapshot) {
              if (valueSnapshot.hasData) {
                return Container(
                  padding: const EdgeInsets.only(bottom: 2),
                  margin: EdgeInsets.only(
                    left: appWidth * 0.005,
                    right: appWidth * 0.02,
                  ),
                  child: Text(
                    '${valueSnapshot.data}',
                    style: TextStyle(
                      color: Theme.of(context).focusColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
