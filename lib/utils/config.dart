import 'package:firebase_core/firebase_core.dart';


class Config {
  static Future<void> initFirebase({required FirebaseOptions options}) async {
    await Firebase.initializeApp(options: options);
  }
}