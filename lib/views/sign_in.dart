import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gastosrecorrentes/helpers/string_extensions.dart';
import 'package:gastosrecorrentes/services/multi_language.dart';
import 'package:gastosrecorrentes/services/navigation_service.dart';
import 'package:gastosrecorrentes/shared/text_styles.dart';
import 'package:gastosrecorrentes/view_models/users_view_model.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UsersViewModel usersViewModel = context.watch<UsersViewModel>();
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .7),
                  child: Form(
                    key: usersViewModel.signUserInFormKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          autofocus: true,
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(label: Text(MultiLanguage.translate("email"))),
                          validator: (val) {
                            if (!val!.isValidEmail) {
                              return MultiLanguage.translate("ENTER_VALID_EMAIL");
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          controller: _passwordController,
                          decoration: InputDecoration(label: Text(MultiLanguage.translate("password"))),
                          validator: (val) {
                            if (val!.isEmpty) {
                              return MultiLanguage.translate("CANT_BE_EMPTY");
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                        onTap: () => usersViewModel.resetPasswordDialog(context),
                        child: Text(MultiLanguage.translate("forgotPassword"), style: TextStyles.links())),
                    const Text(" | "),
                    GestureDetector(
                      onTap: () => openCreateUserPage(context),
                      child: Text(MultiLanguage.translate("createUser"), style: TextStyles.links()),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  child: usersViewModel.loading
                      ? Container(
                          width: 24,
                          height: 24,
                          padding: const EdgeInsets.all(2.0),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          ),
                        )
                      : Text(MultiLanguage.translate("logIn")),
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(6),
                    fixedSize: MaterialStateProperty.all(const Size.fromWidth(160)),
                  ),
                  onPressed: () =>
                      usersViewModel.signIn(context, e: _emailController.text, p: _passwordController.text),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
