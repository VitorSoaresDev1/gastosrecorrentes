import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gastosrecorrentes/components/dialogs/reset_password_dialog.dart';
import 'package:gastosrecorrentes/helpers/functions_helper.dart';
import 'package:gastosrecorrentes/models/user.dart';
import 'package:gastosrecorrentes/services/remote/firebase_auth_service.dart';
import 'package:gastosrecorrentes/services/remote/firestore_service.dart';
import 'package:gastosrecorrentes/services/local/multi_language.dart';
import 'package:gastosrecorrentes/services/local/navigation_service.dart';

class UsersViewModel extends ChangeNotifier {
  AppUser? user;
  bool _isLoading = false;
  String? emailController = '';
  String? passwordController = '';
  FirebaseAuthService firebaseAuthService;

  UsersViewModel({required this.firebaseAuthService}) {
    firebaseAuthService = firebaseAuthService;
  }

  final GlobalKey<FormState> _createUserFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _signUserInFormKey = GlobalKey<FormState>();

  get loading => _isLoading;
  get crateUserFormKey => _createUserFormKey;
  get signUserInFormKey => _signUserInFormKey;

  setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  createUser(context, {required String email, required String password, required String name}) async {
    if (_createUserFormKey.currentState!.validate()) {
      setLoading(true);
      try {
        await firebaseAuthService.createUser(email: email, password: password);
        await FireStoreService.addUser(name: name, email: email);
        showSnackBar(MultiLanguage.translate("userCreatedSuccessfully"));
        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          showSnackBar(MultiLanguage.translate("EMAIL_ALREADY_IN_USE"));
        }
      } catch (e) {
        showSnackBar(e.toString());
      } finally {
        setLoading(false);
      }
    }
  }

  Future signIn(context, {required String email, required String password}) async {
    if (_signUserInFormKey.currentState!.validate()) {
      setLoading(true);
      try {
        await firebaseAuthService.signIn(email: email, password: password);
        await loadUserProfile(email: email);
        NavigationService.replaceToHomeScreen(context);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found' || e.code == 'wrong-password') {
          showSnackBar(translateErrors("CREDENTIALS_NOT_FOUND"));
        } else if (e.code == 'network-request-failed') {
          showSnackBar(translateErrors("no_network_connection"));
        }
      } catch (e) {
        showSnackBar(e.toString());
      } finally {
        setLoading(false);
      }
    }
  }

  Future loadUserProfile({String? email}) async {
    user = await FireStoreService.getUser(email: email!);
  }

  resetPasswordDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => ResetPasswordDialog(firebaseAuthService: firebaseAuthService),
    );
  }
}
