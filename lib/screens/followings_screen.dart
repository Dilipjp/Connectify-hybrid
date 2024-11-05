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
