import 'package:flutter/material.dart';
import 'package:gastosrecorrentes/services/multi_language.dart';
import 'package:gastosrecorrentes/shared/text_styles.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          autofocus: true,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            label: Text(MultiLanguage.translate("email")),
                          ),
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            label: Text(MultiLanguage.translate("password")),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(MultiLanguage.translate("forgotPassword"), style: TextStyles.links()),
                    const Text(" | "),
                    Text(MultiLanguage.translate("createUser"), style: TextStyles.links()),
                  ],
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(6),
                    fixedSize: MaterialStateProperty.all(const Size.fromWidth(160)),
                  ),
                  onPressed: () => {},
                  child: Text(MultiLanguage.translate("logIn")),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
