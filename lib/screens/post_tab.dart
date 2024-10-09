import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class PostTab extends StatefulWidget {
  @override
  _PostTabState createState() => _PostTabState();
}

class _PostTabState extends State<PostTab> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final TextEditingController _captionController = TextEditingController();

  File? _selectedImage;
  bool _isLoading = false;
  String? _location; // Variable to store location
  String? _locationName; // Variable to store location name (city)

  Future<void> _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      // Request permission
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permission was denied
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Location permissions are denied')),
        );
        return;
      }
    }

    // Check if permission is granted
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location permissions are permanently denied. Please enable them in settings.')),
      );
      return;
    }

    // If permissions are granted, get the location
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _location = '${position.latitude}, ${position.longitude}'; // Store location as string
      });

      // Get the location name (city)
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        _locationName = placemarks[0].locality; // Get the city name
        print('Location Name: $_locationName');
      }
    } catch (e) {
      print('Error getting location: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error getting location: $e')),
      );
    }
  }

  Future<void> _uploadPost() async {
    if (_selectedImage == null || _captionController.text.isEmpty || _locationName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an image, write a caption, and allow location access.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        String userId = currentUser.uid;
        String postId = Uuid().v4(); // Generate a unique postId
        String fileName = 'posts/$postId.jpg';

        // Upload image to Firebase Storage
        UploadTask uploadTask = _storage.ref(fileName).putFile(_selectedImage!);
        TaskSnapshot taskSnapshot = await uploadTask;
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();

        // Save post data to Firebase Realtime Database
        DatabaseReference postRef = _database.ref('posts/$postId');
        await postRef.set({
          'postId': postId,
          'caption': _captionController.text,
          'postImageUrl': downloadUrl,
          'timestamp': DateTime.now().toIso8601String(),
          'userId': userId,
          'location': _location, // Save coordinates
          'locationName': _locationName, // Save city name
        });

        // Success
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Post uploaded successfully!')),
        );

        // Clear fields
        _captionController.clear();
        setState(() {
          _selectedImage = null;
          _location = null; // Clear location
          _locationName = null; // Clear location name
        });

        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (error) {
      print('Error uploading post: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading post: $error')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Post',
          style: TextStyle(color: Colors.white), // Set text color to white
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_selectedImage != null)
              Image.file(
                _selectedImage!,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text(_selectedImage == null ? 'Pick Image' : 'Change Image'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _captionController,
              decoration: InputDecoration(
                labelText: 'Write a caption...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getCurrentLocation, // Get current location
              child: Text('Get Current Location'),
            ),
            SizedBox(height: 20),
            if (_locationName != null) // Display the location name (city) if available
              Text(
                'Location: $_locationName',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            SizedBox(height: 20),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : ElevatedButton(
              onPressed: _uploadPost,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
              child: Text('Upload Post', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
