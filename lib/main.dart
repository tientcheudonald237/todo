import 'package:flutter/material.dart';
import 'screen/authentification/signIn.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  final Color red = Colors.red; // Nouvelle couleur rouge

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //home: HomePages(),
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        hintColor: const Color.fromARGB(255, 255, 255, 255),
        // accentColor: red, // Nouvelle couleur rouge
        // accentColor: const Color.fromARGB(255, 255, 66, 66),
        fontFamily: 'Montserrat',
        // textTheme: const TextTheme(
        //   bodyText1: TextStyle(fontSize: 16.0),
        //   bodyText2: TextStyle(fontSize: 14.0),
        //   headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
        //   headline6: TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic),
        // ),
      ),
      home: SignIn(),
    );
  }
}
