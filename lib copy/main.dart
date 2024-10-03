import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/sign_in_screen.dart';
import 'screens/sign_up_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SplashScreen(),
      routes: {
        '/sign-in': (context) => SignInScreen(),
        '/sign-up': (context) => SignUpScreen(),
        '/forgot-password': (context) => ForgotPasswordScreen(),
        '/home': (context) => HomeScreen(),
      },
    );
  }
}
