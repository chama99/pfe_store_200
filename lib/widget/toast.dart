// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

showToast(mssg) {
  return Fluttertoast.showToast(
      msg: mssg,
      fontSize: 20,
      gravity: ToastGravity.CENTER,
      backgroundColor: const Color.fromARGB(255, 245, 125, 117),
      textColor: Colors.white);
}
