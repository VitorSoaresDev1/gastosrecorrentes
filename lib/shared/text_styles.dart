import 'package:flutter/material.dart';

class TextStyles {
  static TextStyle titles() => TextStyle(color: Colors.grey[900], fontSize: 24, fontWeight: FontWeight.w800);
  static TextStyle titles2() => TextStyle(color: Colors.grey[900], fontSize: 18, fontWeight: FontWeight.w600);
  static TextStyle bodyText() => TextStyle(color: Colors.grey[900], fontSize: 16, fontWeight: FontWeight.w500);
  static TextStyle bodySubtitle() => TextStyle(color: Colors.grey[900], fontSize: 14, fontWeight: FontWeight.w400);
  static TextStyle links() => const TextStyle(decoration: TextDecoration.underline);
}
