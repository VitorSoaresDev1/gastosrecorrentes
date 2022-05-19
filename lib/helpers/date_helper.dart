import 'package:gastosrecorrentes/helpers/string_helpers.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class DateHelper {
  static String formatDDMM(DateTime? date) {
    if (date == null) return '-/-';
    String day = date.day.toString();
    String month = date.month.toString();
    if (month.length < 2) {
      month = '0$month';
    }

    return '$day/$month';
  }

  static String formatMMMMYYYY(DateTime? date) {
    if (date == null) return '-/-';
    initializeDateFormatting();
    String formattedDate = StringHelper.capitalizeFirst(DateFormat.yMMMM('PT_BR').format(date));
    return formattedDate;
  }
}
