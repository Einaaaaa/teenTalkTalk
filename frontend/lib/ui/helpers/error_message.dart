import 'package:flutter/material.dart';
import 'package:login/ui/widgets/widgets.dart';

void errorMessageSnack(BuildContext context, String error) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    duration: const Duration(seconds: 100),
    content: TextCustom(
      text: error,
      color: Colors.white,
      fontSize: 9,
    ),
    backgroundColor: Colors.red,
  ));
}
