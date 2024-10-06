import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class ProfileTab extends StatefulWidget {
  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  String? userName;
  String? userBio;
  String? userProfileImage;
  String? userEmail;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    // Get the current user
    User? currentUser = _auth.currentUser;

    if (currentUser != null) {
      String userId = currentUser.uid;

      // Reference to the user's data in the database
      DatabaseReference userRef = _database.ref('users/$userId');

      // Listen to the user's data and update the UI when data changes
      userRef.once().then((DatabaseEvent event) {
        if (event.snapshot.exists) {
          Map<dynamic, dynamic> userData = event.snapshot.value as Map;

          setState(() {
            userName = userData['userName'] ?? 'Unknown';
            userBio = userData['userBio'] ?? 'No bio available';
            userProfileImage = userData['userProfileImage'] ?? 'assets/profile_placeholder.png';
            userEmail = userData['userEmail'] ?? 'No email available';
          });
        }
      }).catchError((error) {
        print('Error loading user data: $error');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Profile',
          style: TextStyle(color: Colors.white), // Set text color to white
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              // decoration: BoxDecoration(
              //   color: Colors.purple,
              //   borderRadius: BorderRadius.vertical(
              //     bottom: Radius.circular(30),
              //   ),
              // ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: userProfileImage != null
                        ? NetworkImage(userProfileImage!)
                        : AssetImage('assets/profile_placeholder.png')
                    as ImageProvider,
                  ),
                  SizedBox(height: 10),
                  Text(
                    userName ?? 'Loading...',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    userBio ?? '@loading_bio',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatColumn('Posts', '24'),
                _buildStatColumn('Followers', '2.1K'),
                _buildStatColumn('Following', '350'),
              ],
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: ElevatedButton(
                onPressed: () {
                  // Edit profile action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                child: Center(
                  child: Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    await _auth.signOut(); // Sign out from Firebase
                    Navigator.pushReplacementNamed(context, '/sign-in');
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error signing out: $e')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                child: Center(
                  child: Text(
                    'Log Out',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            // Center(
            //   child: Text(
            //     'No posts yet',
            //     style: TextStyle(color: Colors.grey, fontSize: 16),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String count) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
