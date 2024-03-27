class DaysOfWeek {
  static const String sat = 'السبت';
  static const String sun = 'الأحد';
  static const String mon = 'الاثنين';
  static const String tue = 'الثلاثاء';
  static const String wed = 'الأربعاء';
  static const String thu = 'الخميس';
  static const String fri = 'الجمعة';

  String convert(String englishDay) {
    switch (englishDay) {
      case 'Sat':
        return sat;
      case 'Sun':
        return sun;
      case 'Mon':
        return mon;
      case 'Tue':
        return tue;
      case 'Wed':
        return wed;
      case 'Thu':
        return thu;
      case 'Fri':
        return fri;
    }
    return '';
  }
}
