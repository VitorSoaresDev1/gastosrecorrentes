import 'package:flutter/material.dart';
import 'package:gastosrecorrentes/helpers/functions_helper.dart';
import 'package:gastosrecorrentes/services/navigation_service.dart';
import 'package:gastosrecorrentes/view_models/init_app_view_model.dart';
import 'package:provider/provider.dart';

class InitApp extends StatelessWidget {
  const InitApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final initAppViewModel = context.watch<InitAppViewModel>();
    if (initAppViewModel.loading) {
      initAppViewModel.loadAppInitialConfigs(context);
    } else {
      scheduleCall(() => replaceToSignInScreen(context));
    }
    return Scaffold(body: Container());
  }
}
