import 'package:flutter/material.dart';

import 'package:autism_mobile_app/domain/models/exercise_models/numbers_comparing.dart';

class NumberComparingTask extends StatelessWidget {
  const NumberComparingTask({super.key, required this.exercise});

  final NumbersComparingExercise exercise;

  Widget _number(int number) {
    return Text(
      number.toString(),
      style: const TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.w900,
        fontSize: 50,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _number(exercise.number1), // left side
        const SizedBox(
          width: 20.0,
        ),
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.black38,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
          ),
        ),
        const SizedBox(
          width: 20.0,
        ),
        _number(exercise.number2), // right side
      ],
    );
  }
}
