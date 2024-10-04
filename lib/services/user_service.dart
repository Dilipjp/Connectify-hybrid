import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectify/models/user.dart';
import 'package:connectify/services/services.dart';
import 'package:connectify/utils/firebase.dart';
<<<<<<< HEAD
import 'package:firebase_database/firebase_database.dart';
=======
>>>>>>> f777a7b046bdee987911d81dcfc7ca05fbbb8eaa

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
<<<<<<< HEAD
          .child(user.uid)
=======
          .doc(user.uid)
>>>>>>> f777a7b046bdee987911d81dcfc7ca05fbbb8eaa
          .update({'isOnline': isOnline, 'lastSeen': Timestamp.now()});
    }
  }

<<<<<<< HEAD
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

    return false;
  }

}
=======
//updates user profile in the Edit Profile Screen
  updateProfile(
      {File? image, String? username, String? bio, String? country}) async {
    DocumentSnapshot doc = await usersRef.doc(currentUid()).get();
    var users = UserModel.fromJson(doc.data() as Map<String, dynamic>);
    users.bio = bio;
    users.country = country;
    if (image != null) {
      users.photoUrl = await uploadImage(profilePic, image);
    }
    await usersRef.doc(currentUid()).update({

      'bio': bio,
      'country': country,
      "photoUrl": users.photoUrl ?? '',
    });

    return true;
  }
}
>>>>>>> f777a7b046bdee987911d81dcfc7ca05fbbb8eaa
