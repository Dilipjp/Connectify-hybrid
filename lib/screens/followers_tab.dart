import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class FollowersTab extends StatefulWidget {
  const FollowersTab({super.key});

  @override
  _UsersListScreenState createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<FollowersTab> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  String? currentUserId;
  Map<String, dynamic> allUsers = {}; // Store all users
  Map<String, bool> currentUserFollowing = {}; // Store follow status of other users

  @override
  void initState() {
    super.initState();
    currentUserId = _auth.currentUser?.uid;
    _loadUsers();
  }


  // Fetch all users with userRole = "User", except the current user
  Future<void> _loadUsers() async {
    try {
      DatabaseReference usersRef = _database.ref('users');

      // Fetch all users from the database
      usersRef.onValue.listen((DatabaseEvent event) {
        if (event.snapshot.exists) {
          final usersMap = Map<String, dynamic>.from(event.snapshot.value as Map);

          setState(() {
            // Convert to list of entries, filter, and then convert back to Map
            allUsers = Map.fromEntries(
              usersMap.entries
                  .where((entry) => entry.key != currentUserId && entry.value['userRole'] == 'User')
                  .map((entry) => MapEntry(entry.key, Map<String, dynamic>.from(entry.value))),
            );

            // After loading users, load follow status for each user
            _loadFollowStatus();
          });
        }
      });
    } catch (e) {
      print('Error loading users: $e');
    }
  }



  // Check if the current user is following each user
  Future<void> _loadFollowStatus() async {
    for (String userId in allUsers.keys) {
      DatabaseReference followersRef = _database.ref('users/$userId/followers/$currentUserId');

      followersRef.onValue.listen((DatabaseEvent event) {
        setState(() {
          currentUserFollowing[userId] = event.snapshot.exists;
        });
      });
    }
  }

  // Follow a user by adding the current user's ID to their followers node
  Future<void> _followUser(String userId) async {
    try {
      DatabaseReference userFollowersRef = _database.ref('users/$userId/followers/$currentUserId');
      await userFollowersRef.set(true);
    } catch (e) {
      print('Error following user: $e');
    }
  }

  // Unfollow a user by removing the current user's ID from their followers node
  Future<void> _unfollowUser(String userId) async {
    try {
      DatabaseReference userFollowersRef = _database.ref('users/$userId/followers/$currentUserId');
      await userFollowersRef.remove();
    } catch (e) {
      print('Error unfollowing user: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: allUsers.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: allUsers.length,
        itemBuilder: (context, index) {
          final userId = allUsers.keys.elementAt(index);
          final user = allUsers[userId];

          return ListTile(
            leading: CircleAvatar(
              backgroundImage: user['userProfileImage'] != null && user['userProfileImage'].toString().isNotEmpty
                  ? NetworkImage(user['userProfileImage'])
                  : const AssetImage('assets/profile_placeholder.png') as ImageProvider,
            ),
            title: Text(user['userName'] ?? 'Unknown User'),
            subtitle: Text(user['userBio'] ?? ''),
            trailing: ElevatedButton(
              onPressed: () {
                if (currentUserFollowing[userId] == true) {
                  _unfollowUser(userId); // Unfollow if already following
                } else {
                  _followUser(userId); // Follow if not following
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: currentUserFollowing[userId] == true ? Colors.red : Colors.black,
              ),
              child: Text(
                currentUserFollowing[userId] == true ? 'Unfollow' : 'Follow',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
        },
      ),
    );
  }
}
