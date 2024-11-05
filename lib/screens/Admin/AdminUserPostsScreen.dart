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
  Future<File?> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      return File(pickedImage.path);
    }
    return null;
  }

  // Upload the image to Firebase Storage and return the download URL
  Future<String?> _uploadImage(File image, String postId) async {
    _showLoadingSpinner(context);

    try {
      String filePath = 'posts/$postId/${DateTime.now().millisecondsSinceEpoch}.png';
      Reference storageRef = _storage.ref().child(filePath);
      UploadTask uploadTask = storageRef.putFile(image);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    } finally {
      _hideLoadingSpinner(context);
    }
  }
  // Edit post (caption and postImageUrl)
  void _editPost(String postId, String currentCaption, String currentImageUrl) async {
    TextEditingController captionController = TextEditingController(text: currentCaption);
    File? newImageFile;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Post'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: captionController,
                decoration: InputDecoration(labelText: 'Caption'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  newImageFile = await _pickImage(); // Pick new image
                  if (newImageFile != null) {
                    captionController.text = 'Image selected. Will be uploaded.'; // Show placeholder text
                  }
                },
                child: Text('Pick New Image'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                String? newImageUrl;

                // If a new image was selected, upload it to Firebase Storage
                if (newImageFile != null) {
                  newImageUrl = await _uploadImage(newImageFile!, postId);
                }

                // Update Firebase Realtime Database with the new caption and (optional) image URL
                DatabaseReference postRef = _database.ref('posts/$postId');
                postRef.update({
                  'caption': captionController.text,
                  'postImageUrl': newImageUrl ?? currentImageUrl, // Update URL only if a new one was uploaded
                }).then((_) {
                  setState(() {
                    for (var post in userPosts) {
                      if (post['postId'] == postId) {
                        post['caption'] = captionController.text;
                        if (newImageUrl != null) {
                          post['postImageUrl'] = newImageUrl;
                        }
                      }
                    }
                  });
                  Navigator.of(context).pop();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Post updated successfully')),
                  );
                }).catchError((error) {
                  print('Error updating post: $error');
                });
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
  void _sendOrRemoveWarning(String postId) {
    final DatabaseReference warningRef = _database.ref('users/${widget.userId}/userWarnings');

    // Check if a warning already exists for the post
    warningRef.orderByChild('postId').equalTo(postId).once().then((DatabaseEvent snapshot) {
      if (snapshot.snapshot.children.isNotEmpty) { // Check if any warnings exist
        // Warning exists, show dialog to remove it
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Remove Warning'),
              content: Text('Are you sure you want to remove the warning for this post?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Remove warning
                    for (var child in snapshot.snapshot.children) {
                      child.ref.remove();
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Warning removed successfully')),
                    );
                    Navigator.of(context).pop();
                  },
                  child: Text('Remove Warning'),
                ),
              ],
            );
          },
        );
      } else {
        // No warning exists, show dialog to send a new one
        TextEditingController warningController = TextEditingController(text: "Please review the content of this post.");

        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Send Warning'),
              content: TextField(
                controller: warningController,
                decoration: InputDecoration(labelText: 'Warning Message'),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Get the current timestamp
                    int timestamp = DateTime.now().millisecondsSinceEpoch;

                    // Save warning message to userWarnings
                    DatabaseReference userWarningsRef = warningRef.push();
                    userWarningsRef.set({
                      'message': warningController.text,
                      'postId': postId,
                      'timestamp': timestamp,
                    }).then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Warning sent successfully')),
                      );
                      Navigator.of(context).pop();
                    }).catchError((error) {
                      print('Error sending warning: $error');
                    });
                  },
                  child: Text('Send'),
                ),
              ],
            );
          },
        );
      }
    });
  }

