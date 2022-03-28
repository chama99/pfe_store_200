// ignore_for_file: file_names

import 'package:flutter/material.dart';

InputDecoration buildInputDecoration(IconData icons, String hinttext,
    {required Color color}) {
  return InputDecoration(
    hintText: hinttext,
    filled: true,
    fillColor: Colors.white,
    prefixIcon: Icon(
      icons,
      color: Colors.orange,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: const BorderSide(color: Colors.orange, width: 1.5),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: const BorderSide(
        color: Colors.orange,
        width: 1.5,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: const BorderSide(
        color: Colors.grey,
        width: 1.5,
      ),
    ),
  );
}
