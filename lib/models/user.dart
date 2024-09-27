import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? Firstname;
  String? Lastname;
  String? gender;
  String? phnum;
  String? email;
  String? photoUrl;
  String? country;
  String? bio;
  String? id;
  Timestamp? signedUpAt;
  Timestamp? lastSeen;
  bool? isOnline;


  UserModel(
      this.Firstname,
      this.Lastname,
      this.gender,
      this.phnum,
      this.email,
      this.photoUrl,
      this.country,
      this.bio,
      this.id,
      this.signedUpAt,
      this.lastSeen,
      this.isOnline);

  UserModel.fromJson(Map<String, dynamic> json) {
    Firstname = json['firstname'];
    Lastname = json['lastname'];
    gender = json['gender'];
    phnum = json['phnum'];
    email = json['email'];
    country = json['country'];
    photoUrl = json['photoUrl'];
    signedUpAt = json['signedUpAt'];
    isOnline = json['isOnline'];
    lastSeen = json['lastSeen'];
    bio = json['bio'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstname'] = this.Firstname;
    data['lastname'] = this.Lastname;
    data['gender'] = this.gender;
    data['phnum'] = this.phnum;
    data['country'] = this.country;
    data['email'] = this.email;
    data['photoUrl'] = this.photoUrl;
    data['bio'] = this.bio;
    data['signedUpAt'] = this.signedUpAt;
    data['isOnline'] = this.isOnline;
    data['lastSeen'] = this.lastSeen;
    data['id'] = this.id;
    return data;
  }
}
