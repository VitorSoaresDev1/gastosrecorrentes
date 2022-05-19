import 'package:flutter/material.dart';
import 'package:gastosrecorrentes/views/sign_in.dart';

void openSignInPage(BuildContext context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => const SignInScreen()));
}
