import 'package:flutter/material.dart';
import 'package:login/ui/widgets/widgets.dart';

void errorMessageSnack(BuildContext context, String error) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    duration: const Duration(seconds: 10),
    content: TextCustom(
      text: error,
      color: Colors.white,
      fontSize: 7,
    ),
    backgroundColor: Colors.red,
  ));
}
