
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:applicazionedefinitiva/Page/PageLogin.dart';
import 'package:applicazionedefinitiva/Page/PageSwitch.dart';
import 'Service/ServiceAuth.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreenAccent),
      ),
      color: Colors.lightGreenAccent,
      home: StreamBuilder(
          stream: ServiceAuth().authStateChanges,
          builder: (context, snapshot){
            if(snapshot.hasData){
              return PageSwitch();
            }
            return PageLogin();
          }
      )
    );
  }
}
