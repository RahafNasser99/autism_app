import 'dart:async';

import 'package:flutter/material.dart';
import 'package:autism_mobile_app/domain/models/time_learning_models/waiting_time.dart';

class WaitingScreen extends StatefulWidget {
  const WaitingScreen({super.key});

  @override
  State<WaitingScreen> createState() => _WaitingScreenState();
}

class _WaitingScreenState extends State<WaitingScreen> {
  late Timer _timer;
  double leftMargin = 30.0;
  double scale = 0.0;

  @override
  void didChangeDependencies() {
    double allWidth = MediaQuery.of(context).size.width -
        (MediaQuery.of(context).size.width / 3) -
        60;
    scale = allWidth / WaitingTime.waitingTime;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timer.tick <= WaitingTime.waitingTime) {
        setState(() {
          leftMargin += scale;
        });
      } else {
        _timer.cancel();
        Navigator.of(context).pop();
      }
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          height: height,
          width: width,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/backgrounds/background1.PNG'),
                fit: BoxFit.contain),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: height / 4,
                width: width / 3,
                margin: EdgeInsets.only(left: leftMargin),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/waiting-time.png'),
                      fit: BoxFit.contain),
                ),
              ),
              Container(
                height: 5.0,
                margin: const EdgeInsets.symmetric(horizontal: 30),
                child: const LinearProgressIndicator(
                  value: 1,
                  valueColor: AlwaysStoppedAnimation(Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
