import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class UserPostsScreen extends StatefulWidget {
  final String userId;

  UserPostsScreen({required this.userId});

  @override
  _UserPostsScreenState createState() => _UserPostsScreenState();
}

class _UserPostsScreenState extends State<UserPostsScreen> {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  List<Map<dynamic, dynamic>> userPosts = [];

  @override
  void initState() {
    super.initState();
    _loadUserPosts();
  }

  // Load user's posts
  void _loadUserPosts() {
    DatabaseReference postsRef = _database.ref('posts');

    postsRef.orderByChild('userId').equalTo(widget.userId).onValue.listen((DatabaseEvent event) {
      if (event.snapshot.exists) {
        Map<dynamic, dynamic> posts = event.snapshot.value as Map<dynamic, dynamic>;

        setState(() {
          // Cast the list to the appropriate type
          userPosts = posts.values.map((value) => value as Map<dynamic, dynamic>).toList();
        });
      }
    }, onError: (error) {
      print('Error loading posts: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Posts',
          style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        itemCount: userPosts.length,
        itemBuilder: (context, index) {
          Map<dynamic, dynamic> post = userPosts[index];
          return ListTile(
            title: Text(post['caption']),
            subtitle: Text(post['timestamp'].toString()), // You can format timestamp here
            leading: post['postImageUrl'] != null
                ? Image.network(post['postImageUrl'])
                : SizedBox.shrink(),
          );
        },
      ),
    );
  }
}
