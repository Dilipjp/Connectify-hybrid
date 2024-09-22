import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:connectify/register/register.dart';
import 'package:connectify/components/password_text_field.dart';
import 'package:connectify/components/text_form_builder.dart';
import 'package:connectify/utils/validation.dart';
import 'package:connectify/view_models/auth/login_view_model.dart';
import 'package:connectify/widgets/indicators.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    LoginViewModel viewModel = Provider.of<LoginViewModel>(context);
    return LoadingOverlay(
      progressIndicator: circularProgress(context),
      isLoading: viewModel.loading,
      child: Scaffold(
         backgroundColor: Colors.white,
        key: viewModel.scaffoldKey,
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 15.0,vertical: 20.0),
children: [
SizedBox(height: MediaQuery.of(context).size.height / 5),
  Container(
    height: 170.0,
width: MediaQuery.of(context).size.width,
child: Image.asset('assets/images/login.png'
),
  ),
  SizedBox(height: 10.0),
Center(
  child: Text(
    'Welcome back!',
    style: TextStyle(
      fontSize: 23.0,
      fontWeight: FontWeight.w900,
    ),
  ),
),
  Center(
    child: Text(
      'Log into your account and get started!',
      style: TextStyle(
        fontSize: 12.0,
        fontWeight: FontWeight.w300,
        color: Theme.of(context).colorScheme.secondary,
      ),
    ),
  ),
      SizedBox(height: 25.0),
      buildForm(context, viewModel),
      SizedBox(height: 10.0),
      Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Text('Don\'t have an account?'),
      SizedBox(width: 5.0),
      GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (_) => Register(),
            ),
          );
        },
],
        ),

      ),
    );
  }