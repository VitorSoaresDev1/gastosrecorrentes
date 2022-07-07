import 'package:intl/intl.dart';

class CurrencyHelper {
  static String getSymbol() => 'R\$';

  static String formatDouble(double? value) {
    if (value == null) return 'Não informado';
    var formatter = NumberFormat("#,###.00", "pt_BR");

    return value == 0.0 ? '0,00' : formatter.format(value);
  }
}
