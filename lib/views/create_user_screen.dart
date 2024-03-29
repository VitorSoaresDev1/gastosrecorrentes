import 'package:flutter/material.dart';
import 'package:gastosrecorrentes/components/shared/button_with_loading.dart';
import 'package:gastosrecorrentes/helpers/string_extensions.dart';
import 'package:gastosrecorrentes/services/local/multi_language.dart';
import 'package:gastosrecorrentes/view_models/users_view_model.dart';
import 'package:provider/provider.dart';

class CreateUserScreen extends StatefulWidget {
  const CreateUserScreen({Key? key}) : super(key: key);

  @override
  State<CreateUserScreen> createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UsersViewModel usersViewModel = context.watch<UsersViewModel>();

    return Scaffold(
      appBar: AppBar(title: Text(MultiLanguage.translate("createUser"))),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SafeArea(
            bottom: true,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CreateUserForm(
                    usersViewModel: usersViewModel,
                    nameController: _nameController,
                    emailController: _emailController,
                    passwordController: _passwordController,
                  ),
                  const SizedBox(height: 32),
                  ButtonWithLoading(
                    isLoading: usersViewModel.loading,
                    title: MultiLanguage.translate("createUser"),
                    onPressed: () async => await usersViewModel.createUser(
                      context,
                      email: _emailController.text,
                      password: _passwordController.text,
                      name: _nameController.text,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class CreateUserForm extends StatelessWidget {
  const CreateUserForm({
    Key? key,
    required this.usersViewModel,
    required TextEditingController nameController,
    required TextEditingController emailController,
    required TextEditingController passwordController,
  })  : _nameController = nameController,
        _emailController = emailController,
        _passwordController = passwordController,
        super(key: key);

  final UsersViewModel usersViewModel;
  final TextEditingController _nameController;
  final TextEditingController _emailController;
  final TextEditingController _passwordController;

  @override
  Widget build(BuildContext context) {
    UsersViewModel usersViewModel = context.watch<UsersViewModel>();
    return Flexible(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .8),
        child: Form(
          key: usersViewModel.crateUserFormKey,
          child: ListView(
            shrinkWrap: true,
            children: [
              TextFormField(
                autofocus: true,
                controller: _nameController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(label: Text(MultiLanguage.translate("name"))),
                validator: (val) {
                  if (val!.isEmpty) {
                    return MultiLanguage.translate("ENTER_VALID_NAME");
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              TextFormField(
                autofocus: true,
                textInputAction: TextInputAction.next,
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
                autofocus: true,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(label: Text(MultiLanguage.translate("repeatEmail"))),
                validator: (val) {
                  if (val != _emailController.text) {
                    return MultiLanguage.translate("EMAIL_DOESNT_MATCH");
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              TextFormField(
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.visiblePassword,
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  label: Text(MultiLanguage.translate("password")),
                  errorMaxLines: 2,
                ),
                validator: (val) {
                  if (!val!.isValidPassword) {
                    return MultiLanguage.translate("ENTER_VALID_PASSWORD");
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              TextFormField(
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                decoration: InputDecoration(label: Text(MultiLanguage.translate("repeatPassword"))),
                validator: (val) {
                  if (val != _passwordController.text) {
                    return MultiLanguage.translate("PASSWORD_DOESNT_MATCH");
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
