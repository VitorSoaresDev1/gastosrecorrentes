import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:gastosrecorrentes/services/local/locator.dart';

class MultiLanguage {
  Map<String, dynamic> languageMap = {};

  List<Locale> supportedLocales = [const Locale('en', 'US'), const Locale('pt', 'BR')];

  Future loadLanguageMap(String language) async {
    String locale = language;
    if (supportedLocales.map((e) => e.languageCode).contains(locale)) {
      await rootBundle
          .loadString("assets/languages/$locale.json")
          .then((value) => locator<MultiLanguage>().languageMap = jsonDecode(value));
    } else {
      await rootBundle
          .loadString("assets/languages/en.json")
          .then((value) => locator<MultiLanguage>().languageMap = jsonDecode(value));
    }
  }

  static translate(String? key, {List<String>? args}) {
    if (key == null) {
      return;
    }
    MultiLanguage appStrings = locator<MultiLanguage>();
    if (appStrings.languageMap.containsKey(key)) {
      if (args == null) {
        return appStrings.languageMap[key];
      } else {
        String returnedString = appStrings.languageMap[key];
        do {
          returnedString = returnedString.replaceFirst("{}", args[0]);
          args.removeAt(0);
        } while (returnedString.contains("{}"));
        return returnedString;
      }
    } else {
      return key;
    }
  }

  static plural(String? key, int amount) {
    if (key == null) {
      return;
    }
    MultiLanguage appStrings = locator<MultiLanguage>();
    if (appStrings.languageMap.containsKey(key)) {
      String subKey = (amount != 1) ? "plural" : "singular";
      String translation;
      dynamic keyValue = appStrings.languageMap[key];
      translation = keyValue is String ? appStrings.languageMap[key] : appStrings.languageMap[key][subKey];
      return translation;
    } else {
      return key;
    }
  }
}
