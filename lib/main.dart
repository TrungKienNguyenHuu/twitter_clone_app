import 'package:flutter/material.dart';
import 'package:twitter_clone_app/pages/signin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        //colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        brightness: Brightness.dark,
        appBarTheme: AppBarTheme(
          centerTitle: true,
          toolbarHeight: 100,
          shadowColor: Colors.yellow,
          ),
      ),
      home: const SignIn(title: 'Twitter Clone'),
    );
  }
}

