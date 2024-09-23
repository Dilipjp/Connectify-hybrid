

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth_platform_interface/src/firebase_auth_exception.dart';
import 'package:flutter/foundation.dart';
import 'package:connectify/services/auth_service.dart';
class Registration extends ChangeNotifier {

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool validate = false;
  bool loading = false;
  String? Firstname,LastName,email,country,password,cPassword,phnum,gender;

  FocusNode FirstnameFN = FocusNode();
  FocusNode LastnameFN = FocusNode();
  FocusNode emailFN = FocusNode();
  FocusNode countryFN = FocusNode();
  FocusNode passwordFN = FocusNode();
  FocusNode cPasswordFN = FocusNode();
  FocusNode phnumFN = FocusNode();
  FocusNode genderFN = FocusNode();

  register(BuildContext context) async {
    FormState form = formKey.currentState!;
    form.save();

    if (!form.validate()) {
      validate = true;
      notifyListeners();
      showInSnackBar(
          'All feilds are mandatory.', context);
    }
    else {
      if (password == cPassword) {
        loading = true;
        notifyListeners();
        try {
          bool success = await auth.createUser(
            firstname: Firstname,
            lastname: LastName,
            email: email,
            password: password,
            country: country,
            phnum: phnum,
            gender: gender,
          );
        }
        catch (e) {
          loading = false;
          notifyListeners();
          print(e);
          showInSnackBar(
              '${auth.handleFirebaseAuthError(e.toString() as FirebaseAuthException)}', context);
        }
        loading = false;
        notifyListeners();
      } else {
        showInSnackBar('The passwords does not match', context);
      }
    }
  }

  setFname(val) {
    Firstname = val;
    notifyListeners();
  }
  setLname(val) {
    LastName = val;
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
  setConfirmPass(val) {
    cPassword = val;
    notifyListeners();
  }

  setCountry(val) {
    country = val;
    notifyListeners();
  }
  setGender(val) {
    gender = val;
    notifyListeners();
  }
  setPhoneNum(val) {
    phnum = val;
    notifyListeners();
  }

  void showInSnackBar(String value, context) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
  }

}
