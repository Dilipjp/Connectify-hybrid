import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final Widget? child;
  final Function() onTap;
  final BorderRadius? borderRadius;
  final bool elevated;

  CustomCard({
    Key? key,
    required this.child,
    required this.onTap,
    this.borderRadius,
    this.elevated = true,
  });


}