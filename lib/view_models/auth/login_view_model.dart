import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:connectify/screens/mainscreen.dart';
import 'package:connectify/services/auth_service.dart';
import 'package:connectify/utils/validation.dart';
import 'package:firebase_auth/firebase_auth.dart';


class LoginViewModel extends ChangeNotifier {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
bool validate = false;
bool loading  = false ;
String? email,password;
FocusNode emailFN = FocusNode();
FocusNode passFN = FocusNode();
  AuthService auth = AuthService();
  login(BuildContext context) async {
    FormState form = formKey.currentState!;
    form.save();

    if (!form.validate()) {
      validate = true;
      notifyListeners();
      showInSnackBar('Fill all the fields', context);
      return; // Early return to prevent further execution
    }


    if (email == null || password == null) {
      showInSnackBar('Email and password cannot be empty', context);
      return; // Early return to prevent further execution
    }

    loading = true;
    notifyListeners();
    try {
      bool success = await auth.loginUser(
        email: email!,
        password: password!,
      );
      print(success);
      if (success) {
        Navigator.of(context).pushReplacement(
            CupertinoPageRoute(builder: (_) => TabScreen()));
      }
    } catch (e) {
      loading = false;
      notifyListeners();
      print(e);
      showInSnackBar('${auth.handleFirebaseAuthError(e as FirebaseAuthException)}', context);
    }
    loading = false;
    notifyListeners();
  }

  forgotPassword(BuildContext context) async {
    loading = true;
    notifyListeners();
    FormState form = formKey.currentState!;
    form.save();
    print(Validations.validateEmail(email as String?));
    if (Validations.validateEmail(email as String?) != null) {
      showInSnackBar('Please enter valid email to reset your password.',context);
    }
    else {
      try {
        await auth.forgotPassword(email! as String);
        showInSnackBar('Please check your email  '
            'to reset your password', context);
      } catch (e) {
        showInSnackBar('${e.toString()}', context);
      }
    }
    loading = false;
    notifyListeners();
  }
  setEmail(val) {
    email = val;
    notifyListeners();
  }
  setPassword(val) {
    password = val;
    notifyListeners();
  }
  void showInSnackBar(String value,context) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
  }

  }