import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectify/models/user.dart';
import 'package:connectify/services/services.dart';
import 'package:connectify/utils/firebase.dart';
import 'package:firebase_database/firebase_database.dart';

class UserService extends Service {
  //get the authenticated uis
  String currentUid() {
    return firebaseAuth.currentUser!.uid;
  }

//tells when the user is online or not and updates the last seen for the messages
  setUserStatus(bool isOnline) {
    var user = firebaseAuth.currentUser;
    if (user != null) {
      usersRef
          .child(user.uid)
          .update({'isOnline': isOnline, 'lastSeen': Timestamp.now()});
    }
  }

  updateProfile({
    File? image,
    String? username,
    String? bio,
    String? country
  }) async {

    DatabaseReference userRef = usersRef.child(currentUid());
    DatabaseEvent event = await userRef.once();
    DataSnapshot snapshot = event.snapshot;

    if (snapshot.exists) {
      // Deserialize the user data into UserModel
      Map<String, dynamic> userData = Map<String, dynamic>.from(snapshot.value as Map);
      var users = UserModel.fromJson(userData);

      users.bio = bio;
      users.country = country;


      if (image != null) {
        users.photoUrl = await uploadImage(profilePic, image);
      }

      // Update user profile in Realtime Database
      await userRef.update({
        'bio': bio,
        'country': country,
        'photoUrl': users.photoUrl ?? '',
      });

      return true;
    }

    return false;  // Handle case when snapshot doesn't exist
  }

}