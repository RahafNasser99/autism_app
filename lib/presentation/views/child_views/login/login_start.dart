// ignore_for_file: camel_case_types

import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';

class LoginStart extends StatefulWidget {
  const LoginStart({super.key});

  @override
  State<LoginStart> createState() => _LoginStart();
}

class _LoginStart extends State<LoginStart> {
  List<String> images = [
    'assets/images/start/start-1.png',
    'assets/images/start/start-2.jpg',
    'assets/images/start/start-3.jpg',
    'assets/images/start/start-4.jpg',
    'assets/images/start/start-5.jpg',
    'assets/images/start/start-6.jpg',
    'assets/images/start/start-7.jpg',
  ];

  var reBuildImage = true;
  Timer? timer;

  @override
  void didChangeDependencies() {
    if (reBuildImage) {
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {});
        if (timer.tick == 3) {
          timer.cancel();
          setState(() {
            reBuildImage = false;
          });
        }
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    const min = 0;
    int max = images.length - 1;
    int randomImage = min + Random().nextInt(max - min);
    String imageName = images[randomImage].toString();
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: reBuildImage
          ? Container(
              color: Colors.white,
              height: height,
              width: width,
              child: InkWell(
                child: ClipRRect(
                  child: Image.asset(imageName),
                ),
              ))
          : Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(imageName),
                  fit: BoxFit.fill,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    child: const Text('تسجيل الدخول'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      textStyle: const TextStyle(fontSize: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      fixedSize: Size.fromWidth(width - 40),
                    ),
                    onPressed: () {
                      Navigator.of(context)
                          .pushReplacementNamed('/login-screen');
                    },
                  ),
                ),
              ),
            ),
    );
  }
}
