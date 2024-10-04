import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Forgot Password')),
      body: Center(
        child: Column(
          children: [
            TextField(decoration: InputDecoration(labelText: 'Email')),
            ElevatedButton(
              onPressed: () {
                // Add password recovery logic here
              },
              child: Text('Reset Password'),
            ),
          ],
        ),
      ),
    );
  }
}
