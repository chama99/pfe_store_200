import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../pages/role.dart';

Card buildInputCardRole() {
  return Card(
    color: Colors.brown[200],
    margin: const EdgeInsets.all(8.0),
    child: InkWell(
      onTap: () {
        Get.to(() => const Roles());
      },
      splashColor: const Color.fromARGB(255, 3, 56, 109),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const <Widget>[
            Icon(
              Icons.add_box,
              size: 70,
              color: Colors.white,
            ),
            Text("Rôle",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
          ],
        ),
      ),
    ),
  );
}
