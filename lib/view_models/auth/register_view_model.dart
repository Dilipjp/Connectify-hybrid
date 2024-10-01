// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import '../../Login/login.dart';
// import '../../services/auth_service.dart';
//
// class RegisterViewModel extends ChangeNotifier {
//   final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
//   final GlobalKey<FormState> formKey = GlobalKey<FormState>();
//   bool loading = false;
//   String? firstname, lastname, email, country, password, confirmPassword, phoneNum, gender;
//
//   FocusNode firstnameFN = FocusNode();
//   FocusNode lastnameFN = FocusNode();
//   FocusNode emailFN = FocusNode();
//   FocusNode countryFN = FocusNode();
//   FocusNode passwordFN = FocusNode();
//   FocusNode confirmPasswordFN = FocusNode();
//   FocusNode phoneNumFN = FocusNode();
//   FocusNode genderFN = FocusNode();
//   AuthService auth = AuthService();
//
//   Future<void> register(BuildContext context) async {
//     if (formKey.currentState!.validate()) {
//       formKey.currentState!.save();
//
//       if (password == confirmPassword) {
//         loading = true;
//         notifyListeners();
//
//         try {
//           bool success = await auth.createUser(
//             firstname: firstname!,
//             lastname: lastname!,
//             email: email!,
//             password: password!,
//             country: country!,
//             phoneNum: phoneNum!,
//             gender: gender!,
//           );
//
//           if (success) {
//             resetFormFields();
//             Navigator.pushReplacement(
//               context,
//               CupertinoPageRoute(
//                 builder: (_) => Login(), // Navigate to Login page
//               ),
//             );
//           } else {
//             showInSnackBar('Registration failed. Please try again.', context);
//           }
//         } catch (e) {
//           loading = false;
//           notifyListeners();
//           showInSnackBar('Error: ${e.toString()}', context);
//         } finally {
//           loading = false;
//           notifyListeners();
//         }
//       } else {
//         showInSnackBar('The passwords do not match', context);
//       }
//     } else {
//       showInSnackBar('All fields are mandatory.', context);
//     }
//   }
//
//   void resetFormFields() {
//     firstname = null;
//     lastname = null;
//     email = null;
//     country = null;
//     password = null;
//     confirmPassword = null;
//     phoneNum = null;
//     gender = null;
//     formKey.currentState?.reset();
//     notifyListeners();
//   }
//
//   void setFname(String val) {
//     firstname = val;
//     notifyListeners();
//   }
//
//   void setLname(String val) {
//     lastname = val;
//     notifyListeners();
//   }
//
//   void setEmail(String val) {
//     email = val;
//     notifyListeners();
//   }
//
//   void setPassword(String val) {
//     password = val;
//     notifyListeners();
//   }
//
//   void setConfirmPass(String val) {
//     confirmPassword = val;
//     notifyListeners();
//   }
//
//   void setCountry(String val) {
//     country = val;
//     notifyListeners();
//   }
//
//   void setGender(String val) {
//     gender = val;
//     notifyListeners();
//   }
//
//   void setPhoneNum(String val) {
//     phoneNum = val;
//     notifyListeners();
//   }
//
//   void showInSnackBar(String value, BuildContext context) {
//     ScaffoldMessenger.of(context).removeCurrentSnackBar();
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
//   }
// }
