import 'package:flutter/material.dart';
import 'package:gastosrecorrentes/services/remote/firebase_auth_service.dart';
import 'package:provider/provider.dart';

import 'package:gastosrecorrentes/components/dialogs/language_dialog.dart';
import 'package:gastosrecorrentes/services/local/locator.dart';
import 'package:gastosrecorrentes/services/local/multi_language.dart';

import '../services/local/shared_preferences.dart';

class InitAppViewModel extends ChangeNotifier {
  bool _loading = true;
  String? _language;
  FirebaseAuthService firebaseAuthService;

  InitAppViewModel({
    required this.firebaseAuthService,
  });

  get loading => _loading;
  get language => _language;

  set language(value) => _language = value;

  loadAppInitialConfigs(BuildContext context) async {
    setUpLocators();
    final preferences = context.watch<SharedPreferencesService>();
    await preferences.startSharedPreferences();
    if (await preferences.isFirstTimeAppOpenning()) {
      if (firebaseAuthService.currentUser() != null) {
        await firebaseAuthService.signOut();
      }
    }
    _language = await preferences.getLanguageChoice();
    if (_language == null) {
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
