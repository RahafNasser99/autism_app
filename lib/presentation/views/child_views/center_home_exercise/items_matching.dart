import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:autism_mobile_app/presentation/widgets/loading.dart';
import 'package:autism_mobile_app/presentation/widgets/show_dialog.dart';
import 'package:autism_mobile_app/domain/models/exercise_models/items_matching.dart';
import 'package:autism_mobile_app/presentation/views/shared_views/empty_content.dart';
import 'package:autism_mobile_app/presentation/cubits/exercise_cubits/cubit/exercise_cubit.dart';

class ItemsMatching extends StatefulWidget {
  const ItemsMatching({super.key, required this.taskPlace});

  final String taskPlace;

  @override
  State<ItemsMatching> createState() => _ItemsMatchingState();
}

class _ItemsMatchingState extends State<ItemsMatching> {
  bool _isInit = true;
  late ItemsMatchingExercise exercise;
  late int taskId;
  bool _onTapped = false;
  int _selectedImage = -1;
  int _wrongAnswerCount = 0;
  int duration = 0;
  late DateTime _startDate;
  late DateTime _finishDate;
  bool _status = false;
  bool sendAnswer = false;
  Timer? _timer;
  double _innerWidth = 0.0;
  int _seconds = 0;

  @override
  Future<void> didChangeDependencies() async {
    if (_isInit) {
      await BlocProvider.of<ExerciseCubit>(context)
          .getMatchingExercise(widget.taskPlace)
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

  Widget _comparedImage(String imageUrl) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(
            Radius.circular(5.0),
          ),
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.contain,
          ),
          boxShadow: [
            BoxShadow(
              color: !_selectedImage.isNegative &&
                      exercise.checkAnswer(_selectedImage)
                  ? Colors.green
                  : Colors.white,
              blurRadius: 3.0,
              spreadRadius: 3.0,
            )
          ]),
    );
  }

  Widget _image(int index, ItemsMatchingExercise itemsMatchingExercise) {
    return InkWell(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(5.0),
          ),
          image: DecorationImage(
            image: NetworkImage(itemsMatchingExercise.itemsUrl[index]),
            fit: BoxFit.contain,
            colorFilter:
                (_seconds >= 10 && (index + 1) == itemsMatchingExercise.answer)
                    ? ColorFilter.mode(Colors.blue[700]!, BlendMode.color)
                    : null,
          ),
          boxShadow: _onTapped
              ? [
                  BoxShadow(
                    color: index == _selectedImage
                        ? (_onTapped && exercise.checkAnswer(_selectedImage))
                            ? Colors.green
                            : Colors.red
                        : Colors.transparent,
                    blurRadius: 3.0,
                    spreadRadius: 3.0,
                  )
                ]
              : [],
        ),
      ),
      onTap: () async {
        setState(() {
          _onTapped = true;
          _selectedImage = index;
        });
        if (exercise.checkAnswer(_selectedImage)) {
          _status = true;
          _sendAnswer();
          Future.delayed(const Duration(milliseconds: 600)).whenComplete(
              () => Navigator.of(context).popAndPushNamed('/bravo-screen'));
        } else {
          _status = false;
          _wrongAnswerCount++;
          setState(() {
            _seconds = 0;
            _innerWidth = 0.0;
          });
        }
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
        await _sendAnswer();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 2.0,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: const Text(
            'تشابه الصور',
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
                exercise = state.exercise as ItemsMatchingExercise;
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
            },
            builder: (context, state) {
              if (state is ExerciseLoading) {
                return const Loading();
              } else if (state is ExerciseEmpty) {
                return EmptyContent(text: 'لا يوجد تمارين', width: width);
              } else if (state is ExerciseDone) {
                return SingleChildScrollView(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        const Align(
                          alignment: Alignment.topRight,
                          child: AutoSizeText(
                            'اضغط على الصورة المماثلة',
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Center(
                          child: Container(
                            margin:
                                const EdgeInsets.only(top: 30.0, bottom: 50),
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
                        SizedBox(
                          width: width / 3.5,
                          height: width / 3.5,
                          child: _comparedImage(exercise.mainItem),
                        ),
                        const SizedBox(
                          height: 40.0,
                        ),
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 1,
                              crossAxisSpacing: 18.0,
                            ),
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            itemCount: exercise.itemsUrl.length,
                            itemBuilder: (context, index) =>
                                _image(index, exercise),
                          ),
                        )
                      ],
                    ),
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
