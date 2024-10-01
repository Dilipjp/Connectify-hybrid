import 'package:connectify/screens/Fogotpassword_screen.dart';
import 'package:connectify/screens/mainscreen.dart';
import 'package:connectify/splashscreen/splashscreen.dart';
import 'package:connectify/utils/config.dart';
import 'package:flutter/material.dart';
import 'Login/login.dart';
import 'Register/register.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Config.initFirebase(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Connectify App',


      initialRoute: '/splash',
      routes: {
        '/splash': (context) => SplashScreen(),
        '/login': (context) => SignInScreen(),
        '/signup': (context) => SignUpScreen(),
        '/home': (context) => HomeScreen(),
        '/forget-password': (context) => ForgetPasswordScreen(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
