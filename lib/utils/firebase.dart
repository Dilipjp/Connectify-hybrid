import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_database/firebase_database.dart';

FirebaseAuth firebaseAuth = FirebaseAuth.instance;
//FirebaseFirestore firestore = FirebaseFirestore.instance;
FirebaseDatabase database = FirebaseDatabase.instance;
FirebaseStorage storage = FirebaseStorage.instance;
final Uuid uuid = Uuid();




// Collection refs

DatabaseReference usersRef = FirebaseDatabase.instance.ref('users');
DatabaseReference chatRef = FirebaseDatabase.instance.ref('chats');
DatabaseReference postRef = FirebaseDatabase.instance.ref('posts');
DatabaseReference storyRef = FirebaseDatabase.instance.ref('posts');
DatabaseReference commentRef = FirebaseDatabase.instance.ref('comments');
DatabaseReference notificationRef = FirebaseDatabase.instance.ref('notifications');
DatabaseReference followersRef = FirebaseDatabase.instance.ref('followers');
DatabaseReference followingRef = FirebaseDatabase.instance.ref('following');
DatabaseReference likesRef = FirebaseDatabase.instance.ref('likes');
DatabaseReference favUsersRef = FirebaseDatabase.instance.ref('favoriteUsers');
DatabaseReference chatIdRef = FirebaseDatabase.instance.ref('chatIds');
DatabaseReference statusRef = FirebaseDatabase.instance.ref('status');


// CollectionReference usersRef = firestore.collection('users');
// CollectionReference chatRef = firestore.collection("chats");
// CollectionReference postRef = firestore.collection('posts');
// CollectionReference storyRef = firestore.collection('posts');
// CollectionReference commentRef = firestore.collection('comments');
// CollectionReference notificationRef = firestore.collection('notifications');
// CollectionReference followersRef = firestore.collection('followers');
// CollectionReference followingRef = firestore.collection('following');
// CollectionReference likesRef = firestore.collection('likes');
// CollectionReference favUsersRef = firestore.collection('favoriteUsers');
// CollectionReference chatIdRef = firestore.collection('chatIds');
// CollectionReference statusRef = firestore.collection('status');

// Storage refs
Reference profilePic = storage.ref().child('profilePic');
Reference posts = storage.ref().child('posts');
Reference statuses = storage.ref().child('status');
