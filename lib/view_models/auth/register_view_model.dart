

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Registration extends ChangeNotifier {

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool validate = false;
  bool loading = false;
  String? Firstname,LastName,email,country,password,cpassword,phnum,gender;

  FocusNode FirstnameFN = FocusNode();
  FocusNode LastnameFN = FocusNode();
  FocusNode emailFN = FocusNode();
  FocusNode countryFN = FocusNode();
  FocusNode passwordFN = FocusNode();
  FocusNode cpasswordFN = FocusNode();
  FocusNode phnumFN = FocusNode();
  FocusNode genderFN = FocusNode();



}
