import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Login/login.dart';
import '../Register/register.dart';
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
      bottomNavigationBar: BottomAppBar(
        elevation: 0.0,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildButton('LOGIN', context, Login()),
              _buildButton('SIGN UP', context, Register()), // Replace with your Sign Up page
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildButton(String label, BuildContext context, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushReplacement(
          CupertinoPageRoute(builder: (_) => page),
        );
      },
      child: Container(
        height: 45.0,
        width: 130.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40.0),
          border: Border.all(color: Colors.grey),
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Theme.of(context).colorScheme.secondary,
              Color(0xff597FDB),
            ],
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

