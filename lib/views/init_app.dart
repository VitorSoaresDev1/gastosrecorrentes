import 'package:flutter/material.dart';
import 'package:gastosrecorrentes/helpers/functions_helper.dart';
import 'package:gastosrecorrentes/services/navigation_service.dart';
import 'package:gastosrecorrentes/view_models/init_app_view_model.dart';
import 'package:provider/provider.dart';

class InitApp extends StatefulWidget {
  const InitApp({Key? key}) : super(key: key);

  @override
  State<InitApp> createState() => _InitAppState();
}

class _InitAppState extends State<InitApp> {
  @override
  Widget build(BuildContext context) {
    final initAppViewModel = context.watch<InitAppViewModel>();
    if (initAppViewModel.loading) {
      initAppViewModel.loadAppInitialConfigs(context);
    } else {
      scheduleCall(() => openSignInPage(context));
    }
    return Scaffold(body: Container());
  }
}
