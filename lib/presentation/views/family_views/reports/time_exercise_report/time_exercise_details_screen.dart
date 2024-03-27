import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:autism_mobile_app/utils/constant/days_of_week.dart';
import 'package:autism_mobile_app/presentation/widgets/loading.dart';
import 'package:autism_mobile_app/presentation/widgets/app_drawer.dart';
import 'package:autism_mobile_app/presentation/widgets/show_dialog.dart';
import 'package:autism_mobile_app/domain/models/account_models/child_account.dart';
import 'package:autism_mobile_app/domain/models/time_learning_models/time_exercise_log.dart';
import 'package:autism_mobile_app/domain/models/time_learning_models/time_exercise_details.dart';
import 'package:autism_mobile_app/presentation/cubits/time_cubits/time_exercise_report/cubit/time_exercise_details_cubit.dart';
import 'package:autism_mobile_app/presentation/views/family_views/reports/time_exercise_report/analog_time_matching_details.dart';
import 'package:autism_mobile_app/presentation/views/family_views/reports/time_exercise_report/digital_time_matching_details.dart';

class TimeExerciseDetailsScreen extends StatefulWidget {
  const TimeExerciseDetailsScreen({super.key, required this.timeExerciseLog});

  final TimeExerciseLog timeExerciseLog;

  @override
  State<TimeExerciseDetailsScreen> createState() =>
      _TimeExerciseDetailsScreenState();
}

class _TimeExerciseDetailsScreenState extends State<TimeExerciseDetailsScreen> {
  bool _isInit = true;
  final ScrollController _scrollController = ScrollController();

  @override
  Future<void> didChangeDependencies() async {
    if (_isInit) {
      await BlocProvider.of<TimeExerciseDetailsCubit>(context)
          .getExerciseDetails(widget.timeExerciseLog.timeExercise.id);
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

  Widget _result(TimeExerciseDetails timeExerciseDetails, double width) {
    return Container(
      width: width,
      margin: const EdgeInsets.only(right: 20.0, left: 20.0, bottom: 30.0),
      alignment: Alignment.centerRight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _text('المدة:  ${timeExerciseDetails.getDuration()}', Colors.black,
              width),
          _text('عدد المحاولات:  ${timeExerciseDetails.attempts.toString()}',
              Colors.black, width),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    String _exerciseDate = DaysOfWeek()
            .convert(DateFormat.E().format(widget.timeExerciseLog.date)) +
        '   ' +
        DateFormat('yyyy/MM/dd').format(widget.timeExerciseLog.date);

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
      resizeToAvoidBottomInset: false,
      endDrawer: AppDrawer(isChild: ChildAccount().getIsChild(), width: width),
      body: Container(
          margin: const EdgeInsets.all(10.0),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          height: 3.8 * (height / 4),
          width: width,
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
          child:
              BlocConsumer<TimeExerciseDetailsCubit, TimeExerciseDetailsState>(
            listener: (context, state) {
              if (state is TimeExerciseDetailsFailed) {
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
              if (state is TimeExerciseDetailsError) {
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
              if (state is TimeExerciseDetailsLoading) {
                return const Loading();
              } else if (state is TimeExerciseDetailsDone) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: AutoSizeText(_exerciseDate,
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          )),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    AutoSizeText(
                      'مطابقة الوقت  ⚈',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue[700],
                      ),
                    ),
                    (widget.timeExerciseLog.timeExercise.timeType == 'digital')
                        ? Center(
                            child: Container(
                                margin: const EdgeInsets.only(top: 30.0),
                                width: width / 3.4,
                                height: width / 3.4,
                                child: AnalogTimeMatchingDetails(
                                    date: widget.timeExerciseLog.timeExercise
                                        .mainTime)),
                          )
                        : Center(
                            child: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: DigitalTimeMatchingDetails(
                                time: widget
                                    .timeExerciseLog.timeExercise.mainTime),
                          )),
                    const SizedBox(
                      height: 30,
                    ),
                    GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio:
                            widget.timeExerciseLog.timeExercise.timeType ==
                                    'digital'
                                ? 2
                                : 1,
                        crossAxisSpacing: 15.0,
                      ),
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemCount:
                          widget.timeExerciseLog.timeExercise.options.length,
                      itemBuilder: (context, index) =>
                          (widget.timeExerciseLog.timeExercise.timeType ==
                                  'digital')
                              ? DigitalTimeMatchingDetails(
                                  time: widget.timeExerciseLog.timeExercise
                                      .options[index])
                              : AnalogTimeMatchingDetails(
                                  date: widget.timeExerciseLog.timeExercise
                                      .options[index]),
                    ),
                    const SizedBox(
                      height: 30,
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
                          itemCount: state.timeExerciseDetails.length,
                          itemBuilder: (context, index) =>
                              _result(state.timeExerciseDetails[index], width),
                        ),
                      ),
                    )
                  ],
                );
              } else {
                return const Column();
              }
            },
          )),
    );
  }
}
