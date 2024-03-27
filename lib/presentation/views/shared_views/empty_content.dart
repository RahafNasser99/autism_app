import 'package:flutter/material.dart';

class EmptyContent extends StatelessWidget {
  const EmptyContent({super.key, required this.text, required this.width});

  final String text;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: width / 4.0),
      child:
          Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        Icon(
          Icons.sentiment_dissatisfied,
          color: Colors.blue,
          size: width / 2.0,
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 28),
        ),
      ]),
    );
  }
}
