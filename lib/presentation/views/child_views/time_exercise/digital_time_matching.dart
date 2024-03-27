import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_analog_clock/flutter_analog_clock.dart';

import 'package:autism_mobile_app/utils/date/time.dart';
import 'package:autism_mobile_app/domain/models/time_learning_models/time_exercise.dart';
import 'package:autism_mobile_app/presentation/cubits/exercise_cubits/cubit/send_time_exercise_answer_cubit.dart';

class DigitalTimeMatching extends StatefulWidget {
  const DigitalTimeMatching({super.key, required this.timeExercise});

  final TimeExercise timeExercise;

  @override
  State<DigitalTimeMatching> createState() => _DigitalTimeMatchingState();
}

class _DigitalTimeMatchingState extends State<DigitalTimeMatching> {
  bool _isInit = true;
  int _wrongAnswerCount = 0;
  late DateTime _startDate;
  late DateTime _finishDate;
  int duration = 0;
  bool _status = false;
  int _selectedTime = -1;
  Timer? _timer;
  double _innerWidth = 0.0;
  int _seconds = 0;

  @override
  Future<void> didChangeDependencies() async {
    if (_isInit) {
      _startDate = DateTime.now();
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
    await BlocProvider.of<SendTimeExerciseAnswerCubit>(context).postExerciseAnswer(
        widget.timeExercise.id, _status, duration, _wrongAnswerCount);
  }

  Widget _digitalClock(int index, String time) {
    return InkWell(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 3.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: (_seconds >= 10 && (index + 1) == widget.timeExercise.answer)
                ? Colors.blue[100]
                : Colors.white,
            border: Border.all(
              color: _selectedTime != index
                  ? Colors.black26
                  : widget.timeExercise.checkAnswer(index + 1)
                      ? Colors.green
                      : Colors.red,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            boxShadow: [
              BoxShadow(
                spreadRadius: 1.0,
                blurRadius: 2.0,
                color: _selectedTime != index
                    ? Colors.white
                    : widget.timeExercise.checkAnswer(index + 1)
                        ? Colors.green
                        : Colors.red,
              )
            ]),
        child: Text(
          time,
          style: const TextStyle(
            color: Colors.blue,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      onTap: () {
        setState(() {
          _selectedTime = index;
        });
        if (!widget.timeExercise.checkAnswer(index + 1)) {
          _wrongAnswerCount++;
          _status = false;
          setState(() {
            _seconds = 0;
            _innerWidth = 0.0;
          });
        } else {
          _status = true;
          _sendAnswer();
          Future.delayed(const Duration(milliseconds: 600)).whenComplete(
              () => Navigator.of(context).popAndPushNamed('/bravo-screen'));
        }
      },
    );
  }

  Widget _analogClock() {
    return AnalogClock(
      isKeepTime: false,
      dateTime:
          Time(comingDuration: 0, comingTime: widget.timeExercise.mainTime)
              .handleTime(),
      dialBorderWidthFactor: 0.08,
      dialColor: Colors.orange[50],
      dialBorderColor: Colors.blue,
      hourHandColor: Colors.green[600],
      minuteHandColor: Colors.orange,
      secondHandLengthFactor: 0.0,
      minuteHandWidthFactor: 2.5,
      hourHandWidthFactor: 1.5,
      hourNumberSizeFactor: 1.3,
      markingColor: Colors.transparent,
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
            'مطابقة الوقت',
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
          child: Column(
            children: <Widget>[
              const Align(
                alignment: Alignment.topRight,
                child: AutoSizeText(
                  'اضغط على الساعة المطابقة للوقت',
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
              SizedBox(
                height: width / 2.2,
                width: width / 2.2,
                child: _analogClock(),
              ),
              const SizedBox(
                height: 60.0,
              ),
              GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 2,
                  crossAxisSpacing: 15.0,
                ),
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemCount: widget.timeExercise.options.length,
                itemBuilder: (context, index) =>
                    _digitalClock(index, widget.timeExercise.options[index]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
