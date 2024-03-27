import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:autism_mobile_app/presentation/widgets/loading.dart';
import 'package:autism_mobile_app/presentation/widgets/show_dialog.dart';
import 'package:autism_mobile_app/presentation/views/shared_views/empty_content.dart';
import 'package:autism_mobile_app/domain/models/exercise_models/numbers_comparing.dart';
import 'package:autism_mobile_app/presentation/cubits/exercise_cubits/cubit/exercise_cubit.dart';

class NumbersComparing extends StatefulWidget {
  const NumbersComparing({super.key, required this.taskPlace});

  final String taskPlace;

  @override
  State<NumbersComparing> createState() => _NumbersComparingState();
}

class _NumbersComparingState extends State<NumbersComparing> {
  bool _tapped1 = false;
  bool _tapped2 = false;
  bool _tapped3 = false;
  String _selectedSign = '';
  bool _isInit = true;
  late NumbersComparingExercise exercise;
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
          .getExercise('number-compare', widget.taskPlace)
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

  Widget _number(int number) {
    return Text(
      number.toString(),
      style: const TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.w900,
        fontSize: 45,
      ),
    );
  }

  Widget _sign(int index, String sign, _tapped) {
    return InkWell(
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: (_seconds >= 10 && exercise.checkAnswer(sign))
              ? Colors.blue[100]
              : _tapped
                  ? Colors.white
                  : Colors.transparent,
          border: Border.all(
            color: (_tapped && exercise.checkAnswer(sign))
                ? Colors.green
                : (_tapped && !exercise.checkAnswer(sign))
                    ? Colors.red
                    : Colors.transparent,
            width: 2,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              spreadRadius: 1.0,
              blurRadius: 1.0,
              color: (_tapped && exercise.checkAnswer(sign))
                  ? Colors.green
                  : (_tapped && !exercise.checkAnswer(sign))
                      ? Colors.red
                      : Colors.transparent,
            )
          ],
        ),
        child: Text(
          sign,
          style: TextStyle(
            color: (_seconds >= 10 && exercise.checkAnswer(sign))
                ? Colors.blue
                : Colors.green,
            fontWeight: FontWeight.w900,
            fontSize: 45,
          ),
        ),
      ),
      onTap: () {
        setState(() {
          _selectedSign = sign;
          if (index == 1) {
            _tapped1 = true;
            _tapped2 = false;
            _tapped3 = false;
          } else if (index == 2) {
            _tapped2 = true;
            _tapped1 = false;
            _tapped3 = false;
          } else {
            _tapped3 = true;
            _tapped1 = false;
            _tapped2 = false;
          }
          if (exercise.checkAnswer(sign)) {
            _status = true;
            _sendAnswer();
            Future.delayed(const Duration(milliseconds: 600)).whenComplete(
                () => Navigator.of(context).popAndPushNamed('/bravo-screen'));
          } else {
            _wrongAnswerCount++;
            _status = false;
            setState(() {
              _seconds = 0;
              _innerWidth = 0.0;
            });
          }
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
            'مقارنة الأرقام',
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
              exercise = state.exercise as NumbersComparingExercise;
              taskId = state.taskId;
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
          }, builder: (context, state) {
            if (state is ExerciseLoading) {
              return const Loading();
            } else if (state is ExerciseEmpty) {
              return EmptyContent(text: 'لا يوجد تمارين', width: width);
            } else if (state is ExerciseDone) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Align(
                      alignment: Alignment.topRight,
                      child: AutoSizeText(
                        'قارن بين الرقمين التاليين',
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
                          valueColor: const AlwaysStoppedAnimation(Colors.blue),
                        ),
                      ),
                    ),
                    Container(
                      height: width / 2,
                      width: width / 2,
                      margin: const EdgeInsets.only(bottom: 30.0),
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                  'assets/images/tasks/bigger-smaller.jpg'),
                              fit: BoxFit.contain)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _number(exercise.number1), // left side
                        Container(
                          width: width / 7,
                          height: width / 7,
                          alignment: Alignment.topCenter,
                          margin: const EdgeInsets.symmetric(horizontal: 20.0),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: _selectedSign.isNotEmpty
                                    ? exercise.checkAnswer(_selectedSign)
                                        ? Colors.green
                                        : Colors.red
                                    : Colors.black38,
                                width: _selectedSign.isNotEmpty ? 2 : 1,
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5.0)),
                              boxShadow: [
                                BoxShadow(
                                  spreadRadius: 1.0,
                                  blurRadius: 1.0,
                                  color: _selectedSign.isNotEmpty
                                      ? exercise.checkAnswer(_selectedSign)
                                          ? Colors.green
                                          : Colors.red
                                      : Colors.black12,
                                ),
                              ]),
                          child: _selectedSign.isNotEmpty
                              ? Text(_selectedSign,
                                  style: const TextStyle(
                                      color: Colors.green,
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold))
                              : const Text(''),
                        ),
                        _number(exercise.number2), // right side
                      ],
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _sign(1, '>', _tapped1),
                        _sign(2, '=', _tapped2),
                        _sign(3, '<', _tapped3),
                      ],
                    ),
                  ],
                ),
              );
            } else {
              return const Column();
            }
          }),
        ),
      ),
    );
  }
}
