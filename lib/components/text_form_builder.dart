import 'package:flutter/material.dart';
import 'package:connectify/components/custom_card.dart';



class TextFormBuilder extends StatefulWidget {
  final String? initialValue;
  final bool? enabled;
  final String? hintText;
  final TextInputType? textInputType;
  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final FocusNode? focusNode, nextFocusNode;
  final VoidCallback? submitAction;
  final FormFieldValidator<String>? validateFunction;
  final void Function(String)? onSaved, onChange;
  final Key? key;
  final IconData? prefix;
  final IconData? suffix;


  @override
  _TextFormBuilderState createState() => _TextFormBuilderState();
}

class _TextFormBuilderState extends State<TextFormBuilder> {
  String? error;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    CustomCard(
    onTap: () {
    print('clicked');
    },
      borderRadius: BorderRadius.circular(40.0),
      child: Container(
          child: Theme(
          data: ThemeData(
          primaryColor: Theme.of(context).colorScheme.secondary,
      colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Theme.of(context).colorScheme.secondary),
    ),
    child: TextFormField(
    cursorColor: Theme.of(context).colorScheme.secondary,
    textCapitalization: TextCapitalization.none,
    initialValue: widget.initialValue,
    enabled: widget.enabled,
    onChanged: (val) {
    error = widget.validateFunction!(val);
    setState(() {});
    widget.onSaved!(val);
    },
style: TextStyle(
fontSize:15.0,
    ),
key: widget.key,
    controller: widget.controller,
obscureText: widget.obscureText,
keyboardType: widget.textInputType,
validator: widget.validateFunction,
onSaved: (val){
    error =widget.validateFunction!(val);
    setState(() {});
    widget.onSaved !(val!);
    },
  },