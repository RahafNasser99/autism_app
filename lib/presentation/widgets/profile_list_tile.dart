import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class ProfileListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final double iconSize;
  final double fontSize;
  final FontWeight fontWeight;
  final void Function() onTap;

  const ProfileListTile({
    Key? key,
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.iconSize,
    required this.fontSize,
    required this.fontWeight,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListTile(
        trailing: Icon(
          icon,
          color: iconColor,
          size: iconSize,
        ),
        title: AutoSizeText(
          title,
          textAlign: TextAlign.end,
          style: TextStyle(fontSize: fontSize, fontWeight: fontWeight),
        ),
        onTap: onTap,
      ),
    );
  }
}
