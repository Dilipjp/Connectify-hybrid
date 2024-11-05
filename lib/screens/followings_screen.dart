import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class FollowingsScreen extends StatefulWidget {
  final String userId;

  FollowingsScreen({required this.userId});

  @override
  _FollowingsScreenState createState() => _FollowingsScreenState();
}

class _FollowingsScreenState extends State<FollowingsScreen> {
  final DatabaseReference _usersRef = FirebaseDatabase.instance.ref('users');
  List<Map<String, dynamic>> followersList = [];

  @override
  void initState() {
    super.initState();
    _fetchFollowers();
  }
  Future<void> _fetchFollowers() async {
    final followersRef = FirebaseDatabase.instance.ref('users/${widget.userId}/followers');
    final followersSnapshot = await followersRef.get();

    if (followersSnapshot.exists) {
      final followersMap = followersSnapshot.value as Map<dynamic, dynamic>;

      List<Map<String, dynamic>> loadedFollowers = [];
      for (var followerId in followersMap.keys) {
        final userSnapshot = await _usersRef.child(followerId).get();
        if (userSnapshot.exists) {
          final userData = userSnapshot.value as Map<dynamic, dynamic>;
          loadedFollowers.add({
            'userId': followerId,
            'userName': userData['userName'],
            'userProfileImage': userData['userProfileImage'],
          });
        }
      }

      setState(() {
        followersList = loadedFollowers;
      });
    }
  }
