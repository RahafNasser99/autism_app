import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        children: <Widget>[
          SpinKitThreeInOut(itemBuilder: (BuildContext context, int index) {
            return DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: index.isEven ? Colors.blue : Colors.grey,
              ),
            );
          }),
          const AutoSizeText(
            'الرجاء الانتظار قليلاً',
            style: TextStyle(fontSize: 25, fontFamily: 'Mirza'),
          ),
        ],
      ),
    );
  }
}
