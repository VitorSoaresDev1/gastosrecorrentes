import 'package:flutter/material.dart';
import 'package:gastosrecorrentes/services/local/multi_language.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(MultiLanguage.translate("activeBills")),
      ),
    );
  }
}
