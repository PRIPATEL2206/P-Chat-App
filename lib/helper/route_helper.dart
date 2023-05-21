import 'package:flutter/material.dart';

void gotoScreen({required BuildContext context, required Widget screen}) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
      ));
}

void replaceScreen({required BuildContext context, required Widget screen}) {
  Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
      ));
}

void goBack(BuildContext context) {
  Navigator.pop(context);
}
