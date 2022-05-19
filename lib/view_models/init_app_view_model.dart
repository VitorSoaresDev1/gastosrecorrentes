import 'package:flutter/material.dart';
import 'package:gastosrecorrentes/components/dialogs/language_dialog.dart';
import 'package:gastosrecorrentes/services/locator.dart';
import 'package:gastosrecorrentes/services/multi_language.dart';
import 'package:provider/provider.dart';

import '../services/shared_preferences.dart';

class InitAppViewModel extends ChangeNotifier {
  bool loading = true;
  String? language;

  loadAppInitialConfigs(BuildContext context) async {
    setUpLocators();
    final preferences = context.watch<SharedPreferencesService>();
    await preferences.startSharedPreferences();
    language = await preferences.getLanguageChoice();
    //if (language == null) {
    await showLanguageDialog(context);
    //}
    await locator<MultiLanguage>().loadLanguageMap(language!);
    loading = false;
    notifyListeners();
  }

  showLanguageDialog(BuildContext context) async {
    await showDialog(context: context, barrierDismissible: false, builder: (context) => const LanguageDialog());
  }
}
