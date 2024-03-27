import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:autism_mobile_app/presentation/widgets/show_dialog.dart';
import 'package:autism_mobile_app/domain/models/daily_program_models/activity.dart';
import 'package:autism_mobile_app/domain/models/daily_program_models/daily_program.dart';
import 'package:autism_mobile_app/presentation/cubits/daily_program_cubits/cubit/daily_program_cubit.dart';

class ChildDailyProgram extends StatefulWidget {
  const ChildDailyProgram({Key? key, required this.width, required this.height})
      : super(key: key);

  final double width;
  final double height;

  @override
  State<ChildDailyProgram> createState() => _ChildDailyProgramState();
}

class _ChildDailyProgramState extends State<ChildDailyProgram> {
  bool _isInit = true;
  Timer _timer = Timer(const Duration(), () {});
  late List<Activity> activities;
  double innerWidth = 0;
  double greenWidth = 0;
  double blueWidth = 0;

  @override
  Future<void> didChangeDependencies() async {
    if (_isInit) {
      DailyProgram? dailyProgram =
          await BlocProvider.of<DailyProgramCubit>(context)
              .getChildDailyProgram();
      activities = (dailyProgram != null) ? dailyProgram.activities : [];

      int innerIndex = 0;
      for (Activity activity in activities) {
        if (activity.checkTimeBeforeAndAfter() || activity.checkTimeAfter()) {
          activities.remove(activity);
          activities.insert(innerIndex, activity);
          innerIndex++;
        }
      }

      _isInit = false;
    }
    _isInit = false;

    DateTime blueNow = DateTime.now();
    DateTime greenNow = DateTime.now();

    DateTime now = DateTime.now();

    late Duration different;
    late double px;

    if (activities.isNotEmpty) {
      different = activities[0].comparedTime.difference(now);

      _timer = Timer.periodic(const Duration(minutes: 1), (Timer t) {
        // increase blue width
        if (activities[0].checkTimeAfter()) {
          greenNow = DateTime.now();
          greenWidth = 0;
          different = activities[0].comparedTime.difference(blueNow);
          px = 1.0 / different.inMinutes;
          setState(() {
            blueWidth += px;
            innerWidth = blueWidth;
          });
        }
        // increase green width
        else if (activities[0].checkTimeBeforeAndAfter()) {
          blueNow = DateTime.now();
          blueWidth = 0;
          different = activities[0].comparedDuration.difference(greenNow);
          px = 1.0 / different.inMinutes;
          px = 1.0 / different.inMinutes;
          setState(() {
            greenWidth += px;
            innerWidth = greenWidth;
          });
        } else {
          blueWidth = 0;
          greenWidth = 0;
          greenNow = DateTime.now();
          blueNow = DateTime.now();
          setState(() {
            innerWidth = 0;
          });
        }
      });
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Widget _activity(Activity activity) {
    return Container(
      width: widget.width,
      decoration: BoxDecoration(
        border: activity.checkTimeBeforeAndAfter()
            ? const Border.symmetric(
                horizontal: BorderSide(
                  color: Colors.green,
                  width: 2.0,
                ),
                vertical: BorderSide(
                  color: Colors.green,
                  width: 1.5,
                ),
              )
            : const Border.symmetric(
                vertical: BorderSide(color: Colors.blue, width: 0.6)),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            alignment: Alignment.center,
            width: (2 * widget.width / 3) - 10,
            padding: const EdgeInsets.only(left: 5.0),
            child: AutoSizeText(
              activity.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: activity.checkTimeBeforeAndAfter()
                    ? Colors.green
                    : activity.checkTimeBefore()
                        ? Colors.black
                        : Colors.blue,
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(right: 0.5),
            width: widget.width / 3,
            foregroundDecoration: activity.checkTimeBeforeAndAfter()
                ? null
                : activity.checkTimeBefore()
                    ? const BoxDecoration(
                        color: Colors.grey,
                        backgroundBlendMode: BlendMode.saturation,
                      )
                    : null,
            decoration: BoxDecoration(
              color: activity.content.content.contains('.')
                  ? Colors.white
                  : Colors.blue[50],
              image: activity.content.content.contains('.')
                  ? DecorationImage(
                      image: NetworkImage(activity.content.content),
                      fit: BoxFit.fill)
                  : null,
            ),
            child: !activity.content.content.contains('.')
                ? AutoSizeText(
                    activity.content.content,
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  )
                : null,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DailyProgramCubit, DailyProgramState>(
      listener: (context, state) {
        if (state is DailyProgramFailed) {
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
        if (state is DailyProgramError) {
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
        if (state is DailyProgramDone) {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 16.0, bottom: 8.0),
                    child: Text(
                      'البرنامج المنزلي',
                      style: TextStyle(
                        shadows: [
                          Shadow(
                            blurRadius: 2.0,
                            color: Colors.blue,
                          )
                        ],
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 10.0),
                    height: (0.17 * widget.height / 4) - 20,
                    alignment: Alignment.centerLeft,
                    width: widget.width - 20,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: (activities[0].checkTimeBeforeAndAfter())
                            ? Colors.green
                            : Colors.blue,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: (activities[0].checkTimeBeforeAndAfter())
                              ? Colors.green
                              : Colors.blue,
                          spreadRadius: 0.6,
                          blurRadius: 0.6,
                        )
                      ],
                    ),
                    child: LinearProgressIndicator(
                      minHeight: (0.17 * widget.height / 4) - 20,
                      value: innerWidth,
                      backgroundColor: Colors.white,
                      valueColor: AlwaysStoppedAnimation(
                        (activities[0].checkTimeBeforeAndAfter())
                            ? Colors.green
                            : activities[0].checkTimeAfter()
                                ? Colors.blue
                                : Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                height: 0.3 * widget.height / 4,
                alignment: Alignment.centerRight,
                decoration:
                    const BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                    blurRadius: 3.0,
                    spreadRadius: 2.0,
                    color: Colors.black12,
                  ),
                ]),
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    reverse: true,
                    itemCount: state.dailyProgram.activities.length,
                    itemBuilder: (context, index) {
                      int innerIndex = 0;
                      for (Activity activity in activities) {
                        if (activity.checkTimeBeforeAndAfter() ||
                            activity.checkTimeAfter()) {
                          activities.remove(activity);
                          activities.insert(innerIndex, activity);
                          innerIndex++;
                        }
                      }
                      return _activity(
                        activities[index],
                      );
                    }),
              ),
            ],
          );
        } else {
          return const Row();
        }
      },
    );
  }
}
