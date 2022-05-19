class CurrencyHelper {
  static String getSymbol() => 'R\$';

  static String formatDouble(double? value) {
    if (value == null) return 'Não informado';
    String ammount = value.toStringAsFixed(2).replaceFirst(".", ",");
    return ammount;
  }
}
