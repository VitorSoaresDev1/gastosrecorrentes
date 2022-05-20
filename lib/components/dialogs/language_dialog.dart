import 'package:flutter/material.dart';
import 'package:gastosrecorrentes/services/shared_preferences.dart';
import 'package:gastosrecorrentes/view_models/init_app_view_model.dart';
import 'package:provider/provider.dart';

class LanguageDialog extends StatefulWidget {
  const LanguageDialog({Key? key}) : super(key: key);

  @override
  _LanguageDialogState createState() => _LanguageDialogState();
}

class _LanguageDialogState extends State<LanguageDialog> {
  int groupVal = 0;
  String? chosenLanguage;
  @override
  Widget build(BuildContext context) {
    final preferences = context.watch<SharedPreferencesService>();
    final initAppViewModel = context.watch<InitAppViewModel>();
    return AlertDialog(
      title: const Text("Language:"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text("English"),
            leading: Radio(
              value: 1,
              groupValue: groupVal,
              onChanged: (value) {
                setState(() {
                  groupVal = value as int;
                  chosenLanguage = 'en_US';
                });
              },
              activeColor: Colors.indigo,
            ),
          ),
          ListTile(
            title: const Text("Portugues"),
            leading: Radio(
              value: 2,
              groupValue: groupVal,
              onChanged: (value) {
                setState(() {
                  groupVal = value as int;
                  chosenLanguage = 'pt_BR';
                });
              },
              activeColor: Colors.indigo,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () async {
            if (groupVal == 0) {
              chosenLanguage = null;
            } else {
              await preferences.setlanguage(chosenLanguage);
              initAppViewModel.language = chosenLanguage;
              Navigator.pop(context);
            }
          },
          child: const Text("Confirm"),
        ),
      ],
    );
  }
}
