import 'package:flutter/material.dart';
import 'package:gastosrecorrentes/components/dialogs/language_dialog.dart';
import 'package:gastosrecorrentes/services/locator.dart';
import 'package:gastosrecorrentes/services/multi_language.dart';
import 'package:provider/provider.dart';

import '../services/shared_preferences.dart';

class InitAppViewModel extends ChangeNotifier {
  bool _loading = true;
  String? _language;

  get loading => _loading;

  set language(value) => _language = value;
  get language => _language;

  loadAppInitialConfigs(BuildContext context) async {
    setUpLocators();
    final preferences = context.watch<SharedPreferencesService>();
    await preferences.startSharedPreferences();
    _language = await preferences.getLanguageChoice();
    if (language == null) {
      await _showLanguageDialog(context);
    }
    await locator<MultiLanguage>().loadLanguageMap(_language!);
    _loading = false;
    notifyListeners();
  }

  _showLanguageDialog(BuildContext context) async {
    await showDialog(context: context, barrierDismissible: false, builder: (context) => const LanguageDialog());
  }
}
