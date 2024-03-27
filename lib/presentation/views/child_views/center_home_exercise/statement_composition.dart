import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:autism_mobile_app/presentation/widgets/loading.dart';
import 'package:autism_mobile_app/presentation/widgets/show_dialog.dart';
import 'package:autism_mobile_app/presentation/views/shared_views/empty_content.dart';
import 'package:autism_mobile_app/domain/models/exercise_models/statements_composition.dart';
import 'package:autism_mobile_app/presentation/cubits/exercise_cubits/cubit/exercise_cubit.dart';

class StatementComposition extends StatefulWidget {
  const StatementComposition({super.key, required this.taskPlace});

  final String taskPlace;

  @override
  State<StatementComposition> createState() => _StatementCompositionState();
}

class _StatementCompositionState extends State<StatementComposition> {
  bool _up = false;
  bool _isInit = true;
  late StatementCompositionExercise exercise;
  late int taskId;
  List<String> statement = [];
  List<String> solve = [];
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
          .getExercise('statement-composition', widget.taskPlace)
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

  Widget _word(int index, double width) {
    return TextButton(
      child: Text(statement[index].isNotEmpty ? statement[index] : '',
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: Colors.blue, fontSize: 20, fontWeight: FontWeight.bold)),
      style: TextButton.styleFrom(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          backgroundColor: (_seconds >= 10 &&
                  exercise.checkCurrentAnswer(solve) &&
                  statement[index] == exercise.answer[solve.length].toString())
              ? Colors.blue[100]
              : Colors.transparent),
      onPressed: () {
        String word = statement[index];
        if (statement[index].isNotEmpty) {
          setState(() {
            statement[index] = '';
            solve.add(word);
          });
        }

        if (exercise.checkAnswer(solve)) {
          _status = true;
          _sendAnswer();
          Future.delayed(const Duration(milliseconds: 600)).whenComplete(
              () => Navigator.of(context).popAndPushNamed('/bravo-screen'));
        } else if (exercise.checkCurrentAnswer(solve)) {
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
          color: (solve.isNotEmpty && index < solve.length)
              ? Colors.white
              : Colors.transparent,
          border: Border.all(
            color: (solve.isNotEmpty && index < solve.length)
                ? exercise.checkColor(solve, index)
                    ? Colors.green
                    : Colors.red
                : Colors.black45,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          boxShadow: [
            BoxShadow(
              color: (solve.isNotEmpty && index < solve.length)
                  ? exercise.checkColor(solve, index)
                      ? Colors.green
                      : Colors.red
                  : Colors.transparent,
              blurRadius: 1.0,
              spreadRadius: 1.0,
            )
          ],
        ),
        child: (solve.isNotEmpty && index <= (solve.length - 1))
            ? Text((solve[index]),
                style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 23,
                    fontWeight: FontWeight.bold))
            : const Text(''),
      ),
      onTap: () {
        int wordIndex = exercise.statement.indexOf((solve[index]));
        setState(() {
          statement[wordIndex] = solve[index];
          solve.removeAt(index);
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
            'تركيب الجمل',
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
                exercise = state.exercise as StatementCompositionExercise;
                taskId = state.taskId;
                statement.addAll(exercise.statement);
                if (exercise.statement.length > 6) {
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
                          'رتب الكلمات التالية لتكوّن جملة مفيدة',
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Center(
                        child: Container(
                          margin: const EdgeInsets.only(top: 30.0, bottom: 40),
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
                          margin: const EdgeInsets.only(bottom: 25.0),
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      'assets/images/tasks/ordering-words.jpg'),
                                  fit: BoxFit.contain)),
                        ),
                      ),
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: _up ? height / 3 : null,
                              child: GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: exercise.statement.length < 3
                                      ? exercise.statement.length
                                      : 3,
                                  crossAxisSpacing:
                                      exercise.statement.length < 3
                                          ? 20.0
                                          : 15.0,
                                  childAspectRatio:
                                      exercise.statement.length < 3 ? 3.0 : 1.7,
                                ),
                                shrinkWrap: true,
                                physics: const ScrollPhysics(),
                                itemCount: exercise.statement.length,
                                itemBuilder: (context, index) =>
                                    _word(index, width),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 15.0),
                              height: _up ? height / 3 : null,
                              child: GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: exercise.statement.length < 3
                                      ? exercise.statement.length
                                      : 3,
                                  childAspectRatio:
                                      exercise.statement.length < 3 ? 3.0 : 1.7,
                                  crossAxisSpacing:
                                      exercise.statement.length < 3
                                          ? 20.0
                                          : 15.0,
                                  mainAxisSpacing: exercise.statement.length < 3
                                      ? 0.0
                                      : 15.0,
                                ),
                                shrinkWrap: true,
                                physics: const ScrollPhysics(),
                                itemCount: exercise.statement.length,
                                itemBuilder: (context, index) =>
                                    _cell(index, width),
                              ),
                            ),
                          ],
                        ),
                      ),
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
