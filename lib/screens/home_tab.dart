import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import 'comment_screen.dart'; // Import the new CommentsScreen

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final DatabaseReference _postsRef = FirebaseDatabase.instance.ref('posts');
  final DatabaseReference _usersRef = FirebaseDatabase.instance.ref('users');
  final DatabaseReference _reportsRef = FirebaseDatabase.instance.ref('reports'); // Reference to reports node

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Home',
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: StreamBuilder(
        stream: _postsRef.onValue,
        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return Center(child: Text('No posts yet'));
          }

          Map<dynamic, dynamic> posts = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
          List<dynamic> postList = posts.values.toList();

          return ListView.builder(
            itemCount: postList.length,
            itemBuilder: (context, index) {
              Map<dynamic, dynamic> post = postList[index];
              return FutureBuilder(
                future: _usersRef.child(post['userId']).once(),
                builder: (context, AsyncSnapshot<DatabaseEvent> userSnapshot) {
                  if (!userSnapshot.hasData || userSnapshot.data!.snapshot.value == null) {
                    return SizedBox.shrink();
                  }

                  Map<dynamic, dynamic> user = userSnapshot.data!.snapshot.value as Map<dynamic, dynamic>;

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundImage: user['userProfileImage'] != null && user['userProfileImage'].toString().isNotEmpty
                                      ? NetworkImage(user['userProfileImage'] as String)
                                      : AssetImage('assets/profile_placeholder.png') as ImageProvider,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  user['userName'] ?? 'Unknown User',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Image.network(
                            post['postImageUrl'] ?? '',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 250,
                            errorBuilder: (context, error, stackTrace) {
                              return Text('Error loading image');
                            },
                          ),
                          if (post['locationName'] != null && post['locationName'].isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Icon(Icons.location_on, color: Colors.red),
                                  SizedBox(width: 5),
                                  Text(
                                    post['locationName'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        post['likes'] != null && (post['likes'] as Map<dynamic, dynamic>).containsKey(FirebaseAuth.instance.currentUser!.uid)
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                      ),
                                      onPressed: () {
                                        String userId = FirebaseAuth.instance.currentUser!.uid;
                                        _handleLike(post['postId'], userId);
                                      },
                                    ),
                                    Text(
                                      post['likeCount']?.toString() ?? '0',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.comment_outlined),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => CommentsScreen(postId: post['postId']),
                                          ),
                                        );
                                      },
                                    ),
                                    Text(
                                      post['commentCount'] != null ? post['commentCount'].toString() : '0',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                IconButton(
                                  icon: Icon(Icons.share_outlined),
                                  onPressed: () {
                                    _handleShare(post['postImageUrl']);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.report, color: Colors.red),
                                  onPressed: () {
                                    _showReportDialog(post['postId']);
                                  },
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              post['caption'] ?? '',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _handleLike(String postId, String userId) async {
    DatabaseReference postRef = _postsRef.child(postId);

    DatabaseEvent event = await postRef.once();
    DataSnapshot snapshot = event.snapshot;

    if (snapshot.exists) {
      Map<dynamic, dynamic> post = snapshot.value as Map<dynamic, dynamic>;
      int currentLikeCount = post['likeCount'] ?? 0;
      Map<dynamic, dynamic> likes = post['likes'] ?? {};

      if (likes.containsKey(userId)) {
        likes.remove(userId);
        currentLikeCount -= 1;
      } else {
        likes[userId] = true;
        currentLikeCount += 1;
      }

      await postRef.update({
        'likeCount': currentLikeCount,
        'likes': likes,
      });
    }
  }

  void _handleShare(String postImageUrl) {
    print('Share button clicked! Image URL: $postImageUrl');
    if (postImageUrl.isNotEmpty) {
      Share.share('Check out this post! $postImageUrl');
    } else {
      Share.share('Check out this post!');
    }
  }

  void _showReportDialog(String postId) {
    showDialog(
      context: context,
      builder: (context) {
        String reason = '';
        return AlertDialog(
          title: Text('Report Post'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Please provide a reason for reporting this post.'),
              TextField(
                onChanged: (value) {
                  reason = value;
                },
                decoration: InputDecoration(hintText: "Reason"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (reason.isNotEmpty) {
                  String userId = FirebaseAuth.instance.currentUser!.uid;
                  int timestamp = DateTime.now().millisecondsSinceEpoch;

                  // Save the report data
                  await _reportsRef.push().set({
                    'postId': postId,
                    'reason': reason,
                    'timestamp': timestamp,
                    'userId': userId,
                  });

                  Navigator.of(context).pop(); // Close the dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Post reported successfully!')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please provide a reason.')),
                  );
                }
              },
              child: Text('Report'),
            ),
          ],
        );
      },
    );
  }

}
