import 'package:flutter/material.dart';
import 'package:gastosrecorrentes/helpers/string_extensions.dart';
import 'package:gastosrecorrentes/view_models/init_app_view_model.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:time_machine/time_machine.dart';

class DateHelper {
  static String formatDDMM(LocalDate? date, context) {
    if (date == null) return '-/-';
    initializeDateFormatting();
    String formattedDate = DateFormat.yMd(Provider.of<InitAppViewModel>(context, listen: false).language)
        .format(date.toDateTimeUnspecified())
        .capitalizeFirst();
    List<String> dateUnits = formattedDate.split("/");
    return '${dateUnits[0]}/${dateUnits[1]}';
  }

  static String formatMMMMYYYY(LocalDate? date, BuildContext context) {
    if (date == null) return '-/-';
    initializeDateFormatting();
    String formattedDate = DateFormat.yMMMM(Provider.of<InitAppViewModel>(context, listen: false).language)
        .format(date.toDateTimeUnspecified())
        .capitalizeFirst();
    return formattedDate;
  }

  static String formatDDMMYYYY(LocalDate? date, BuildContext context) {
    if (date == null) return '-/-';
    initializeDateFormatting();
    String formattedDate = DateFormat.yMd(Provider.of<InitAppViewModel>(context, listen: false).language)
        .format(date.toDateTimeUnspecified())
        .capitalizeFirst();
    return formattedDate;
  }

  static String formatMMYY(LocalDate? date, BuildContext context) {
    if (date == null) return '-/-';
    initializeDateFormatting();
    String formattedDate = DateFormat.yM(Provider.of<InitAppViewModel>(context, listen: false).language)
        .format(date.toDateTimeUnspecified())
        .capitalizeFirst();
    return formattedDate.replaceAll("/20", "/");
  }

  static String formatMMYYYY(LocalDate? date, BuildContext context) {
    if (date == null) return '-/-';
    initializeDateFormatting();
    String formattedDate = DateFormat.yM(Provider.of<InitAppViewModel>(context, listen: false).language)
        .format(date.toDateTimeUnspecified())
        .capitalizeFirst();
    return formattedDate;
  }
}
