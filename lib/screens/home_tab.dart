import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';


class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final DatabaseReference _postsRef = FirebaseDatabase.instance.ref('posts');
  final DatabaseReference _usersRef = FirebaseDatabase.instance.ref('users');
  final DatabaseReference _commentsRef = FirebaseDatabase.instance.ref('comments');

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
        backgroundColor: Colors.purple,
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
                                        String userId = FirebaseAuth.instance.currentUser!.uid; // Get the current user's ID
                                        _handleLike(post['postId'], userId); // Pass user ID to handle like
                                      },
                                    ),
                                    Text(
                                      post['likeCount']?.toString() ?? '0', // Like count
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.comment_outlined),
                                      onPressed: () {
                                        // Navigate to the comment screen
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => CommentsScreen(postId: post['postId']),
                                          ),
                                        );
                                      },
                                    ),
                                    Text(
                                      post['commentCount'] != null ? post['commentCount'].toString() : '0', // Fallback to '0' if null
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

    // Get the current post data
    DatabaseEvent event = await postRef.once();
    DataSnapshot snapshot = event.snapshot;

    if (snapshot.exists) {
      // Get the current likes map and like count
      Map<dynamic, dynamic> post = snapshot.value as Map<dynamic, dynamic>;
      int currentLikeCount = post['likeCount'] ?? 0;
      Map<dynamic, dynamic> likes = post['likes'] ?? {};

      if (likes.containsKey(userId)) {
        // User already liked, remove like
        likes.remove(userId);
        currentLikeCount -= 1; // Decrease like count
      } else {
        // User has not liked, add like
        likes[userId] = true;
        currentLikeCount += 1; // Increase like count
      }

      // Update the post data
      await postRef.update({
        'likeCount': currentLikeCount,
        'likes': likes,
      });
    }
  }

  void _handleShare(String postImageUrl) {
    print('Share button clicked! Image URL: $postImageUrl'); // Debugging line
    if (postImageUrl.isNotEmpty) {
      Share.share('Check out this post! $postImageUrl');
    } else {
      Share.share('Check out this post!');
    }
  }
}

// Comments Screen
class CommentsScreen extends StatefulWidget {
  final String postId;

  const CommentsScreen({Key? key, required this.postId}) : super(key: key);

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _commentController = TextEditingController();
  final DatabaseReference _commentsRef = FirebaseDatabase.instance.ref('posts');

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  // Function to add a comment
  void _addComment() {
    if (_commentController.text.isNotEmpty) {
      final comment = {
        'commentText': _commentController.text,
        'userId': FirebaseAuth.instance.currentUser!.uid,
        'userName': FirebaseAuth.instance.currentUser!.displayName ?? 'User',
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };

      DatabaseReference postRef = _commentsRef.child(widget.postId);

      // Add comment to the database
      postRef
          .child('comments')
          .push()
          .set(comment)
          .then((_) {
        _commentController.clear();

        // Increment comment count
        postRef.child('commentCount').runTransaction((mutableData) {
          int currentCount = (mutableData as int? ?? 0); // Cast mutableData to int or default to 0
          mutableData = currentCount + 1; // Increment the count
          return Transaction.success(mutableData); // Return the updated data
        });



      });
    }
  }


  // Function to fetch comments
  // Function to fetch comments
  Stream<List<Map<String, dynamic>>> _fetchComments() async* {
    final event = await _commentsRef.child(widget.postId).child('comments').once();

    // If there are no comments, return an empty list
    if (event.snapshot.value == null) {
      yield [];
      return;
    }

    final commentsMap = Map<String, dynamic>.from(event.snapshot.value as Map);

    List<Map<String, dynamic>> commentsList = [];

    // Iterate through each comment
    for (var entry in commentsMap.entries) {
      final commentData = Map<String, dynamic>.from(entry.value);
      final userId = commentData['userId'];  // Get the userId for the comment

      // Fetch user data based on userId
      final userSnapshot = await FirebaseDatabase.instance.ref().child('users').child(userId).once();
      final userData = userSnapshot.snapshot.value as Map;

      // Add userName and userProfileImage to comment data
      commentData['userName'] = userData['userName'];
      commentData['userProfileImage'] = userData['userProfileImage'];

      commentsList.add(commentData);
    }

    yield commentsList;  // Yield the comments list with user data
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _fetchComments(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator()); // Show loading spinner while waiting
                }

                // Check if there are no comments
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No comments yet')); // Display message if no comments
                }

                final comments = snapshot.data!;
                return ListView.builder(
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    final commentText = comment['commentText'];
                    final userName = comment['userName'] ?? 'Anonymous';  // Fallback if userName is missing
                    final userProfileImage = comment['userProfileImage'] ?? '';  // Fallback if profileImage is missing
                    final timestamp = comment['timestamp'];
                    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
                    final timeFormatted = DateFormat('MMM d, hh:mm a').format(dateTime);

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: userProfileImage != null && userProfileImage.isNotEmpty
                            ? NetworkImage(userProfileImage) as ImageProvider<Object>
                            : AssetImage('assets/images/default_avatar.png'),  // Default avatar
                      ),
                      title: Text(userName),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(commentText),
                          SizedBox(height: 4),
                          Text(
                            timeFormatted,
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Add a comment...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _addComment,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


}
