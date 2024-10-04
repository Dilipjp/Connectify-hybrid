import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:connectify/view_models/auth/register_view_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
<<<<<<< HEAD
=======

>>>>>>> f777a7b046bdee987911d81dcfc7ca05fbbb8eaa
import '../components/password_text_field.dart';
import '../components/text_form_builder.dart';
import '../utils/validation.dart';
import '../widgets/indicators.dart';

<<<<<<< HEAD
=======

>>>>>>> f777a7b046bdee987911d81dcfc7ca05fbbb8eaa
class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
<<<<<<< HEAD
=======

>>>>>>> f777a7b046bdee987911d81dcfc7ca05fbbb8eaa
  @override
  Widget build(BuildContext context) {
    RegisterViewModel viewModel = Provider.of<RegisterViewModel>(context);
    return LoadingOverlay(
<<<<<<< HEAD
      progressIndicator: circularProgress(context),
      isLoading: viewModel.loading,
      child: Scaffold(
        key: viewModel.scaffoldKey,
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
          children: [
            Container(
              height: 170.0,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: Image.asset('assets/images/login.png'
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 10),
            Center(
              child:Text(
              'Welcome to Connectify ',
              style: GoogleFonts.nunitoSans(
                fontWeight: FontWeight.bold,
                fontSize: 25.0,
              ),
            ),),
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
=======
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
>>>>>>> f777a7b046bdee987911d81dcfc7ca05fbbb8eaa
    );
  }

  buildForm(RegisterViewModel viewModel, BuildContext context) {
    return Form(
<<<<<<< HEAD
      key: viewModel.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          TextFormBuilder(
            enabled: !viewModel.loading,
            prefix: Ionicons.person_outline,
            hintText: "Firstname",
            validateFunction: Validations.validateName,
            onSaved: (String val) {
              viewModel.setFname(val);
            },
            focusNode: viewModel.firstnameFN,
            nextFocusNode: viewModel.lastnameFN,
            obscureText: false,
          ),
          SizedBox(height: 20.0),
          TextFormBuilder(
            enabled: !viewModel.loading,
            prefix: Ionicons.person_outline,
            hintText: "Lastname",
            validateFunction: Validations.validateName,
            onSaved: (String val) {
              viewModel.setLname(val);
            },
            focusNode: viewModel.lastnameFN,
            nextFocusNode: viewModel.emailFN,
            obscureText: false,
          ),
          SizedBox(height: 20.0),
=======
        key: viewModel.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
        children: [
        TextFormBuilder(
        enabled: !viewModel.loading,
        prefix: Ionicons.person_outline,
        hintText: "Firstname",
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
    validateFunction: Validations.validateName,
    onSaved: (String val) {
    viewModel.setLname(val);
    },
    focusNode: viewModel.LastnameFN,
    nextFocusNode: viewModel.emailFN, obscureText: false,
    ),
          SizedBox(height: 20.0),

>>>>>>> f777a7b046bdee987911d81dcfc7ca05fbbb8eaa
          TextFormBuilder(
            enabled: !viewModel.loading,
            prefix: Ionicons.mail_outline,
            hintText: "Email",
            validateFunction: Validations.validateEmail,
            onSaved: (String val) {
              viewModel.setEmail(val);
            },
            focusNode: viewModel.emailFN,
<<<<<<< HEAD
            nextFocusNode: viewModel.countryFN,
            obscureText: false,
          ),
          SizedBox(height: 20.0),
=======
            nextFocusNode: viewModel.countryFN, obscureText: false,
          ),
    SizedBox(height: 20.0),

>>>>>>> f777a7b046bdee987911d81dcfc7ca05fbbb8eaa
          PasswordFormBuilder(
            enabled: !viewModel.loading,
            prefix: Ionicons.lock_closed_outline,
            suffix: Ionicons.eye_outline,
            hintText: "Password",
            validateFunction: Validations.validatePassword,
            obscureText: true,
            onSaved: (String val) {
              viewModel.setPassword(val);
            },
            focusNode: viewModel.passwordFN,
<<<<<<< HEAD
            nextFocusNode: viewModel.confirmPasswordFN,
          ),
          SizedBox(height: 20.0),
=======
             nextFocusNode: viewModel.cPasswordFN,
          ),
          SizedBox(height: 20.0),

>>>>>>> f777a7b046bdee987911d81dcfc7ca05fbbb8eaa
          PasswordFormBuilder(
            enabled: !viewModel.loading,
            prefix: Ionicons.lock_open_outline,
            hintText: "Confirm Password",
            textInputAction: TextInputAction.done,
            validateFunction: Validations.validatePassword,
            submitAction: () => viewModel.register(context),
            obscureText: true,
            onSaved: (String val) {
              viewModel.setConfirmPass(val);
            },
<<<<<<< HEAD
            focusNode: viewModel.confirmPasswordFN,
          ),
          SizedBox(height: 25.0),
          TextFormBuilder(
            enabled: !viewModel.loading,
            prefix: Ionicons.person_outline,
            hintText: "Country",
            validateFunction: Validations.validateName,
            onSaved: (String val) {
              viewModel.setCountry(val);
            },
            focusNode: viewModel.countryFN,
            nextFocusNode: viewModel.genderFN,
            obscureText: false,
          ),
          SizedBox(height: 20.0),
          TextFormBuilder(
            enabled: !viewModel.loading,
            prefix: Ionicons.person_outline,
            hintText: "Gender",
            validateFunction: Validations.validateName,
            onSaved: (String val) {
              viewModel.setGender(val);
            },
            focusNode: viewModel.genderFN,
            nextFocusNode: viewModel.phoneNumFN,
            obscureText: false,
          ),
          SizedBox(height: 20.0),
          TextFormBuilder(
            enabled: !viewModel.loading,
            prefix: Ionicons.person_outline,
            hintText: "Your phone number",
            validateFunction: Validations.validateName,
            onSaved: (String val) {
              viewModel.setPhoneNum(val);
            },
            focusNode: viewModel.phoneNumFN,
            obscureText: false,
          ),
          SizedBox(height: 20.0),
=======
            focusNode: viewModel.cPasswordFN,
          ),
          SizedBox(height: 25.0),
    TextFormBuilder(
    enabled: !viewModel.loading,
    prefix: Ionicons.person_outline,
    hintText: " country ",
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
    validateFunction: Validations.validateName,
    onSaved: (String val) {
    viewModel.setPhoneNum(val);
    },
    focusNode: viewModel.phnumFN, obscureText: false,
    ),
    SizedBox(height: 20.0),
>>>>>>> f777a7b046bdee987911d81dcfc7ca05fbbb8eaa
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
<<<<<<< HEAD
                'Sign Up'.toUpperCase(),
=======
                'sign up'.toUpperCase(),
>>>>>>> f777a7b046bdee987911d81dcfc7ca05fbbb8eaa
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () async {
<<<<<<< HEAD
                if (viewModel.formKey.currentState?.validate() ?? false) {
                  viewModel.formKey.currentState?.save();
                  await viewModel.register(context);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
=======
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

>>>>>>> f777a7b046bdee987911d81dcfc7ca05fbbb8eaa
}
