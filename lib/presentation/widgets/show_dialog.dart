import 'package:flutter/material.dart';

class ShowDialog extends StatelessWidget {
  const ShowDialog(
      {required this.dialogMessage, required this.onPressed, Key? key})
      : super(key: key);

  final String dialogMessage;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'عذراً',
        textAlign: TextAlign.center,
      ),
      titleTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      content: Text(  
        dialogMessage,
        textAlign: TextAlign.center,
      ),
      contentTextStyle: const TextStyle(color: Colors.black, fontSize: 20),
      actions: [
        Center(
          child: ElevatedButton(
            child: const Text(
              'موافق',
              style: TextStyle(fontSize: 20),
            ),
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
