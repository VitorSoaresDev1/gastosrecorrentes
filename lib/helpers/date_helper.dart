import 'package:gastosrecorrentes/helpers/string_extensions.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:time_machine/time_machine.dart';

class DateHelper {
  static String formatDDMM(LocalDate? date) {
    if (date == null) return '-/-';
    String day = date.dayOfMonth.toString();
    String month = date.monthOfYear.toString();
    if (day.length < 2) {
      day = '0$day';
    }
    if (month.length < 2) {
      month = '0$month';
    }

    return '$day/$month';
  }

  static String formatMMMMYYYY(LocalDate? date) {
    if (date == null) return '-/-';
    initializeDateFormatting();
    String formattedDate = DateFormat.yMMMM('PT_BR').format(date.toDateTimeUnspecified()).capitalizeFirst();
    return formattedDate;
  }

  static String formatDDMMYYYY(LocalDate? date) {
    if (date == null) return '-/-';
    initializeDateFormatting();
    String formattedDate = DateFormat.yMd('PT_BR').format(date.toDateTimeUnspecified()).capitalizeFirst();
    return formattedDate;
  }

  static String formatMMYY(LocalDate? date) {
    if (date == null) return '-/-';
    initializeDateFormatting();
    String formattedDate = DateFormat.yM('PT_BR').format(date.toDateTimeUnspecified()).capitalizeFirst();
    return formattedDate.replaceAll("/20", "/");
  }
}
