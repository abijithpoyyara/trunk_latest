import 'package:intl/intl.dart';

class BaseDates {
  DateTime date;
  DateFormat _dfmt;
  DateFormat _dfmt1;
  DateFormat _dfmtTime;
  DateFormat _fileDate;
  DateFormat _db;
  DateFormat _dbWithTime;
  DateFormat _time;

  BaseDates(
      this.date, {
        String day = "EEE",
        String dd = "dd",
        String month = "MMMM",
        String year = "yyyy",
      }) {
    if (date == null) {
      date = DateTime.now();
    }
    _dfmt = DateFormat("$dd $month  $year");
    _dfmt1 = DateFormat('dd-MM-yyyy');
    _dfmtTime = DateFormat(" $dd $month  $year hh:mm a");
    _time = DateFormat("hh:mm a");
    _db = new DateFormat('yyyy-MM-dd');
    _dbWithTime = new DateFormat('yyyy-MM-dd hh:mm:ss');
    _fileDate = new DateFormat('yyyy_MM_dd_hh_mm_ss');
  }

  String get format => date == null ? null : _dfmt.format(date);
  String get formatDate => date == null ? null : _dfmt1.format(date);

  String get formatTime => date == null ? null : _dfmtTime.format(date);

  String get timeFormat => date == null ? null : _time.format(date);

  String get dbformat => date == null ? null : _db.format(date);

  String get dbformatWithTime => date == null ? null : _dbWithTime.format(date);

  String get fileDateFormat => date == null ? null : _fileDate.format(date);

  static String findMonth(int month) {
    switch (month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return "";
    }
  }
}
