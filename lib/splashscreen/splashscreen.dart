<<<<<<< HEAD
import 'package:connectify/Login/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
=======
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import '../screens/landing_page.dart';
>>>>>>> f777a7b046bdee987911d81dcfc7ca05fbbb8eaa
import '../screens/mainscreen.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {

  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => AuthWrapper()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
body: Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
<<<<<<< HEAD
      Image.asset('assets/images/Splash_connectify.jpeg',height: 100,),
      SizedBox(height: 20),

=======
      Image.asset('assets/images/splashscreen.jpeg',height: 100,),
      SizedBox(height: 20),
      CircularProgressIndicator(),
>>>>>>> f777a7b046bdee987911d81dcfc7ca05fbbb8eaa
    ],
  ),
),
    );
  }
}
class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            return TabScreen();
          } else {
<<<<<<< HEAD
            return Login();
          }
        }
        return Scaffold(

=======
            return Landing();
          }
        }
        return Scaffold(
          body: Center(child: CircularProgressIndicator()),
>>>>>>> f777a7b046bdee987911d81dcfc7ca05fbbb8eaa
        );
      },
    );
  }
}

