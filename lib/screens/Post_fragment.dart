import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PostFragment extends StatefulWidget {
  @override
  _PostFragmentState createState() => _PostFragmentState();
}

class _PostFragmentState extends State<PostFragment> {
  final picker = ImagePicker();
  File? _image;
  final TextEditingController captionController = TextEditingController();

  Future<void> pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> uploadPost() async {
    if (_image == null || captionController.text.isEmpty) {
      return;
    }

    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference storageRef = FirebaseStorage.instance.ref().child('PostImages/$fileName.jpg');
    UploadTask uploadTask = storageRef.putFile(_image!);
    await uploadTask;

    String downloadUrl = await storageRef.getDownloadURL();

    DatabaseReference postsRef = FirebaseDatabase.instance.reference().child('posts');
    String postId = postsRef.push().key!;
    postsRef.child(postId).set({
      'postId': postId,
      'postImageUrl': downloadUrl,
      'caption': captionController.text,
    });

    setState(() {
      _image = null;
      captionController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(onPressed: pickImage, child: Text('Select Image')),
        if (_image != null) Image.file(_image!),
        TextField(controller: captionController, decoration: InputDecoration(hintText: 'Caption')),
        ElevatedButton(onPressed: uploadPost, child: Text('Upload Post')),
      ],
    );
  }
}
