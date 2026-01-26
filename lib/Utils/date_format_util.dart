import 'package:intl/intl.dart';

abstract class DateFormatUtil {
  static String dateFormat(String date) {
    DateTime dateTime = DateTime.parse(date);

    var dateFormat = DateFormat.yMMMd().format(dateTime);
    return dateFormat;
  }
}
