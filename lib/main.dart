import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'signin.dart';
import 'About Use App.dart';
import 'Servies.dart';
import 'signup.dart';
import 'charscreen.dart';
import 'chatbot.dart';
import 'saftey.dart';
import 'home.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(
    MyApp(),
    
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase Auth',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/signup', // Start with the Login screen
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
        '/home': (context) => HomeScreen(),
        '/about': (context) => AboutApp(),
        '/supporter': (context) => SupporterScreen(),
        '/chart': (context) => DataAnalysisScreen(),
        '/safety': (context) => SafetyMonitorScreen(),
        '/chatbot': (context) => SafetyAdvisorScreen(),
      },
    );
  }
}