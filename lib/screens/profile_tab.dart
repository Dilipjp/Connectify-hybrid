import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'edit_profile_screen.dart';
import 'moderator/ModeratorUsersScreen.dart';
import 'user_posts_screen.dart';
import 'all_posts_screen.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

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
  String? userId;
  String? userRole;
  int postCount = 0;
  int followingCount = 0;
  int followersCount = 0;
  List<Map<String, dynamic>> warnings = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadUserPostsCount();
    _loadFollowingCount();
    _loadFollowersCount();
  }

  // Real-time listener for user data changes
  void _loadUserData() async {
    User? currentUser = _auth.currentUser;

    if (currentUser != null) {
      userId = currentUser.uid;
      DatabaseReference userRef = _database.ref('users/$userId');

      // Set a real-time listener using onValue
      userRef.onValue.listen((DatabaseEvent event) {
        if (event.snapshot.exists) {
          Map<dynamic, dynamic> userData = event.snapshot.value as Map;

          setState(() {
            userName = userData['userName'] ?? 'Unknown';
            userBio = userData['userBio'] ?? 'No bio available';
            userProfileImage = userData['userProfileImage'] ?? 'assets/profile_placeholder.png';
            userEmail = userData['userEmail'] ?? 'No email available';
            userRole = userData['userRole'] ?? 'User';
          });
        }
      }, onError: (error) {
        print('Error loading user data: $error');
      });
    }
  }

  // Fetch and count user's posts
  void _loadUserPostsCount() async {
    User? currentUser = _auth.currentUser;

    if (currentUser != null) {
      String userId = currentUser.uid;
      DatabaseReference postsRef = _database.ref('posts');

      // Query to get posts for the current user
      postsRef.orderByChild('userId').equalTo(userId).onValue.listen((DatabaseEvent event) {
        if (event.snapshot.exists) {
          Map<dynamic, dynamic> posts = event.snapshot.value as Map;
          setState(() {
            postCount = posts.length; // Set the count of the user's posts
          });
        } else {
          setState(() {
            postCount = 0; // No posts found, set count to 0
          });
        }
      }, onError: (error) {
        print('Error loading post count: $error');
      });
    }
  }

  // Fetch and count user's following count
  void _loadFollowingCount() async {
    User? currentUser = _auth.currentUser;

    if (currentUser != null) {
      String currentUserId = currentUser.uid;
      DatabaseReference usersRef = _database.ref('users');

      int followingCount = 0;

      usersRef.onValue.listen((DatabaseEvent event) {
        if (event.snapshot.exists) {
          Map<dynamic, dynamic> usersData = event.snapshot.value as Map;

          // Iterate over all users to check if the current user is a follower
          usersData.forEach((userId, userData) {
            if (userData['followers'] != null && userData['followers'].containsKey(currentUserId)) {
              followingCount++;
            }
          });

          setState(() {
            // Update the state with the count of users the current user is following
            this.followingCount = followingCount;
          });
        } else {
          setState(() {
            this.followingCount = 0;
          });
        }
      }, onError: (error) {
        print('Error loading following count: $error');
      });
    }
  }
  void _loadFollowersCount() async {
    User? currentUser = _auth.currentUser;

    if (currentUser != null) {
      String currentUserId = currentUser.uid;
      DatabaseReference followersRef = _database.ref('users/$currentUserId/followers');

      followersRef.onValue.listen((DatabaseEvent event) {
        if (event.snapshot.exists) {
          Map<dynamic, dynamic> followersData = event.snapshot.value as Map;
          setState(() {
            // Update the state with the count of followers
            followersCount = followersData.length;
          });
        } else {
          setState(() {
            followersCount = 0;
          });
        }
      }, onError: (error) {
        print('Error loading followers count: $error');
      });
    }
  }

  // load warnings;
  void _loadWarnings() async {
    if (userId != null) {
      DatabaseReference warningsRef = _database.ref('users/$userId/userWarnings');

      warningsRef.onValue.listen((DatabaseEvent event) async {
        if (event.snapshot.exists) {
          Map<dynamic, dynamic> warningsData = event.snapshot.value as Map;
          List<Map<String, dynamic>> loadedWarnings = [];

          for (var warningKey in warningsData.keys) {
            var warning = warningsData[warningKey];
            String postId = warning['postId'];
            String message = warning['message'];

            // Fetch caption from posts node
            DatabaseReference postRef = _database.ref('posts/$postId');
            DataSnapshot postSnapshot = await postRef.get();

            if (postSnapshot.exists) {
              String caption = postSnapshot.child('caption').value as String;
              loadedWarnings.add({
                'message': message,
                'caption': caption,
                'postId': postId,
              });
            } else {
              loadedWarnings.add({
                'message': message,
                'caption': 'Caption not found', // Fallback in case the post is missing
                'postId': postId,
              });
            }
          }

          setState(() {
            warnings = loadedWarnings;
          });

          print("Warnings with captions loaded: $warnings");
        } else {
          setState(() {
            warnings = [];
          });
          print("No warnings found for the user.");
        }
      }, onError: (error) {
        print('Error loading warnings: $error');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: userProfileImage != null
                        ? NetworkImage(userProfileImage!)
                        : const AssetImage('assets/profile_placeholder.png') as ImageProvider,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    userName ?? 'Loading...',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    userBio ?? '@loading_bio',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  if (userRole == 'User' && warnings.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Warnings:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: warnings.length,
                            itemBuilder: (context, index) {
                              final warning = warnings[index] as Map<String, dynamic>; // Cast to Map<String, dynamic>
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5),
                                child: Text(
                                  "- ${warning['message']} (Caption: ${warning['caption']})",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.red,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    // Navigate to UserPostsScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserPostsScreen(userId: userId!),
                      ),
                    );
                  },
                  child: _buildStatColumn('Posts', postCount.toString()),
                ),
                _buildStatColumn('Followers', followersCount.toString()),
                _buildStatColumn('Following', followingCount.toString()),
              ],
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EditProfileScreen())).then((_) {
                    // Trigger data reload after returning from EditProfileScreen
                    _loadUserData();
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Center(
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
        // All Posts button (only for Moderators)
    if (userRole == 'Moderator')
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ModeratorUsersScreen()),
            );
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
              'All Posts',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
            const SizedBox(height: 20),
            // All Posts button (only for Moderators)
            if (userRole == 'moderator')
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AllPostsScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Center(
                    child: Text(
                      'All Posts',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    await _auth.signOut();
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
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Center(
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
            const SizedBox(height: 30),
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
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
