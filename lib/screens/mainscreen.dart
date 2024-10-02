
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class TabScreen extends StatefulWidget {

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"), // Optional: You can set the title for the AppBar
      ),
      body: Center(
        child: Text(
          "This is your home page",
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

    );
  }


}
