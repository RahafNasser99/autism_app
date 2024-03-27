import 'package:flutter/material.dart';
import 'package:autism_mobile_app/utils/date/time.dart';
import 'package:flutter_analog_clock/flutter_analog_clock.dart';

class AnalogTimeMatchingDetails extends StatelessWidget {
  const AnalogTimeMatchingDetails({super.key, required this.date});

  final String date;

  @override
  Widget build(BuildContext context) {
    return AnalogClock(
      isKeepTime: false,
      dateTime: Time(comingDuration: 0, comingTime: date).handleTime(),
      dialBorderWidthFactor: 0.08,
      dialColor: Colors.orange[50],
      dialBorderColor: Colors.blue,
      hourHandColor: Colors.green[600],
      minuteHandColor: Colors.orange,
      secondHandLengthFactor: 0.0,
      minuteHandWidthFactor: 2.5,
      hourHandWidthFactor: 1.5,
      hourNumberSizeFactor: 1.3,
      markingColor: Colors.transparent,
    );
  }
}
