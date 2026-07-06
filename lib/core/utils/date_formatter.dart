import 'package:intl/intl.dart';

abstract final class DateFormatter {
  static final DateFormat _display = DateFormat('d MMM yyyy');
  static final DateFormat _groupHeader = DateFormat('EEE d MMM');
  static final DateFormat _iso = DateFormat('yyyy-MM-dd');

  static String display(DateTime date) => _display.format(date);

  static String groupHeader(DateTime date) =>
      _groupHeader.format(date).toUpperCase();

  static String toIso(DateTime date) => _iso.format(date);

  static DateTime parseIso(String value) => _iso.parse(value);
}
