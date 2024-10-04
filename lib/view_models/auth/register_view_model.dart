<<<<<<< HEAD
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../Login/login.dart';
import '../../services/auth_service.dart';

class RegisterViewModel extends ChangeNotifier {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool loading = false;
  String? firstname, lastname, email, country, password, confirmPassword, phoneNum, gender;

  FocusNode firstnameFN = FocusNode();
  FocusNode lastnameFN = FocusNode();
  FocusNode emailFN = FocusNode();
  FocusNode countryFN = FocusNode();
  FocusNode passwordFN = FocusNode();
  FocusNode confirmPasswordFN = FocusNode();
  FocusNode phoneNumFN = FocusNode();
  FocusNode genderFN = FocusNode();
  AuthService auth = AuthService();

  Future<void> register(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      if (password == confirmPassword) {
        loading = true;
        notifyListeners();

        try {
          bool success = await auth.createUser(
            firstname: firstname!,
            lastname: lastname!,
            email: email!,
            password: password!,
            country: country!,
            phoneNum: phoneNum!,
            gender: gender!,
          );

          if (success) {
            resetFormFields();
            Navigator.pushReplacement(
              context,
              CupertinoPageRoute(
                builder: (_) => Login(),
              ),
            );
          } else {
            showInSnackBar('Registration failed. Please try again.', context);
          }
        } catch (e) {
          loading = false;
          notifyListeners();
          showInSnackBar('Error: ${e.toString()}', context);
        } finally {
          loading = false;
          notifyListeners();
        }
      } else {
        showInSnackBar('The passwords do not match', context);
      }
    } else {
      showInSnackBar('All fields are mandatory.', context);
    }
  }

  void resetFormFields() {
    firstname = null;
    lastname = null;
    email = null;
    country = null;
    password = null;
    confirmPassword = null;
    phoneNum = null;
    gender = null;
    formKey.currentState?.reset();
    notifyListeners();
  }

  void setFname(String val) {
    firstname = val;
    notifyListeners();
  }

  void setLname(String val) {
    lastname = val;
    notifyListeners();
  }

  void setEmail(String val) {
=======

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth_platform_interface/src/firebase_auth_exception.dart';
import 'package:flutter/foundation.dart';

import '../../services/auth_service.dart';



class RegisterViewModel extends ChangeNotifier {

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool validate = false;
  bool loading = false;
  String? Firstname,Lastname,email,country,password,cPassword,phnum,gender;

  FocusNode FirstnameFN = FocusNode();
  FocusNode LastnameFN = FocusNode();
  FocusNode emailFN = FocusNode();
  FocusNode countryFN = FocusNode();
  FocusNode passwordFN = FocusNode();
  FocusNode cPasswordFN = FocusNode();
  FocusNode phnumFN = FocusNode();
  FocusNode genderFN = FocusNode();
  AuthService auth = AuthService();


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
            lastname: Lastname,
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
    Lastname = val;
    notifyListeners();
  }
  setEmail(val) {
>>>>>>> f777a7b046bdee987911d81dcfc7ca05fbbb8eaa
    email = val;
    notifyListeners();
  }

<<<<<<< HEAD
  void setPassword(String val) {
    password = val;
    notifyListeners();
  }

  void setConfirmPass(String val) {
    confirmPassword = val;
    notifyListeners();
  }

  void setCountry(String val) {
    country = val;
    notifyListeners();
  }

  void setGender(String val) {
    gender = val;
    notifyListeners();
  }

  void setPhoneNum(String val) {
    phoneNum = val;
    notifyListeners();
  }

  void showInSnackBar(String value, BuildContext context) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
  }
=======
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

>>>>>>> f777a7b046bdee987911d81dcfc7ca05fbbb8eaa
}
