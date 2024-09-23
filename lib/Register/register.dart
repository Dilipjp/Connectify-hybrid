import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:connectify/view_models/auth/register_view_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';

import '../components/text_form_builder.dart';
import '../utils/validation.dart';
import '../widgets/indicators.dart';


class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  @override
  Widget build(BuildContext context) {
    RegisterViewModel viewModel = Provider.of<RegisterViewModel>(context);
    return LoadingOverlay(
        progressIndicator: circularProgress(context),
    isLoading: viewModel.loading,
    child: Scaffold(
    key: viewModel.scaffoldKey,
    body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
        children: [
    SizedBox(height: MediaQuery.of(context).size.height / 10),
      Text(
        'Welcome to Connectify\nCreate a new account ',
        style: GoogleFonts.nunitoSans(
          fontWeight: FontWeight.bold,
          fontSize: 25.0,
        ),
      ),
      SizedBox(height: 30.0),
      buildForm(viewModel, context),
      SizedBox(height: 30.0),

      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Already have an account  ',
          ),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Text(
              'Login',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
        ],
      ),
        ],
    ),
    ),
    );
  }

  buildForm(RegisterViewModel viewModel, BuildContext context) {
    return Form(
        key: viewModel.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
        children: [
        TextFormBuilder(
        enabled: !viewModel.loading,
        prefix: Ionicons.person_outline,
        hintText: "Firstname",
        textInputAction: TextInputAction.next,
        validateFunction: Validations.validateName,
        onSaved: (String val) {
      viewModel.setFname(val);
    },
    focusNode: viewModel.FirstnameFN,
    nextFocusNode: viewModel.LastnameFN, obscureText: false,
    ),
    SizedBox(height: 20.0),

    TextFormBuilder(
    enabled: !viewModel.loading,
    prefix: Ionicons.person_outline,
    hintText: "Lastname",
    textInputAction: TextInputAction.next,
    validateFunction: Validations.validateName,
    onSaved: (String val) {
    viewModel.setLname(val);
    },
    focusNode: viewModel.FirstnameFN,
    nextFocusNode: viewModel.emailFN, obscureText: false,
    ),
    SizedBox(height: 20.0),

    TextFormBuilder(
    enabled: !viewModel.loading,
    prefix: Ionicons.person_outline,
    hintText: "email",
    textInputAction: TextInputAction.next,
    validateFunction: Validations.validateName,
    onSaved: (String val) {
    viewModel.setEmail(val);
    },
    focusNode: viewModel.emailFN,
    nextFocusNode: viewModel.passwordFN, obscureText: false,
    ),
    SizedBox(height: 20.0),
    TextFormBuilder(
    enabled: !viewModel.loading,
    prefix: Ionicons.person_outline,
    hintText: "password",
    textInputAction: TextInputAction.next,
    validateFunction: Validations.validateName,
    onSaved: (String val) {
    viewModel.setPassword(val);
    },
    focusNode: viewModel.passwordFN,
    nextFocusNode: viewModel.cPasswordFN, obscureText: false,
    ),
    SizedBox(height: 20.0),
    TextFormBuilder(
    enabled: !viewModel.loading,
    prefix: Ionicons.person_outline,
    hintText: "confirm password",
    textInputAction: TextInputAction.next,
    validateFunction: Validations.validateName,
    onSaved: (String val) {
    viewModel.setConfirmPass(val);
    },
    focusNode: viewModel.cPasswordFN,
    nextFocusNode: viewModel.countryFN, obscureText: true,
    ),
    SizedBox(height: 20.0),
    TextFormBuilder(
    enabled: !viewModel.loading,
    prefix: Ionicons.person_outline,
    hintText: " country ",
    textInputAction: TextInputAction.next,
    validateFunction: Validations.validateName,
    onSaved: (String val) {
    viewModel.setCountry(val);
    },
    focusNode: viewModel.countryFN,
    nextFocusNode: viewModel.genderFN, obscureText: false,
    ),
    SizedBox(height: 20.0),
    TextFormBuilder(
    enabled: !viewModel.loading,
    prefix: Ionicons.person_outline,
    hintText: " gender ",
    textInputAction: TextInputAction.next,
    validateFunction: Validations.validateName,
    onSaved: (String val) {
    viewModel.setGender(val);
    },
    focusNode: viewModel.genderFN,
    nextFocusNode: viewModel.phnumFN, obscureText: false,
    ),
    SizedBox(height: 20.0),

    TextFormBuilder(
    enabled: !viewModel.loading,
    prefix: Ionicons.person_outline,
    hintText: " Your phone num ",
    textInputAction: TextInputAction.next,
    validateFunction: Validations.validateName,
    onSaved: (String val) {
    viewModel.setPhoneNum(val);
    },
    focusNode: viewModel.phnumFN, obscureText: false,
    ),
    SizedBox(height: 20.0),
          Container(
            height: 45.0,
            width: 180.0,
            child: ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                ),
                backgroundColor: MaterialStateProperty.all<Color>(
                    Theme.of(context).colorScheme.secondary),
              ),
              child: Text(
                'sign up'.toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () async {
                bool isRegistered = await viewModel.register(context);
                if (isRegistered) {
                  Navigator.pop(context);
                }
              },

            ),
          ),
        ],
        ),
    );
  }

}
