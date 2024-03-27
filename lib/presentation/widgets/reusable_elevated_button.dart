import 'package:flutter/material.dart';

class ReUsableElevatedButton extends StatelessWidget {
  const ReUsableElevatedButton(
      {super.key,
      required this.width,
      required this.title,
      required this.mark,
      required this.borderRadius,
      this.onPressed});

  final double width;
  final String title;
  final bool mark;
  final BorderRadiusGeometry borderRadius;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18,
          color: mark ? Colors.white : Colors.blue,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: mark ? Colors.blue : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
        fixedSize: Size.fromWidth(width / 2 - 15),
      ),
      onPressed: onPressed,
    );
  }
}
