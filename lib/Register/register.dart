import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:connectify/view_models/auth/register_view_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';


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


    );
  }
}
