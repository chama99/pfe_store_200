import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../pages/listUser.dart';

Card buildInputCardUser() {
  return Card(
    color: const Color.fromARGB(255, 176, 134, 184),
    margin: const EdgeInsets.all(8.0),
    child: InkWell(
      onTap: () {
        Get.to(() => const ListUser());
      },
      splashColor: const Color.fromARGB(255, 3, 56, 109),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const <Widget>[
            Icon(
              Icons.person,
              size: 70,
              color: Colors.white,
            ),
            Text("Utilisateurs",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
          ],
        ),
      ),
    ),
  );
}
