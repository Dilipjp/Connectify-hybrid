


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../utils/firebase.dart';

class AuthService {

  final CollectionReference usersRef = FirebaseFirestore.instance.collection('users');

  User getCurrentUser() {
    User user = firebaseAuth.currentUser!;
    return user;
  }
  Future<bool> createUser(
      {
        String? Firstname,
        String? Lastname,
        String? email,
        String? country,
        String? gender,
        String? phnum,
        String? password}) async {
    var res = await firebaseAuth.createUserWithEmailAndPassword(
      email: '$email',
      password: '$password',
    );
    if (res.user != null) {
      await saveUserToFirestore(Firstname!,Lastname!,gender!,phnum!, res.user!,email!, country!);
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
      return false;
    }
  }

  forgotPassword(String email) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  logOut() async {
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
