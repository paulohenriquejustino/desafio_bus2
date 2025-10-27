import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  static final DateFormat _displayFormat = DateFormat('dd/MM/yyyy HH:mm');

  static String format(DateTime dateTime) {
    return _displayFormat.format(dateTime.toLocal());
  }
}
