import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _usersDatabase = FirebaseDatabase.instance.reference().child('users');

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _userBioController = TextEditingController();

  String _selectedRole = '';
  String _errorMessage = '';
  String _successMessage = '';

  void _createNewAccount() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();
    String userName = _userNameController.text.trim();
    String userBio = _userBioController.text.trim();

    if (userName.isEmpty) {
      _showError("Username is required");
      return;
    }
    if (email.isEmpty || !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      _showError("Please enter a valid email");
      return;
    }
    if (password.length < 6) {
      _showError("Password should be at least 6 characters");
      return;
    }
    if (password != confirmPassword) {
      _showError("Passwords do not match");
      return;
    }
    if (_selectedRole.isEmpty) {
      _showError("User role is required");
      return;
    }

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        String userId = userCredential.user!.uid;
        await _saveUserDetails(userId, userName, email, userBio, _selectedRole);

        // Clear all input fields
        _clearFields();

        // Navigate to the Sign In page
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      _showError(e.toString());
    }
  }

  _saveUserDetails(String userId, String userName, String email, String userBio, String userRole) async {
    Map<String, dynamic> userDetails = {
      'userName': userName,
      'userEmail': email,
      //'userProfileImage': 'https://via.placeholder.com/150',
      'userBio': userBio,
      'userRole': userRole,
      'userStatus': 'active',
      'userCreatedAt': DateTime.now().millisecondsSinceEpoch,
    };

    try {
      await _usersDatabase.child(userId).set(userDetails);
      setState(() {
        _successMessage = "Account created successfully.";
        _errorMessage = "";
      });

      // Show Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_successMessage),
          duration: Duration(seconds: 3),
        ),
      );

    } catch (e) {
      _showError("Failed to save user details.");
    }
  }

  void _showError(String message) {
    // Show Snackbar for error messages
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );

  }

  void _clearFields() {
    _userNameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
    _userBioController.clear();
    setState(() {
      _selectedRole = '';
      _errorMessage = '';
      _successMessage = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign Up")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                height: 170.0,
                width: MediaQuery.of(context).size.width,
                child: Image.asset(
                  'assets/images/login.png',
                  fit: BoxFit.contain,
                ),
              ),

              SizedBox(height: 20),
              TextField(
                controller: _userNameController,
                decoration: InputDecoration(
                  labelText: "Username",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 10),
              TextField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: "Confirm Password",
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 10),
              TextField(
                controller: _userBioController,
                decoration: InputDecoration(
                  labelText: "Bio",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedRole.isEmpty ? null : _selectedRole,
                hint: Text("Select Role"),
                items: ['Admin', 'User'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedRole = newValue!;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _createNewAccount,
                child: Text("Sign Up"),
              ),
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    _errorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              if (_successMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    _successMessage,
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: Text("Already have an account? Sign In"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
