import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../utils/firebase.dart';

class AuthService {

  final DatabaseReference usersRef = FirebaseDatabase.instance.ref('users');

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
        await saveUserToFirestore(firstname, lastname, gender, phoneNum, res.user!, email, country);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error creating user: $e');
      return false;
    }
  }

  Future<void> saveUserToFirestore(
      String firstname,
      String lastname,
      String gender,
      String phoneNum,
      User user,
      String email,
      String country) async {
    await usersRef.child(user.uid).set({
      'firstname': firstname,
      'lastname': lastname,
      'gender': gender,
      'phonenum': phoneNum,
      'email': email,
      'time': Timestamp.now(),
      'id': user.uid,
      'country': country,
      // 'photoUrl': user.photoURL ?? '',
    });
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
      return false;
    }
  }

  Future<void> forgotPassword(String email) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> logOut() async {
    await firebaseAuth.signOut();
  }

  String handleFirebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return "Password is too weak";
      case 'invalid-email':
        return "Invalid Email";
      case 'email-already-in-use':
        return "The email address is already in use by another account.";
      case 'wrong-password':
        return "Invalid credentials.";
      default:
        return e.message ?? "An unknown error occurred.";
    }
  }
}
