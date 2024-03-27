import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:autism_mobile_app/utils/constant/days_of_week.dart';
import 'package:autism_mobile_app/presentation/widgets/loading.dart';
import 'package:autism_mobile_app/presentation/widgets/app_drawer.dart';
import 'package:autism_mobile_app/presentation/widgets/show_dialog.dart';
import 'package:autism_mobile_app/domain/models/task_models/internal_task.dart';
import 'package:autism_mobile_app/domain/models/account_models/child_account.dart';
import 'package:autism_mobile_app/domain/models/exercise_models/items_matching.dart';
import 'package:autism_mobile_app/domain/models/exercise_models/numbers_ordering.dart';
import 'package:autism_mobile_app/domain/models/task_models/internal_task_details.dart';
import 'package:autism_mobile_app/domain/models/exercise_models/numbers_comparing.dart';
import 'package:autism_mobile_app/domain/models/exercise_models/statements_composition.dart';
import 'package:autism_mobile_app/presentation/cubits/task_cubits/internal_task_cubits/cubit/internal_task_details_cubit.dart';
import 'package:autism_mobile_app/presentation/views/family_views/reports/center_home_tasks_report/internal_task_report/number_order_task.dart';
import 'package:autism_mobile_app/presentation/views/family_views/reports/center_home_tasks_report/internal_task_report/items_matching_task.dart';
import 'package:autism_mobile_app/presentation/views/family_views/reports/center_home_tasks_report/internal_task_report/number_compare_task.dart';
import 'package:autism_mobile_app/presentation/views/family_views/reports/center_home_tasks_report/internal_task_report/statement_composition_task.dart';

class InternalTaskDetailsScreen extends StatefulWidget {
  const InternalTaskDetailsScreen(
      {super.key, required this.internalTask, required this.taskPlace});

  final InternalTask internalTask;
  final String taskPlace;

  @override
  State<InternalTaskDetailsScreen> createState() =>
      _InternalTaskDetailsScreenState();
}

class _InternalTaskDetailsScreenState extends State<InternalTaskDetailsScreen> {
  bool _isInit = true;
  final ScrollController _scrollController = ScrollController();

  @override
  Future<void> didChangeDependencies() async {
    if (_isInit) {
      if (widget.internalTask.exerciseType == 'matching') {
        await BlocProvider.of<InternalTaskDetailsCubit>(context)
            .getInternalMatchingExerciseDetails(widget.taskPlace,
                widget.internalTask.id, widget.internalTask.exerciseId);
      } else {
        await BlocProvider.of<InternalTaskDetailsCubit>(context)
            .getInternalExerciseDetails(widget.taskPlace,
                widget.internalTask.id, widget.internalTask.exerciseId);
      }
      _isInit = false;
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Widget _text(String text, Color color, double width) {
    return Container(
      width: width,
      margin: const EdgeInsets.symmetric(vertical: 3.0),
      padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 6.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.blue[50]!,
        ),
        color: Colors.blue[50],
        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
      ),
      child: AutoSizeText(
        text,
        textAlign: TextAlign.right,
        style: TextStyle(color: color, fontSize: 18),
      ),
    );
  }

  Widget _result(InternalTaskDetails internalTaskDetails, double width) {
    return Container(
      width: width,
      margin: const EdgeInsets.only(right: 20.0, left: 20.0, bottom: 30.0),
      alignment: Alignment.centerRight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _text('المدة:  ${internalTaskDetails.getDuration()}', Colors.black,
              width),
          _text('عدد المحاولات:  ${internalTaskDetails.attempts.toString()}',
              Colors.black, width),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    String _outTaskDate =
        DaysOfWeek().convert(DateFormat.E().format(widget.internalTask.date)) +
            '   ' +
            DateFormat('yyyy/MM/dd').format(widget.internalTask.date);

    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        centerTitle: true,
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'تفاصيل الحل',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.white,
            fontFamily: 'Mirza',
          ),
        ),
      ),
      endDrawer: AppDrawer(isChild: ChildAccount().getIsChild(), width: width),
      body: Container(
        margin: const EdgeInsets.all(10.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        height: height - 110,
        width: width - 20,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 3.0,
            ),
          ],
        ),
        child: BlocConsumer<InternalTaskDetailsCubit, InternalTaskDetailsState>(
          listener: (context, state) {
            if (state is InternalTaskDetailsFailed) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => ShowDialog(
                  dialogMessage: state.failedMessage,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              );
            }
            if (state is InternalTaskDetailsError) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => ShowDialog(
                  dialogMessage: state.errorMessage,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is InternalTaskDetailsLoading) {
              return const Loading();
            } else if (state is InternalTaskDetailsDone) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: AutoSizeText(_outTaskDate,
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        )),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Hero(
                    tag: 'task-name',
                    transitionOnUserGestures: true,
                    child: AutoSizeText(
                      '${widget.internalTask.taskName}  ⚈',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue[700],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  (widget.internalTask.exerciseType == 'number-order')
                      ? NumberOrderingTask(
                          numbers: (state.exercise as NumbersOrderingExercise)
                              .numbers,
                        )
                      : (widget.internalTask.exerciseType == 'number-compare')
                          ? NumberComparingTask(
                              exercise:
                                  state.exercise as NumbersComparingExercise)
                          : (widget.internalTask.exerciseType ==
                                  'statement-composition')
                              ? StatementCompositionTask(
                                  statement: (state.exercise
                                          as StatementCompositionExercise)
                                      .statement)
                              : ItemsMatchingTask(
                                  exercise:
                                      state.exercise as ItemsMatchingExercise),
                  const SizedBox(
                    height: 40,
                  ),
                  AutoSizeText(
                    'نتائج المحاولات التي قام بها الطفل  ⚈',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue[700],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: Scrollbar(
                      controller: _scrollController,
                      thickness: 3,
                      radius: const Radius.circular(10.0),
                      thumbVisibility: true,
                      child: ListView.builder(
                        controller: _scrollController,
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemCount: state.internalTaskDetails.length,
                        itemBuilder: (context, index) =>
                            _result(state.internalTaskDetails[index], width),
                      ),
                    ),
                  )
                ],
              );
            } else {
              return const Column();
            }
          },
        ),
      ),
    );
  }
}
