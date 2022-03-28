import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../pages/listeEmployes.dart';

Card buildInputCardEmploye() {
  return Card(
    color: Colors.deepOrange[300],
    margin: const EdgeInsets.all(8.0),
    child: InkWell(
      onTap: () {
        Get.to(() => const listEmploye());
      },
      splashColor: const Color.fromARGB(255, 3, 56, 109),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const <Widget>[
            Icon(
              Icons.supervisor_account_sharp,
              size: 70,
              color: Colors.white,
            ),
            Text(" Employés",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
          ],
        ),
      ),
    ),
  );
}
