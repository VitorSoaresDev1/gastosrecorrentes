import 'package:flutter/material.dart';

void replaceToSignInPage(BuildContext context) {
  Navigator.pushReplacementNamed(context, '/signIn');
}

void openCreateUserPage(BuildContext context) {
  Navigator.pushNamed(context, '/createUser');
}

void replaceToHomeScreen(BuildContext context) {
  Navigator.pushReplacementNamed(context, '/homeScreen');
}
