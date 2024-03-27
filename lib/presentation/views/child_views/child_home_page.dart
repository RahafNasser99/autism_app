import 'package:autism_mobile_app/domain/models/time_learning_models/waiting_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

import 'package:autism_mobile_app/presentation/widgets/app_drawer.dart';
import 'package:autism_mobile_app/domain/models/account_models/child_account.dart';
import 'package:autism_mobile_app/presentation/views/child_views/center_home_exercise/internal_exercise.dart';
import 'package:autism_mobile_app/presentation/cubits/daily_program_cubits/cubit/daily_program_cubit.dart';
import 'package:autism_mobile_app/presentation/views/child_views/child_daily_program/child_daily_program.dart';

class ChildHomePage extends StatefulWidget {
  const ChildHomePage({Key? key}) : super(key: key);

  @override
  State<ChildHomePage> createState() => _ChildHomePageState();
}

class _ChildHomePageState extends State<ChildHomePage> {
  Widget _component(double radius, void Function()? onTap, String imagePath) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  blurRadius: 3.0, color: Colors.blue[100]!, spreadRadius: 2.0)
            ],
            image: DecorationImage(
                image: AssetImage(imagePath), fit: BoxFit.contain)),
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 2.0,
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.all(6.0),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child:
                Image.asset('assets/images/aamalLogo.png', fit: BoxFit.contain),
          ),
        ),
        centerTitle: true,
        title: const Text(
          'آمال',
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            fontFamily: 'Marhey',
            fontSize: 25,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.blue),
      ),
      endDrawer: AppDrawer(
        isChild: ChildAccount().getIsChild(),
        width: width,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage('assets/images/backgrounds/background.PNG')),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 2.5 * height / 4, // 3.1   -- remain 1.3  //2.7
              child: Row(
                children: <Widget>[
                  Column(
                    // 0.5 + 1.0 + 0.95 + 0.25 = 1.95 = 0.5 = 2.45
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 0.5 * height / 4),
                        padding: const EdgeInsets.only(
                            bottom: 10.0, left: 15.0, right: 15.0),
                        height: 1.0 * height / 4, // 1.3
                        width: width / 2,
                        child: _component(width / 4.9, () {
                          if (WaitingTime.waitingTime > 0) {
                            Navigator.of(context)
                                .pushNamed('/waiting-screen')
                                .whenComplete(() => Navigator.of(context).push(
                                      PageTransition(
                                        child: const InternalExercise(
                                          placeMark: 'home-task',
                                        ),
                                        type: PageTransitionType.rightToLeft,
                                        duration:
                                            const Duration(milliseconds: 500),
                                      ),
                                    ));
                          } else {
                            Navigator.of(context).push(
                              PageTransition(
                                child: const InternalExercise(
                                  placeMark: 'home-task',
                                ),
                                type: PageTransitionType.rightToLeft,
                                duration: const Duration(milliseconds: 500),
                              ),
                            );
                          }
                        }, 'assets/images/components/home-tasks-component.jpg'),
                      ),
                      Container(
                        padding: const EdgeInsets.only(right: 1.0, left: 60.0),
                        height: 0.95 * height / 4,
                        width: width / 2,
                        child: _component(width / 6.2, () {
                          if (WaitingTime.waitingTime > 0) {
                            Navigator.of(context)
                                .pushNamed('/waiting-screen')
                                .whenComplete(() => Navigator.of(context).push(
                                      PageTransition(
                                        child: const InternalExercise(
                                          placeMark: 'center-task',
                                        ),
                                        type: PageTransitionType.rightToLeft,
                                        duration:
                                            const Duration(milliseconds: 500),
                                      ),
                                    ));
                          } else {
                            Navigator.of(context).push(
                              PageTransition(
                                child: const InternalExercise(
                                  placeMark: 'center-task',
                                ),
                                type: PageTransitionType.rightToLeft,
                                duration: const Duration(milliseconds: 500),
                              ),
                            );
                          }
                        }, 'assets/images/components/center-tasks-component.jpg'),
                      ),
                    ],
                  ),
                  Column(
                    // 1.3 + 0.9 + 0.3 = 2.5
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        height: 1.3 * height / 4, //still
                        width: width / 2,
                        child: _component(width / 4.6, () {
                          if (WaitingTime.waitingTime > 0) {
                            Navigator.of(context)
                                .pushNamed('/waiting-screen')
                                .whenComplete(() => Navigator.of(context)
                                    .pushNamed('/needs-screen',
                                        arguments: null));
                          } else {
                            Navigator.of(context)
                                .pushNamed('/needs-screen', arguments: null);
                          }
                        }, 'assets/images/components/needs-component.jpg'),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 0.3 * height / 4),
                        padding: const EdgeInsets.only(right: 25.0, left: 25.0),
                        height: 0.9 * height / 4,
                        width: width / 2,
                        child: _component(width / 5.7, () {
                          if (WaitingTime.waitingTime > 0) {
                            Navigator.of(context)
                                .pushNamed('/waiting-screen')
                                .whenComplete(() => Navigator.of(context)
                                    .pushNamed('/all-time-exercise-screen'));
                          } else {
                            Navigator.of(context)
                                .pushNamed('/all-time-exercise-screen');
                          }
                        }, 'assets/images/components/time-matching-component.jpg'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 0.52 * height / 4,
              child: BlocProvider<DailyProgramCubit>(
                create: (context) => DailyProgramCubit(),
                child: ChildDailyProgram(
                  width: width / 3,
                  height: height,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
