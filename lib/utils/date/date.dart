class Date {
  final String comingDate;

  Date({required this.comingDate});

  DateTime handleDate() {
    List<String> splittedDate = comingDate.split('-');
    DateTime date = DateTime(int.parse(splittedDate[0]),
        int.parse(splittedDate[1]), int.parse(splittedDate[2]));
    return date;
  }

  DateTime handleTime(String comingTime) {
    List<String> splittedTime = comingTime.split(':');
    DateTime date = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        int.parse(splittedTime[0]),
        int.parse(splittedTime[1]));
    return date;
  }

  String getStringDate(DateTime date) {
    return (date.year).toString() +
        '/' +
        (date.month).toString() +
        '/' +
        (date.day).toString();
  }
}
