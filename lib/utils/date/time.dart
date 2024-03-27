class Time {
  final int comingDuration;
  final String comingTime;

  Time({required this.comingDuration, required this.comingTime});

  String handleTimeDisplay() {
    List<String> splittedDate = comingTime.split(':');
    int comingHour = int.parse(splittedDate[0]);
    int comingMinute = int.parse(splittedDate[1]);
    String time;
    String timeShift;

    if (comingHour > 12) {
      timeShift = ' مساءً';
      comingHour -= 12;
    } else if (comingHour == 12) {
      timeShift = ' مساءً';
    } else {
      timeShift = ' صباحاً';
    }

    if (comingHour.toString().length == 1) {
      time = '0' + comingHour.toString();
    } else {
      time = comingHour.toString();
    }

    if (comingMinute.toString().length == 1) {
      time += ':0' + comingMinute.toString();
    } else {
      time += ':' + comingMinute.toString();
    }

    return time + timeShift;
  }

  String handleDurationDisplay() {
    int hours = comingDuration ~/ 60;
    int minutes = comingDuration % 60;
    String duration;

    if (hours == 0) {
      if (minutes.toString().length == 1) {
        duration = '00:0' + minutes.toString();
      } else {
        duration = '00:' + minutes.toString();
      }
    } else {
      if (hours.toString().length == 1) {
        if (minutes.toString().length == 1) {
          duration = '0' + hours.toString() + ':0' + minutes.toString();
        } else {
          duration = '0' + hours.toString() + ':' + minutes.toString();
        }
      } else {
        if (minutes.toString().length == 1) {
          duration = hours.toString() + ':0' + minutes.toString();
        } else {
          duration = hours.toString() + ':' + minutes.toString();
        }
      }
    }
    return duration;
  }

  DateTime handleTime() {
    List<String> splittedDate = comingTime.split(':');
    DateTime date = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        int.parse(splittedDate[0]),
        int.parse(splittedDate[1]));
    return date;
  }

  DateTime handleDuration() {
    List<String> splittedDate = comingTime.split(':');
    DateTime date = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        int.parse(splittedDate[0]),
        int.parse(splittedDate[1]),
        int.parse(splittedDate[2]));

    date = date.add(
        Duration(hours: comingDuration ~/ 60, minutes: comingDuration % 60));

    return date;
  }
}
