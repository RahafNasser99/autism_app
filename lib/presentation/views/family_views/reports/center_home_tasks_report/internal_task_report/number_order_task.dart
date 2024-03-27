import 'package:flutter/material.dart';

class NumberOrderingTask extends StatelessWidget {
  const NumberOrderingTask({super.key, required this.numbers});

  final List<int> numbers;

  Widget _cell(int number) {
    return Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.blue[50],
          border: Border.all(
            color: Colors.blue[50]!,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
        ),
        child: Text(number.toString(),
            style: const TextStyle(
                color: Colors.blue,
                fontSize: 25,
                fontWeight: FontWeight.bold)));
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: numbers.length < 5 ? numbers.length : 5,
        crossAxisSpacing: numbers.length < 5 ? 20.0 : 15.0,
        childAspectRatio: numbers.length <= 2 ? 3 : 1.7,
        mainAxisSpacing: numbers.length < 5 ? 20.0 : 15.0,
      ),
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      itemCount: numbers.length,
      itemBuilder: (context, index) => _cell(numbers[index]),
    );
  }
}
