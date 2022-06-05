import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gastosrecorrentes/components/dialogs/reset_password_dialog.dart';
import 'package:gastosrecorrentes/helpers/functions_helper.dart';
import 'package:gastosrecorrentes/models/user.dart';
import 'package:gastosrecorrentes/services/remote/firestore_service.dart';
import 'package:gastosrecorrentes/services/local/multi_language.dart';
import 'package:gastosrecorrentes/services/local/navigation_service.dart';

class UsersViewModel extends ChangeNotifier {
  AppUser? user;
  bool _isLoading = false;
  String? emailController = '';
  String? passwordController = '';

  final GlobalKey<FormState> _createUserFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _signUserInFormKey = GlobalKey<FormState>();

  get loading => _isLoading;
  get crateUserFormKey => _createUserFormKey;
  get signUserInFormKey => _signUserInFormKey;

  setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  createUser(context, {String? e, String? p, String? n}) async {
    if (_createUserFormKey.currentState!.validate()) {
      setLoading(true);
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(email: e!, password: p!);
        await FireStoreService.addUser(name: n!, email: e);
        showSnackBar(context, MultiLanguage.translate("userCreatedSuccessfully"));
        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          showSnackBar(context, MultiLanguage.translate("EMAIL_ALREADY_IN_USE"));
        }
      } catch (e) {
        showSnackBar(context, e.toString());
      } finally {
        setLoading(false);
      }
    }
  }

  Future signIn(context, {String? e, String? p}) async {
    if (_signUserInFormKey.currentState!.validate()) {
      setLoading(true);
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: e!, password: p!);
        await loadUserProfile(email: e);
        replaceToHomeScreen(context);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found' || e.code == 'wrong-password') {
          showSnackBar(context, MultiLanguage.translate("CREDENTIALS_NOT_FOUND"));
        }
      } catch (e) {
        showSnackBar(context, e.toString());
      } finally {
        setLoading(false);
      }
    }
  }

  Future loadUserProfile({String? email}) async {
    user = await FireStoreService.getUser(email: email!);
  }

  resetPasswordDialog(BuildContext context) async {
    return showDialog(context: context, builder: (context) => const ResetPasswordDialog());
  }
}
