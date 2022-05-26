import 'package:intl/intl.dart';

class CurrencyHelper {
  static String getSymbol() => 'R\$';

  static String formatDouble(double? value) {
    if (value == null) return 'Não informado';
    var formatter = NumberFormat("#,###.00", "pt_BR");

    return formatter.format(value);
  }
}
