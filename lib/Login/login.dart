import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? errorMessage;

  void signInUser() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty) {
      setState(() {
        errorMessage = 'Email is required';
      });
      return;
    }

    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      setState(() {
        errorMessage = 'Please enter a valid email address';
      });
      return;
    }

    if (password.isEmpty) {
      setState(() {
        errorMessage = 'Password is required';
      });
      return;
    }

    if (password.length < 6) {
      setState(() {
        errorMessage = 'Password must be at least 6 characters long';
      });
      return;
    }

    setState(() {
      errorMessage = null;
    });

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = 'Authentication failed: ${e.message}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [

            Container(
              height: 170.0,
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                'assets/login.png',
                fit: BoxFit.contain,
              ),
            ),

            SizedBox(height: 10.0),

            // Sign In Form
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Welcome Back',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),


                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      errorText: errorMessage?.contains('Email') ?? false ? errorMessage : null,
                    ),
                  ),
                  SizedBox(height: 16),


                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      errorText: errorMessage?.contains('Password') ?? false ? errorMessage : null,
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 20),

                  Center(
                    child: SizedBox(
                      width: 100,
                      height: 40,
                      child:ElevatedButton(
                        onPressed: signInUser,
                        child: Text('Sign In', style: TextStyle(fontSize: 14),),

                      ),
                    ),),


                  SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/signup');
                        },
                        child: Text('Dont have an account? SignUp'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/forget-password');
                        },
                        child: Text('Forgot Password?'),
                      ),
                    ],
                  ),
                  // Error Message
                  if (errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        errorMessage!,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
