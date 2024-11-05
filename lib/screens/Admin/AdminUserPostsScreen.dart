import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AdminUserPostsScreen extends StatefulWidget {
  final String userId;

  AdminUserPostsScreen({required this.userId});

  @override
  _AdminUserPostsScreenState createState() => _AdminUserPostsScreenState();
}

class _AdminUserPostsScreenState extends State<AdminUserPostsScreen> {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  List<Map<dynamic, dynamic>> userPosts = [];

  // Show loading dialog
  void _showLoadingSpinner(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  // Dismiss loading dialog
  void _hideLoadingSpinner(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    _loadUserPosts();
  }

  void _loadUserPosts() {
    DatabaseReference postsRef = _database.ref('posts');

    postsRef.orderByChild('userId').equalTo(widget.userId).onValue.listen((DatabaseEvent event) {
      final snapshot = event.snapshot;

      if (snapshot.children.isNotEmpty) { // Check if children exist
        setState(() {
          userPosts = snapshot.children
              .map((child) => child.value as Map<dynamic, dynamic>)
              .toList();
        });
      }
    }, onError: (error) {
      print('Error loading posts: $error');
    });
  }