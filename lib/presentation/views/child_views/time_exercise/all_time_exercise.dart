import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:page_transition/page_transition.dart';

import 'package:autism_mobile_app/presentation/widgets/loading.dart';
import 'package:autism_mobile_app/presentation/widgets/show_dialog.dart';
import 'package:autism_mobile_app/presentation/views/shared_views/empty_content.dart';
import 'package:autism_mobile_app/domain/models/time_learning_models/time_exercise.dart';
import 'package:autism_mobile_app/presentation/cubits/exercise_cubits/cubit/time_exercise_cubit.dart';
import 'package:autism_mobile_app/presentation/views/child_views/time_exercise/analog_time_matching.dart';
import 'package:autism_mobile_app/presentation/views/child_views/time_exercise/digital_time_matching.dart';
import 'package:autism_mobile_app/presentation/cubits/exercise_cubits/cubit/send_time_exercise_answer_cubit.dart';

class AllTimeExercise extends StatefulWidget {
  const AllTimeExercise({super.key});

  @override
  State<AllTimeExercise> createState() => _AllTimeExerciseState();
}

class _AllTimeExerciseState extends State<AllTimeExercise> {
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      BlocProvider.of<TimeExerciseCubit>(context).getFirstPage();
      _isInit = false;
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Widget _task(TimeExercise timeExercise, int index, double height,
      double width, void Function() onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height / 6,
        margin: const EdgeInsets.only(
            bottom: 12.0, top: 4.0, left: 4.0, right: 4.0),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 2.0,
                color: Colors.black12,
                spreadRadius: 2.0,
              )
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              width: (width - 30) / 2,
              margin: const EdgeInsets.only(left: 8.0),
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(timeExercise.getExerciseImage()),
                    fit: BoxFit.contain),
              ),
            ),
            Container(
              width: (width - 20) / 2,
              alignment: Alignment.center,
              child: AutoSizeText('التمرين ${index + 1}',
                  style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 25,
                      fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'تمارين الوقت',
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            fontSize: 25,
            fontFamily: 'Mirza',
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.blue),
      ),
      body: Container(
        height: height,
        width: width,
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage('assets/images/backgrounds/background1.PNG'),
          fit: BoxFit.fill,
        )),
        child: BlocConsumer<TimeExerciseCubit, TimeExerciseState>(
          listener: (context, state) {
            if (state is TimeExerciseFailed) {
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
            if (state is TimeExerciseError) {
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
            if (state is TimeExerciseLoading) {
              return const Loading();
            } else if (state is TimeExerciseEmpty) {
              return Center(
                  child: EmptyContent(text: 'لا يوجد تمارين', width: width));
            } else if (state is TimeExerciseDone) {
              return ListView.builder(
                  controller:
                      context.read<TimeExerciseCubit>().scrollController,
                  itemCount: context.read<TimeExerciseCubit>().isLoadingMore
                      ? state.exercises.length + 1
                      : state.exercises.length,
                  itemBuilder: (context, index) {
                    if (index >= state.exercises.length) {
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
                      return _task(state.exercises[index], index, height, width,
                          () {
                        if (state.exercises[index].timeType == 'digital') {
                          Navigator.of(context)
                              .push(PageTransition(
                                child:
                                    BlocProvider<SendTimeExerciseAnswerCubit>(
                                  create: (context) =>
                                      SendTimeExerciseAnswerCubit(),
                                  child: DigitalTimeMatching(
                                      timeExercise: state.exercises[index]),
                                ),
                                type: PageTransitionType.scale,
                                alignment: Alignment.center,
                                duration: const Duration(seconds: 1),
                              ))
                              .then((_) async =>
                                  BlocProvider.of<TimeExerciseCubit>(context)
                                      .getFirstPage());
                        } else {
                          Navigator.of(context)
                              .push(PageTransition(
                                child:
                                    BlocProvider<SendTimeExerciseAnswerCubit>(
                                  create: (context) =>
                                      SendTimeExerciseAnswerCubit(),
                                  child: AnalogTimeMatching(
                                      timeExercise: state.exercises[index]),
                                ),
                                type: PageTransitionType.scale,
                                alignment: Alignment.center,
                                duration: const Duration(seconds: 1),
                              ))
                              .then((_) async =>
                                  BlocProvider.of<TimeExerciseCubit>(context)
                                      .getFirstPage());
                        }
                      });
                    }
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
