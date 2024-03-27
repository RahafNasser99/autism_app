// ignore_for_file: file_names

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class ReUsableListTile extends StatelessWidget {
  const ReUsableListTile(
      {Key? key, required this.title, required this.icon, required this.onTap})
      : super(key: key);

  final String title;
  final IconData icon;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue,
      margin: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: ListTile(
        iconColor: Colors.white,
        leading: Icon(icon),
        title: AutoSizeText(
          title,
          textAlign: TextAlign.end,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
