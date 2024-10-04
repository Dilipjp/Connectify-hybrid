import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:connectify/screens/mainscreen.dart';
import 'package:connectify/services/auth_service.dart';
<<<<<<< HEAD
=======
import 'package:connectify/utils/validation.dart';
>>>>>>> f777a7b046bdee987911d81dcfc7ca05fbbb8eaa
import 'package:firebase_auth/firebase_auth.dart';


class LoginViewModel extends ChangeNotifier {
<<<<<<< HEAD

=======
>>>>>>> f777a7b046bdee987911d81dcfc7ca05fbbb8eaa
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
bool validate = false;
bool loading  = false ;
String? email,password;
<<<<<<< HEAD

FocusNode emailFN = FocusNode();
FocusNode passFN = FocusNode();

=======
FocusNode emailFN = FocusNode();
FocusNode passFN = FocusNode();
>>>>>>> f777a7b046bdee987911d81dcfc7ca05fbbb8eaa
  AuthService auth = AuthService();

  login(BuildContext context) async {
    FormState form = formKey.currentState!;
    form.save();

    if (!form.validate()) {
      validate = true;
      notifyListeners();
<<<<<<< HEAD
      showInSnackBar('Fill all the fields', context);
      return;
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
=======
      showInSnackBar('Fill all the feilds',context);
    }
    else {
      loading = true;
      notifyListeners();
      try {
        bool success = await auth.loginUser(
          email: email,
          password: password,
        );
        print(success);
        if (success) {
          Navigator.of(context).pushReplacement(
              CupertinoPageRoute(builder: (_) => TabScreen()));
        }
      }
      catch (e) {
        loading = false;
        notifyListeners();
        print(e);
        showInSnackBar('${auth.handleFirebaseAuthError(e.toString() as FirebaseAuthException)}',context);
      }
      loading = false;
      notifyListeners();
      }
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
>>>>>>> f777a7b046bdee987911d81dcfc7ca05fbbb8eaa
    }
    loading = false;
    notifyListeners();
  }
<<<<<<< HEAD

=======
>>>>>>> f777a7b046bdee987911d81dcfc7ca05fbbb8eaa
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