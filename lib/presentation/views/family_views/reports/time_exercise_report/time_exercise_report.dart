import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:page_transition/page_transition.dart';

import 'package:autism_mobile_app/presentation/widgets/loading.dart';
import 'package:autism_mobile_app/presentation/widgets/app_drawer.dart';
import 'package:autism_mobile_app/presentation/widgets/show_dialog.dart';
import 'package:autism_mobile_app/domain/models/account_models/child_account.dart';
import 'package:autism_mobile_app/presentation/views/shared_views/empty_content.dart';
import 'package:autism_mobile_app/presentation/widgets/reusable_elevated_button.dart';
import 'package:autism_mobile_app/domain/models/time_learning_models/time_exercise_log.dart';
import 'package:autism_mobile_app/presentation/cubits/time_cubits/time_exercise_report/cubit/time_exercise_report_cubit.dart';
import 'package:autism_mobile_app/presentation/cubits/time_cubits/time_exercise_report/cubit/time_exercise_details_cubit.dart';
import 'package:autism_mobile_app/presentation/views/family_views/reports/time_exercise_report/time_exercise_details_screen.dart';

class TimeExerciseReport extends StatefulWidget {
  const TimeExerciseReport({super.key});

  @override
  State<TimeExerciseReport> createState() => _TimeExerciseReportState();
}

class _TimeExerciseReportState extends State<TimeExerciseReport> {
  bool _isInit = true;
  bool _achievedExercise = true;

  @override
  Future<void> didChangeDependencies() async {
    if (_isInit) {
      await BlocProvider.of<TimeExerciseReportCubit>(context)
          .getFirstPage(_achievedExercise.toString());
      _isInit = false;
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> getAchievedExercises() async {
    await BlocProvider.of<TimeExerciseReportCubit>(context)
        .getFirstPage('true');
  }

  Future<void> getUnAchievedExercises() async {
    await BlocProvider.of<TimeExerciseReportCubit>(context)
        .getFirstPage('false');
  }

  Widget _text(String text, Color color) {
    return AutoSizeText(
      text,
      textAlign: TextAlign.right,
      style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.w600),
    );
  }

  Widget _task(double height, double width, TimeExerciseLog timeExerciseLog,
      void Function() onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 120,
        width: width - 30,
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black12)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              width: (width - 30) / 2.3,
              margin: const EdgeInsets.only(bottom: 8.0, top: 8.0, left: 8.0),
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                        timeExerciseLog.timeExercise.getExerciseImage()),
                    fit: BoxFit.contain),
              ),
            ),
            Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 10.0),
                width: (width - 30) / 1.8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    const AutoSizeText(
                      'مطابقة وقت',
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 6.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        _text(timeExerciseLog.totalTries.toString(),
                            Colors.green),
                        _text('  :عدد مرات المحاولة', Colors.blue[800]!),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        _text('ثانية', Colors.green),
                        _text('${timeExerciseLog.totalTime.toString()} ',
                            Colors.green),
                        _text('  :المدة', Colors.blue[800]!),
                      ],
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        centerTitle: true,
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'تقرير تمارين الوقت',
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
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ReUsableElevatedButton(
                    width: width,
                    title: 'لم يتم إنجازها',
                    mark: !_achievedExercise,
                    borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(5.0), right: Radius.zero),
                    onPressed: () {
                      if (!_achievedExercise) {
                        return;
                      } else {
                        setState(() {
                          _achievedExercise = false;
                        });
                        getUnAchievedExercises();
                      }
                    }),
                ReUsableElevatedButton(
                  width: width,
                  title: 'تم إنجازها',
                  mark: _achievedExercise,
                  borderRadius: const BorderRadius.horizontal(
                      left: Radius.zero, right: Radius.circular(5.0)),
                  onPressed: () {
                    if (_achievedExercise) {
                      return;
                    } else {
                      setState(() {
                        _achievedExercise = true;
                      });
                      getAchievedExercises();
                    }
                  },
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
              height: 1.5 * height / 2,
              width: width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 3.0,
                      spreadRadius: 2.0),
                ],
              ),
              child: BlocConsumer<TimeExerciseReportCubit,
                  TimeExerciseReportState>(
                listener: (context, state) {
                  if (state is TimeExerciseReportFailed) {
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
                  if (state is TimeExerciseReportError) {
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
                  if (state is TimeExerciseReportLoading) {
                    return const Loading();
                  } else if (state is TimeExerciseReportEmpty) {
                    return Center(
                      child:
                          EmptyContent(text: 'سجل التمارين فارغ', width: width),
                    );
                  } else if (state is TimeExerciseReportDone) {
                    return ListView.builder(
                      controller: context
                          .read<TimeExerciseReportCubit>()
                          .scrollController,
                      itemCount:
                          context.read<TimeExerciseReportCubit>().isLoadingMore
                              ? state.timeExerciseLog.length + 1
                              : state.timeExerciseLog.length,
                      itemBuilder: (context, index) {
                        if (index >= state.timeExerciseLog.length) {
                          return SpinKitThreeInOut(
                              itemBuilder: (BuildContext context, int index) {
                            return DecoratedBox(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: index.isEven ? Colors.blue : Colors.grey,
                              ),
                            );
                          });
                        } else {
                          return _task(
                            height,
                            width,
                            state.timeExerciseLog[index],
                            () {
                              Navigator.of(context).push(
                                PageTransition(
                                  child: BlocProvider<TimeExerciseDetailsCubit>(
                                    create: (context) =>
                                        TimeExerciseDetailsCubit(),
                                    child: TimeExerciseDetailsScreen(
                                        timeExerciseLog:
                                            state.timeExerciseLog[index]),
                                  ),
                                  type: PageTransitionType.rightToLeft,
                                  duration: const Duration(milliseconds: 500),
                                ),
                              );
                            },
                          );
                        }
                      },
                    );
                  } else {
                    return const Column();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
