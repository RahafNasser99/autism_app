import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:autism_mobile_app/presentation/widgets/loading.dart';
import 'package:autism_mobile_app/presentation/widgets/show_dialog.dart';
import 'package:autism_mobile_app/presentation/views/shared_views/empty_content.dart';
import 'package:autism_mobile_app/domain/models/exercise_models/numbers_ordering.dart';
import 'package:autism_mobile_app/presentation/cubits/exercise_cubits/cubit/exercise_cubit.dart';

class NumbersOrdering extends StatefulWidget {
  const NumbersOrdering({super.key, required this.taskPlace});

  final String taskPlace;

  @override
  State<NumbersOrdering> createState() => _NumbersOrderingState();
}

class _NumbersOrderingState extends State<NumbersOrdering> {
  bool _up = false;
  bool _isInit = true;
  List<String> numbers = [];
  List<String> solvedNumbers = [];
  late NumbersOrderingExercise exercise;
  late int taskId;
  int _wrongAnswerCount = 0;
  late DateTime _startDate;
  late DateTime _finishDate;
  late int duration = 0;
  bool _status = false;
  bool sendAnswer = false;
  Timer? _timer;
  double _innerWidth = 0.0;
  int _seconds = 0;

  @override
  Future<void> didChangeDependencies() async {
    if (_isInit) {
      await BlocProvider.of<ExerciseCubit>(context)
          .getExercise('number-order', widget.taskPlace)
          .whenComplete(() => _startDate = DateTime.now());
      _isInit = false;
    }
    _isInit = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _seconds += 1;
      setState(() {
        _innerWidth += 0.1;
      });
      if (_seconds == 11) {
        _seconds = 0;
        _innerWidth = 0.0;
      }
    });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _sendAnswer() async {
    _finishDate = DateTime.now();
    duration = _finishDate.difference(_startDate).inSeconds;
    if (sendAnswer) {
      await BlocProvider.of<ExerciseCubit>(context).postExerciseAnswer(
          widget.taskPlace, taskId, _status, duration, _wrongAnswerCount);
    }
  }

  Widget _number(int index, double width) {
    return TextButton(
      child: Text(numbers[index].isNotEmpty ? numbers[index] : '',
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: Colors.blue, fontSize: 25, fontWeight: FontWeight.w900)),
      style: TextButton.styleFrom(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          backgroundColor: (_seconds >= 10 &&
                  exercise.checkCurrentAnswer(solvedNumbers) &&
                  numbers[index] ==
                      exercise.answer[solvedNumbers.length].toString())
              ? Colors.blue[100]
              : Colors.transparent),
      onPressed: () {
        String number = numbers[index];
        if (numbers[index].isNotEmpty) {
          setState(() {
            numbers[index] = '';
            solvedNumbers.add(number);
          });
        }
        if (exercise.checkAnswer(solvedNumbers)) {
          _status = true;
          _sendAnswer();
          Future.delayed(const Duration(milliseconds: 600)).whenComplete(
              () => Navigator.of(context).popAndPushNamed('/bravo-screen'));
        } else if (exercise.checkCurrentAnswer(solvedNumbers)) {
          setState(() {
            _seconds = 0;
            _innerWidth = 0.0;
          });
        } else {
          _wrongAnswerCount++;
          _status = false;
          setState(() {
            _seconds = 0;
            _innerWidth = 0.0;
          });
        }
      },
    );
  }

  Widget _cell(int index, double width) {
    return InkWell(
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: (solvedNumbers.isNotEmpty && index < solvedNumbers.length)
              ? Colors.white
              : Colors.transparent,
          border: Border.all(
            color: (solvedNumbers.isNotEmpty && index < solvedNumbers.length)
                ? exercise.checkColor(solvedNumbers, index)
                    ? Colors.green
                    : Colors.red
                : Colors.black45,
          ),
          boxShadow: [
            BoxShadow(
              color: (solvedNumbers.isNotEmpty && index < solvedNumbers.length)
                  ? exercise.checkColor(solvedNumbers, index)
                      ? Colors.green
                      : Colors.red
                  : Colors.transparent,
              blurRadius: 1.0,
              spreadRadius: 1.0,
            )
          ],
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        ),
        child: solvedNumbers.isNotEmpty && index <= (solvedNumbers.length - 1)
            ? Text((solvedNumbers[index]),
                style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 25,
                    fontWeight: FontWeight.bold))
            : const Text(''),
      ),
      onTap: () {
        int numberIndex =
            (exercise.getNumbersAsString()).indexOf(solvedNumbers[index]);

        setState(() {
          numbers[numberIndex] = solvedNumbers[index];
          solvedNumbers.removeAt(index);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        _timer?.cancel();
        _status = false;
        _sendAnswer();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 2.0,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: const Text(
            'ترتيب الأرقام',
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
          margin: const EdgeInsets.all(10.0),
          padding: const EdgeInsets.all(16.0),
          height: height - 110,
          width: width - 20,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            image: const DecorationImage(
                image: AssetImage('assets/images/backgrounds/background1.PNG'),
                fit: BoxFit.fill),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 3.0,
              ),
            ],
          ),
          child: BlocConsumer<ExerciseCubit, ExerciseState>(
            listener: (context, state) {
              if (state is ExerciseDone) {
                sendAnswer = true;
                taskId = state.taskId;
                exercise = state.exercise as NumbersOrderingExercise;
                numbers.addAll(exercise.getNumbersAsString());
                if (numbers.length > 10) {
                  setState(() {
                    _up = true;
                  });
                }
              }
              if (state is ExerciseEmpty) {
                sendAnswer = false;
              }
              if (state is ExerciseFailed) {
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
              if (state is ExerciseError) {
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
              if (state is ExerciseLoading) {
                return const Loading();
              } else if (state is ExerciseEmpty) {
                return EmptyContent(text: 'لا يوجد تمارين', width: width);
              } else if (state is ExerciseDone) {
                return SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      const Align(
                        alignment: Alignment.topRight,
                        child: AutoSizeText(
                          'رتب الأرقام التالية',
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Center(
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 30.0),
                          alignment: Alignment.centerLeft,
                          width: width - 20,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                          child: LinearProgressIndicator(
                            value: _innerWidth,
                            backgroundColor: Colors.white,
                            valueColor:
                                const AlwaysStoppedAnimation(Colors.blue),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: !_up,
                        child: Container(
                          height: width / 2,
                          width: width / 2,
                          margin: const EdgeInsets.only(bottom: 10.0),
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      'assets/images/tasks/ordering-numbers.jpg'),
                                  fit: BoxFit.contain)),
                        ),
                      ),
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: Column(
                          children: [
                            Container(
                              margin: numbers.length < 3
                                  ? const EdgeInsets.only(top: 30.0)
                                  : const EdgeInsets.only(top: 2.0),
                              height: _up ? height / 3 : null,
                              child: GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                      numbers.length < 5 ? numbers.length : 5,
                                  crossAxisSpacing:
                                      numbers.length < 5 ? 20.0 : 15.0,
                                  childAspectRatio:
                                      numbers.length < 3 ? 3.0 : 1.7,
                                  mainAxisSpacing:
                                      numbers.length < 5 ? 20.0 : 0.0,
                                ),
                                shrinkWrap: true,
                                physics: const ScrollPhysics(),
                                itemCount: numbers.length,
                                itemBuilder: (context, index) =>
                                    _number(index, width),
                              ),
                            ),
                            Container(
                              margin: numbers.length < 3
                                  ? const EdgeInsets.only(top: 20.0)
                                  : const EdgeInsets.only(top: 10.0),
                              height: _up ? height / 3 : null,
                              child: GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                      numbers.length < 5 ? numbers.length : 5,
                                  crossAxisSpacing:
                                      numbers.length < 5 ? 20.0 : 15.0,
                                  childAspectRatio:
                                      numbers.length < 3 ? 3.0 : 1.7,
                                  mainAxisSpacing:
                                      numbers.length < 5 ? 20.0 : 15.0,
                                ),
                                shrinkWrap: true,
                                physics: const ScrollPhysics(),
                                itemCount: numbers.length,
                                itemBuilder: (context, index) =>
                                    _cell(index, width),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                );
              } else {
                return const Column();
              }
            },
          ),
        ),
      ),
    );
  }
}
