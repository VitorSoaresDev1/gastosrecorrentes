import 'package:flutter/material.dart';
import 'package:gastosrecorrentes/services/local/multi_language.dart';
import 'package:gastosrecorrentes/services/local/shared_preferences.dart';
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
  void initState() {
    final initAppViewModel = Provider.of<InitAppViewModel>(context, listen: false);
    if (initAppViewModel.language != null) {
      if (initAppViewModel.language.contains("en")) {
        groupVal = 1;
      } else if (initAppViewModel.language.contains("pt")) {
        groupVal = 2;
      }
    }
    super.initState();
  }

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
              onChanged: (value) => setRadioOption(value),
              activeColor: Colors.indigo,
            ),
            onTap: () => setRadioOption(1),
          ),
          ListTile(
              title: const Text("Portugues"),
              leading: Radio(
                value: 2,
                groupValue: groupVal,
                onChanged: (value) => setRadioOption(value),
                activeColor: Colors.indigo,
              ),
              onTap: () => setRadioOption(2)),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () async {
            if (groupVal == 0) {
              chosenLanguage = 'pt';
              await preferences.setlanguage(chosenLanguage);
              initAppViewModel.language = chosenLanguage;
              Navigator.pop(context);
            } else {
              Navigator.pop(context);
            }
          },
          child: Text(MultiLanguage.translate("cancel")),
        ),
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
          child: Text(MultiLanguage.translate("confirm")),
        ),
      ],
    );
  }

  void setRadioOption(Object? value) {
    switch (value) {
      case 1:
        chosenLanguage = 'en';
        break;
      case 2:
        chosenLanguage = 'pt';
        break;
      default:
    }
    setState(() {
      groupVal = value as int;
      chosenLanguage;
    });
  }
}
