import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gastosrecorrentes/helpers/functions_helper.dart';
import 'package:gastosrecorrentes/helpers/string_extensions.dart';
import 'package:gastosrecorrentes/services/local/multi_language.dart';

class ResetPasswordDialog extends StatefulWidget {
  const ResetPasswordDialog({Key? key}) : super(key: key);

  @override
  _ResetPasswordDialogState createState() => _ResetPasswordDialogState();
}

class _ResetPasswordDialogState extends State<ResetPasswordDialog> {
  late TextEditingController _emailController;
  final GlobalKey<FormState> _resetPasswordFormKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(MultiLanguage.translate("resetPassword")),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Form(
            key: _resetPasswordFormKey,
            child: TextFormField(
              autofocus: true,
              controller: _emailController,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(label: Text(MultiLanguage.translate("email"))),
              validator: (val) {
                if (!val!.isValidEmail) {
                  return MultiLanguage.translate("ENTER_VALID_EMAIL");
                }
                return null;
              },
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () async {
            if (_resetPasswordFormKey.currentState!.validate()) {
              try {
                await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text);
                showSnackBar(context, MultiLanguage.translate("resetPasswordEmailSent"));
                Navigator.pop(context);
              } on FirebaseAuthException catch (e) {
                if (e.code == 'user-not-found') {
                  showSnackBar(context, MultiLanguage.translate("USER_NOT_FOUND"));
                }
              } catch (e) {
                showSnackBar(context, e.toString());
              }
            }
          },
          child: Text(MultiLanguage.translate("confirm")),
        )
      ],
    );
  }
}
