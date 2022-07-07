import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gastosrecorrentes/services/local/navigation_service.dart';
import 'package:gastosrecorrentes/view_models/init_app_view_model.dart';

class InitApp extends StatelessWidget {
  const InitApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final initAppViewModel = context.watch<InitAppViewModel>();
    if (initAppViewModel.loading) {
      initAppViewModel.loadAppInitialConfigs(context);
    } else {
      NavigationService.navigateToInitialScreen(context, initAppViewModel.firebaseAuthService.currentUser());
    }
    return Scaffold(body: Container());
  }
}
