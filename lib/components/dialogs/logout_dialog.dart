import 'package:flutter/material.dart';
import 'package:gastosrecorrentes/services/local/multi_language.dart';
import 'package:gastosrecorrentes/view_models/users_view_model.dart';
import 'package:provider/provider.dart';

class LogOutDialog extends StatefulWidget {
  const LogOutDialog({Key? key}) : super(key: key);

  @override
  _LogOutDialogState createState() => _LogOutDialogState();
}

class _LogOutDialogState extends State<LogOutDialog> {
  @override
  Widget build(BuildContext context) {
    final usersViewModel = context.watch<UsersViewModel>();
    return AlertDialog(
      title: Text(MultiLanguage.translate("logOut")),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [Text(MultiLanguage.translate("logOutExplain"))],
      ),
      actions: [
        TextButton(
          onPressed: () async {
            Navigator.pop(context);
          },
          child: Text(MultiLanguage.translate("cancel")),
        ),
        TextButton(
          onPressed: () async {
            Navigator.pop(context);
            await usersViewModel.signOut(context);
          },
          child: Text(MultiLanguage.translate("confirm")),
        ),
      ],
    );
  }
}
