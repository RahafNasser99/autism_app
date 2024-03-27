import 'package:flutter/material.dart';

class DigitalTimeMatchingDetails extends StatelessWidget {
  const DigitalTimeMatchingDetails({super.key, required this.time});

  final String time;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 3.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black26,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
      ),
      child: Text(
        time,
        style: const TextStyle(
          color: Colors.blue,
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
