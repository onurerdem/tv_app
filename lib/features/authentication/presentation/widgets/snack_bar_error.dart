import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void snackBarError({String? msg, GlobalKey<ScaffoldState>? scaffoldState}) {
  ScaffoldMessenger.of(scaffoldState!.currentState!.context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 3),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$msg"),
          const Icon(FontAwesomeIcons.triangleExclamation)
        ],
      ),
    ),
  );
}