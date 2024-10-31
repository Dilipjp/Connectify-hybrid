import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ModeratorUserPostsScreen extends StatefulWidget {
  final String userId;

  ModeratorUserPostsScreen({required this.userId});

  @override
  _ModeratorUserPostsScreenState createState() => _ModeratorUserPostsScreenState();
}

class _ModeratorUserPostsScreenState extends State<ModeratorUserPostsScreen> {
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

  // Load user's posts
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

  // Pick image from gallery
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




