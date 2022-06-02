import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gastosrecorrentes/services/firestore_service.dart';
import 'package:gastosrecorrentes/services/navigation_service.dart';
import 'package:gastosrecorrentes/services/shared_preferences.dart';
import 'package:gastosrecorrentes/view_models/bills_view_model.dart';
import 'package:gastosrecorrentes/view_models/init_app_view_model.dart';
import 'package:gastosrecorrentes/view_models/users_view_model.dart';
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
  Widget build(BuildContext context) {
    return MultiProvider(
      key: key,
      providers: [
        ChangeNotifierProvider(create: (_) => BillsViewModel(fireStoreService: FireStoreService())),
        ChangeNotifierProvider(create: (_) => InitAppViewModel()),
        ChangeNotifierProvider(create: (_) => UsersViewModel()),
        Provider(create: (_) => SharedPreferencesService()),
      ],
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Gastos Recorrentes',
          theme: _setThemeData,
          routes: availableRoutes,
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
