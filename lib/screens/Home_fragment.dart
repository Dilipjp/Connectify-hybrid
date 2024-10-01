import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class HomeFragment extends StatefulWidget {
  @override
  _HomeFragmentState createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
  List<Post> postList = [];
  DatabaseReference postsRef = FirebaseDatabase.instance.reference().child('posts');

  @override
  void initState() {
    super.initState();
    loadPosts();
  }

  void loadPosts() {
    postsRef.onValue.listen((event) {
      final data = event.snapshot.value;
      if (data != null) {
        postList.clear();
        (data as Map).forEach((key, value) {
          Post post = Post.fromMap(value);
          postList.add(post);
        });
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: postList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(postList[index].caption),
          leading: Image.network(postList[index].postImageUrl),
        );
      },
    );
  }
}

class Post {
  String postId;
  String postImageUrl;
  String caption;

  Post({required this.postId, required this.postImageUrl, required this.caption});

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      postId: map['postId'],
      postImageUrl: map['postImageUrl'],
      caption: map['caption'],
    );
  }
}
