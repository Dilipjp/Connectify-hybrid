


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
      await saveUserToFirestore(Firstname!,Lastname!, email!, country!);
      return true;
    } else {
      return false;
    }
  }