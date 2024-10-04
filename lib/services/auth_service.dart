<<<<<<< HEAD
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
=======



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
>>>>>>> f777a7b046bdee987911d81dcfc7ca05fbbb8eaa

import '../utils/firebase.dart';

class AuthService {
<<<<<<< HEAD

  final DatabaseReference usersRef = FirebaseDatabase.instance.reference().child('users');

  User? getCurrentUser() {
    return firebaseAuth.currentUser;
  }

  Future<bool> createUser({
    required String firstname,
    required String lastname,
    required String email,
    required String country,
    required String gender,
    required String password,
    required String phoneNum,
  }) async {
    try {
      UserCredential res = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (res.user != null) {
        await saveUserToRealtimeDatabase(firstname, lastname, gender, phoneNum, res.user!, email, country);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error creating user: $e');
      return false;
    }
  }

  Future<void> saveUserToRealtimeDatabase(
      String firstname,
      String lastname,
      String gender,
      String phoneNum,
      User user,
      String email,
      String country) async {

    // Create a map for user data
    Map<String, dynamic> userData = {
      'firstname': firstname,
      'lastname': lastname,
      'gender': gender,
      'phonenum': phoneNum,
      'email': email,
      'time': ServerValue.timestamp,
      'id': user.uid,
      'country': country,
      // 'photoUrl': user.photoURL ?? '',
    };

    await usersRef.child(user.uid).set(userData);
  }

  Future<bool> loginUser({required String email, required String password}) async {
    try {
      UserCredential res = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return res.user != null;
    } catch (e) {
      print('Error logging in: $e');
=======
  final CollectionReference usersRef = FirebaseFirestore.instance.collection('users');

  User getCurrentUser() {
    User user = firebaseAuth.currentUser!;
    return user;
  }
  Future<bool> createUser(
      {
        String? firstname,
        String? lastname,
        String? email,
        String? country,
        String? gender,
        String? phnum,
        String? password, }) async {
    var res = await firebaseAuth.createUserWithEmailAndPassword(
      email: '$email',
      password: '$password',
    );
    if (res.user != null) {
      await saveUserToFirestore(firstname!,lastname!,gender!,phnum!, res.user!,email!, country!);
      return true;
    } else {
      return false;
    }
  }
  saveUserToFirestore(
      String Firstname, String Lastname, String gender,String phnum, User user, String email, String country) async {
    await usersRef.doc(user.uid).set({
      'firstname': Firstname,
      'lastname' : Lastname,
      'gender' : gender,
      'phnum' : phnum,
      'email': email,
      'time': Timestamp.now(),
      'id': user.uid,
      'country': country,
      'photoUrl': user.photoURL ?? '',

    });
  }

  Future<bool> loginUser({String? email, String? password}) async {
    var res = await firebaseAuth.signInWithEmailAndPassword(
      email: '$email',
      password: '$password',
    );
    if (res.user != null) {
      return true;
    } else {
>>>>>>> f777a7b046bdee987911d81dcfc7ca05fbbb8eaa
      return false;
    }
  }

<<<<<<< HEAD
  Future<void> forgotPassword(String email) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> logOut() async {
=======
  forgotPassword(String email) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  logOut() async {
>>>>>>> f777a7b046bdee987911d81dcfc7ca05fbbb8eaa
    await firebaseAuth.signOut();
  }

  String handleFirebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
<<<<<<< HEAD
      case 'weak-password':
        return "Password is too weak";
      case 'invalid-email':
        return "Invalid Email";
      case 'email-already-in-use':
        return "The email address is already in use by another account.";
      case 'wrong-password':
        return "Invalid credentials.";
=======
    case 'weak-password':
    return "Password is too weak";
    case 'invalid-email':
    return "Invalid Email";
    case 'email-already-in-use':
    return "The email address is already in use by another account.";
    case 'wrong-password':
    return "Invalid credentials.";
>>>>>>> f777a7b046bdee987911d81dcfc7ca05fbbb8eaa
      default:
        return e.message ?? "An unknown error occurred.";
    }
  }
<<<<<<< HEAD
=======

>>>>>>> f777a7b046bdee987911d81dcfc7ca05fbbb8eaa
}
