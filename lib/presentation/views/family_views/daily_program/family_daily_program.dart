import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:autism_mobile_app/presentation/widgets/loading.dart';
import 'package:autism_mobile_app/presentation/widgets/app_drawer.dart';
import 'package:autism_mobile_app/presentation/widgets/show_dialog.dart';
import 'package:autism_mobile_app/domain/models/account_models/child_account.dart';
import 'package:autism_mobile_app/domain/models/daily_program_models/activity.dart';
import 'package:autism_mobile_app/presentation/views/shared_views/empty_content.dart';
import 'package:autism_mobile_app/presentation/cubits/daily_program_cubits/cubit/daily_program_cubit.dart';

class FamilyDailyProgram extends StatefulWidget {
  const FamilyDailyProgram({super.key});

  @override
  State<FamilyDailyProgram> createState() => _FamilyDailyProgramState();
}

class _FamilyDailyProgramState extends State<FamilyDailyProgram> {
  bool _isInit = true;
  late Timer _timer;

  @override
  Future<void> didChangeDependencies() async {
    if (_isInit) {
      await BlocProvider.of<DailyProgramCubit>(context).getChildDailyProgram();
      _isInit = false;
    }
    _isInit = false;
    _timer = Timer.periodic(
        const Duration(minutes: 1), (Timer t) => setState(() {}));
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Widget _activity(Activity activity, double width) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: activity.checkTimeBeforeAndAfter()
                ? Colors.green
                : Colors.black26,
            spreadRadius: 2.0,
            blurRadius: 2.0,
          )
        ],
      ),
      child: GridTile(
        header: Container(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: activity.checkTimeBefore() ? Colors.grey[300] : Colors.white,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5.0), topRight: Radius.circular(5.0)),
          ),
          child: Text(
            activity.name,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: activity.checkTimeBeforeAndAfter()
                  ? Colors.green
                  : activity.checkTimeBefore()
                      ? Colors.black
                      : Colors.blue,
            ),
          ),
        ),
        child: Container(
          alignment: Alignment.center,
          foregroundDecoration: activity.checkTimeBeforeAndAfter()
              ? null
              : activity.checkTimeBefore()
                  ? const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      color: Colors.grey,
                      backgroundBlendMode: BlendMode.saturation,
                    )
                  : null,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
              color: activity.content.content.contains('.')
                  ? Colors.white
                  : activity.checkTimeBeforeAndAfter()
                      ? Colors.green[50]
                      : Colors.blue[50],
              image: activity.content.content.contains('.')
                  ? DecorationImage(
                      image: NetworkImage(activity.content.content),
                      fit: BoxFit.cover,
                    )
                  : null),
          child: !activity.content.content.contains('.')
              ? AutoSizeText(
                  activity.content.content,
                  style: TextStyle(
                    color: activity.checkTimeBeforeAndAfter()
                        ? Colors.green
                        : Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                )
              : null,
        ),
        footer: Container(
          padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(5.0),
                bottomRight: Radius.circular(5.0)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AutoSizeText(
                'التوقيت: ' + activity.time.toString(),
                style: TextStyle(
                  color: activity.checkTimeBefore()
                      ? Colors.black54
                      : Colors.black,
                ),
              ),
              AutoSizeText(
                'المدة: ' + activity.duration.toString(),
                style: TextStyle(
                  color: activity.checkTimeBefore()
                      ? Colors.black54
                      : Colors.black,
                ),
              ),
            ],
          ),
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
          'البرنامج المنزلي',
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
        height: height,
        width: width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/backgrounds/background1.PNG'),
            fit: BoxFit.fill,
          ),
        ),
        child: BlocConsumer<DailyProgramCubit, DailyProgramState>(
          listener: (context, state) {
            if (state is DailyProgramFailed) {
              showDialog(
                context: context,
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
            if (state is DailyProgramLoading) {
              return const Loading();
            } else if (state is DailyProgramNotFound) {
              return Center(
                  child:
                      EmptyContent(text: 'لا يوجد برنامج للطفل', width: width));
            } else if (state is DailyProgramDone) {
              return GridView.builder(
                  padding: const EdgeInsets.all(10.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1,
                    crossAxisSpacing: 15.0,
                    mainAxisSpacing: 15.0,
                  ),
                  itemCount: state.dailyProgram.activities.length,
                  itemBuilder: (context, index) {
                    List<Activity> activities = state.dailyProgram.activities;
                    int innerIndex = 0;
                    for (Activity activity in activities) {
                      if (activity.checkTimeBeforeAndAfter() ||
                          activity.checkTimeAfter()) {
                        activities.remove(activity);
                        activities.insert(innerIndex, activity);
                        innerIndex++;
                      }
                    }
                    return _activity(activities[index], width / 4);
                  });
            } else {
              return const Column();
            }
          },
        ),
      ),
    );
  }
}
