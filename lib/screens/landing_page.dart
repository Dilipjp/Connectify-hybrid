import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:connectify/login/login.dart';


class Landing extends StatefulWidget {
  const Landing({super.key});

  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
      child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
      Image.asset(
      'assets/images/new1.png',
      height: 200.0,
      width: 200.0,
      fit: BoxFit.cover,
    ),
    SizedBox(height: 20),
    Text(
    'Connectify',
    style: TextStyle(
    fontSize: 22.0,
    fontWeight: FontWeight.w900,
    fontFamily: 'Ubuntu-Regular',
    ),
    ),
    ],
    ),
    ),
  }
}
