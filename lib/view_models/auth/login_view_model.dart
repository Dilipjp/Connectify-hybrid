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
Stream? email,password;
FocusNode emailFN = FocusNode();
FocusNode passFN = FocusNode();
AuthService auth = AuthSevice();
