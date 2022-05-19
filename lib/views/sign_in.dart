import 'package:flutter/material.dart';

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
                          decoration: const InputDecoration(
                            label: Text("E-mail"),
                          ),
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            label: Text("Senha"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text("Esqueci minha senha", style: TextStyle(decoration: TextDecoration.underline)),
                    Text(" | "),
                    Text("Criar usuário", style: TextStyle(decoration: TextDecoration.underline)),
                  ],
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(6),
                    fixedSize: MaterialStateProperty.all(const Size.fromWidth(160)),
                  ),
                  onPressed: () => {},
                  child: const Text("Entrar"),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
