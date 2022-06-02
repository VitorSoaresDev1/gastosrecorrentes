import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gastosrecorrentes/helpers/functions_helper.dart';
import 'package:gastosrecorrentes/view_models/users_view_model.dart';
import 'package:gastosrecorrentes/views/bill_details_screen.dart';
import 'package:gastosrecorrentes/views/create_bill_screen.dart';
import 'package:gastosrecorrentes/views/create_user_screen.dart';
import 'package:gastosrecorrentes/views/home_screen.dart';
import 'package:gastosrecorrentes/views/init_app.dart';
import 'package:gastosrecorrentes/views/sign_in.dart';
import 'package:provider/provider.dart';

Map<String, Widget Function(BuildContext)> availableRoutes = {
  '/': (context) => const InitApp(),
  '/signIn': (context) => const SignInScreen(),
  '/homeScreen': (context) => const HomeScreen(),
  '/createUser': (context) => const CreateUserScreen(),
  '/createBill': (context) => const CreateBillScreen(),
  '/billDetails': (context) => const BillDetailsScreen(),
};

void replaceToSignInScreen(BuildContext context) => Navigator.pushReplacementNamed(context, '/signIn');

void replaceToHomeScreen(BuildContext context) => Navigator.pushReplacementNamed(context, '/homeScreen');

void openCreateUserScreen(BuildContext context) => Navigator.pushNamed(context, '/createUser');

void openCreateBillScreen(BuildContext context) => Navigator.pushNamed(context, '/createBill');

void openBillDetailsScreen(BuildContext context) => Navigator.pushNamed(context, '/billDetails');

void navigateToInitialScreen(BuildContext context) {
  final usersViewModel = context.watch<UsersViewModel>();
  User? firebaseUser = FirebaseAuth.instance.currentUser;
  if (firebaseUser == null) {
    scheduleCall(() {
      replaceToSignInScreen(context);
    });
  } else {
    scheduleCall(() async {
      await usersViewModel.loadUserProfile(email: firebaseUser.email);
      replaceToHomeScreen(context);
    });
  }
}
