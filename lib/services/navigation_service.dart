import 'package:flutter/material.dart';

void replaceToSignInScreen(BuildContext context) {
  Navigator.pushReplacementNamed(context, '/signIn');
}

void openCreateUserScreen(BuildContext context) {
  Navigator.pushNamed(context, '/createUser');
}

void openCreateBillScreen(BuildContext context) {
  Navigator.pushNamed(context, '/createUser');
}

void replaceToHomeScreen(BuildContext context) {
  Navigator.pushReplacementNamed(context, '/homeScreen');
}
