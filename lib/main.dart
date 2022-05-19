import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gastosrecorrentes/view_models/bills_view_model.dart';
import 'package:gastosrecorrentes/views/sign_in.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BillsViewModel()),
      ],
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Gastos Recorrentes',
          theme: ThemeData(
            primarySwatch: Colors.indigo,
            primaryColor: Colors.indigo,
            scaffoldBackgroundColor: Colors.grey[200],
            listTileTheme: ListTileThemeData(tileColor: Colors.grey[600]),
            shadowColor: Colors.grey[800],
            textSelectionTheme: const TextSelectionThemeData(
              cursorColor: Colors.indigo,
              selectionHandleColor: Colors.indigo,
              selectionColor: Colors.indigo,
            ),
          ),
          home: const SignInScreen(),
        ),
      ),
    );
  }
}
