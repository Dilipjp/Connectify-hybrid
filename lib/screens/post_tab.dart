
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
class PostTab extends StatefulWidget {
  const PostTab({super.key});

  @override
  State<PostTab> createState() => _PostTabState();
}

class _PostTabState extends State<PostTab> {

  final picker = ImagePicker();
  File? _image;
  final TextEditingController captionController = TextEditingController();
  bool _isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;


  Future<void> pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> uploadPost() async {
    if (_image == null) {
      _showMessageDialog("Please select an image");
      return;
    }
    if (captionController.text.isEmpty) {
      _showMessageDialog("Caption is required");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    String userId = _auth.currentUser?.uid ?? '';
    String fileName = userId + "_" + DateTime.now().millisecondsSinceEpoch.toString();
    Reference storageRef = FirebaseStorage.instance.ref().child('PostImages/$fileName.jpg');

    try {
      UploadTask uploadTask = storageRef.putFile(_image!);
      await uploadTask;
      String downloadUrl = await storageRef.getDownloadURL();

      DatabaseReference postsRef = FirebaseDatabase.instance.reference().child('posts');
      String postId = postsRef.push().key!;
      await postsRef.child(postId).set({
        'postId': postId,
        'postImageUrl': downloadUrl,
        'caption': captionController.text,
        'userId': userId,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });

      setState(() {
        _image = null;
        captionController.clear();
        _isLoading = false;
      });
      _showMessageDialog("Post uploaded successfully!");
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showMessageDialog("Failed to upload post: $e");
    }
  }
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

