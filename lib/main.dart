import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gastosrecorrentes/services/remote/firebase_auth_service.dart';
import 'package:gastosrecorrentes/services/remote/firestore_service.dart';
import 'package:gastosrecorrentes/services/local/navigation_service.dart';
import 'package:gastosrecorrentes/services/local/shared_preferences.dart';
import 'package:gastosrecorrentes/shared/globals.dart';
import 'package:gastosrecorrentes/view_models/bills_view_model.dart';
import 'package:gastosrecorrentes/view_models/init_app_view_model.dart';
import 'package:gastosrecorrentes/view_models/users_view_model.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Key key = UniqueKey();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      key: key,
      providers: [
        ChangeNotifierProvider(create: (_) => BillsViewModel(fireStoreService: FireStoreService())),
        ChangeNotifierProvider(create: (_) => InitAppViewModel(firebaseAuthService: FirebaseAuthService())),
        ChangeNotifierProvider(create: (_) => UsersViewModel(firebaseAuthService: FirebaseAuthService())),
        Provider(create: (_) => SharedPreferencesService()),
      ],
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: MaterialApp(
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          scaffoldMessengerKey: snackbarKey,
          debugShowCheckedModeBanner: false,
          title: 'Gastos Recorrentes',
          theme: _setThemeData,
          routes: NavigationService.availableRoutes,
        ),
      ),
    );
  }

  final ThemeData _setThemeData = ThemeData(
    primarySwatch: Colors.indigo,
    primaryColor: Colors.indigo,
    scaffoldBackgroundColor: Colors.grey[200],
    shadowColor: Colors.grey[800],
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Colors.indigo,
      selectionHandleColor: Colors.indigo,
      selectionColor: Colors.indigo,
    ),
  );
}
