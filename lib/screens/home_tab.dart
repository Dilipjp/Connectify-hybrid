import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:share_plus/share_plus.dart';
import 'comment_screen.dart'; // Import the new CommentsScreen



class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

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
        title: const Center(
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
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return const Center(child: Text('No posts yet'));
          }

          Map<dynamic, dynamic> posts = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
          List<dynamic> postList = posts.values.toList();

          // return ListView.builder(
          //   itemCount: postList.length,
          //   itemBuilder: (context, index) {
          //     Map<dynamic, dynamic> post = postList[index];
          //     return FutureBuilder(
          //       future: _usersRef.child(post['userId']).once(),
          //       builder: (context, AsyncSnapshot<DatabaseEvent> userSnapshot) {
          //         if (!userSnapshot.hasData || userSnapshot.data!.snapshot.value == null) {
          //           return SizedBox.shrink();
          //         }
          //
          //         Map<dynamic, dynamic> user = userSnapshot.data!.snapshot.value as Map<dynamic, dynamic>;
          //
          //         return Padding(
          //           padding: const EdgeInsets.all(8.0),
          //           child: Card(
          //             shape: RoundedRectangleBorder(
          //               borderRadius: BorderRadius.circular(15.0),
          //             ),
          //             elevation: 5,
          //             child: Column(
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               children: [
          //                 Padding(
          //                   padding: const EdgeInsets.all(8.0),
          //                   child: Row(
          //                     children: [
          //                       CircleAvatar(
          //                         radius: 20,
          //                         backgroundImage: user['userProfileImage'] != null && user['userProfileImage'].toString().isNotEmpty
          //                             ? NetworkImage(user['userProfileImage'] as String)
          //                             : AssetImage('assets/profile_placeholder.png') as ImageProvider,
          //                       ),
          //                       SizedBox(width: 10),
          //                       Text(
          //                         user['userName'] ?? 'Unknown User',
          //                         style: TextStyle(
          //                           fontWeight: FontWeight.bold,
          //                           fontSize: 16,
          //                         ),
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //                 SizedBox(height: 10),
          //                 Image.network(
          //                   post['postImageUrl'] ?? '',
          //                   fit: BoxFit.cover,
          //                   width: double.infinity,
          //                   height: 250,
          //                   errorBuilder: (context, error, stackTrace) {
          //                     return Text('Error loading image');
          //                   },
          //                 ),
          //                 Padding(
          //                   padding: const EdgeInsets.all(8.0),
          //                   child: Row(
          //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                     children: [
          //                       Row(
          //                         children: [
          //                           IconButton(
          //                             icon: Icon(
          //                               post['likes'] != null && (post['likes'] as Map<dynamic, dynamic>).containsKey(FirebaseAuth.instance.currentUser!.uid)
          //                                   ? Icons.favorite
          //                                   : Icons.favorite_border,
          //                             ),
          //                             onPressed: () {
          //                               String userId = FirebaseAuth.instance.currentUser!.uid; // Get the current user's ID
          //                               _handleLike(post['postId'], userId); // Pass user ID to handle like
          //                             },
          //                           ),
          //                           Text(
          //                             post['likeCount']?.toString() ?? '0', // Like count
          //                             style: TextStyle(fontSize: 16),
          //                           ),
          //                         ],
          //                       ),
          //                       Row(
          //                         children: [
          //                           IconButton(
          //                             icon: Icon(Icons.comment_outlined),
          //                             onPressed: () {
          //                               // Navigate to the comment screen
          //                               Navigator.push(
          //                                 context,
          //                                 MaterialPageRoute(
          //                                   builder: (context) => CommentsScreen(postId: post['postId']),
          //                                 ),
          //                               );
          //                             },
          //                           ),
          //                           Text(
          //                             post['commentCount'] != null ? post['commentCount'].toString() : '0', // Fallback to '0' if null
          //                             style: TextStyle(fontSize: 16),
          //                           ),
          //                         ],
          //                       ),
          //
          //                       IconButton(
          //                         icon: Icon(Icons.share_outlined),
          //                         onPressed: () {
          //                           _handleShare(post['postImageUrl']);
          //                         },
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //                 Padding(
          //                   padding: const EdgeInsets.all(8.0),
          //                   child: Text(
          //                     post['caption'] ?? '',
          //                     style: TextStyle(
          //                       fontSize: 16,
          //                     ),
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           ),
          //         );
          //       },
          //     );
          //   },
          // );

          return ListView.builder(
            itemCount: postList.length,
            itemBuilder: (context, index) {
              Map<dynamic, dynamic> post = postList[index];
              return FutureBuilder(
                future: _usersRef.child(post['userId']).once(),
                builder: (context, AsyncSnapshot<DatabaseEvent> userSnapshot) {
                  if (!userSnapshot.hasData || userSnapshot.data!.snapshot.value == null) {
                    return const SizedBox.shrink();
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
                                      : const AssetImage('assets/profile_placeholder.png') as ImageProvider,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  user['userName'] ?? 'Unknown User',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Image.network(
                            post['postImageUrl'] ?? '',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 250,
                            errorBuilder: (context, error, stackTrace) {
                              return const Text('Error loading image');
                            },
                          ),
                          // Location Display Section
                          if (post['locationName'] != null && post['locationName'] != null) // Check if location is available
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.location_on, color: Colors.red), // Location icon
                                  const SizedBox(width: 5),
                                  Text(
                                    post['locationName'], // Display the location name
                                    style: const TextStyle(
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
                                        String userId = FirebaseAuth.instance.currentUser!.uid; // Get the current user's ID
                                        _handleLike(post['postId'], userId); // Pass user ID to handle like
                                      },
                                    ),
                                    Text(
                                      post['likeCount']?.toString() ?? '0', // Like count
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.comment_outlined),
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
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                IconButton(
                                  icon: const Icon(Icons.share_outlined),
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
                              style: const TextStyle(
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

