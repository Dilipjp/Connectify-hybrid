import 'package:flutter/material.dart';
import 'dart:async';


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


    );
  }
}

