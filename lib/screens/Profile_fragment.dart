import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'Sign_in_screen.dart';

class ProfileFragment extends StatefulWidget {
  @override
  _ProfileFragmentState createState() => _ProfileFragmentState();
}

class _ProfileFragmentState extends State<ProfileFragment> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference usersRef = FirebaseDatabase.instance.ref('users');

  String? userName;
  String? userEmail;

  @override
  void initState() {
    super.initState();
    loadUserDetails();
  }

  void loadUserDetails() async {
    String userId = _auth.currentUser!.uid;
    // Using the once() method which returns a Future<DatabaseEvent>
    DatabaseEvent event = await usersRef.child(userId).once();
    DataSnapshot snapshot = event.snapshot;

    if (snapshot.value != null) {
      // Cast the value to a Map<String, dynamic> to access keys safely
      final userData = snapshot.value as Map<String, dynamic>;
      setState(() {
        userName = userData['userName'];
        userEmail = userData['userEmail'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(userName ?? 'Loading...'),
        Text(userEmail ?? 'Loading...'),
        ElevatedButton(
          onPressed: () async {
            await _auth.signOut(); // Sign out the user
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => SignInScreen()),
            );
          },
          child: Text('Sign Out'),
        ),

      ],
    );
  }
}
