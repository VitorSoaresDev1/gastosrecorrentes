import 'package:flutter/material.dart';

class TextStyles {
  static TextStyle links() => const TextStyle(decoration: TextDecoration.underline);

  static TextStyle titles({bool? light}) =>
      TextStyle(color: light ?? false ? Colors.white : Colors.grey[900], fontSize: 24, fontWeight: FontWeight.w800);

  static TextStyle titles2({bool? light}) =>
      TextStyle(color: light ?? false ? Colors.white : Colors.grey[900], fontSize: 18, fontWeight: FontWeight.w600);

  static TextStyle bodyText({bool? light}) =>
      TextStyle(color: light ?? false ? Colors.white : Colors.grey[900], fontSize: 16, fontWeight: FontWeight.w500);

  static TextStyle bodyText2({bool? light}) =>
      TextStyle(color: light ?? false ? Colors.white : Colors.grey[900], fontSize: 14, fontWeight: FontWeight.w500);

  static TextStyle bodySubtitle({bool? light}) =>
      TextStyle(color: light ?? false ? Colors.white : Colors.grey[900], fontSize: 13, fontWeight: FontWeight.w400);
}
