import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../users/listUser.dart';

Card buildInputCardUser(String idus, String role, String email, String name,
    List acces, String url, String adr, String tel) {
  return Card(
    color: const Color.fromARGB(255, 176, 134, 184),
    margin: const EdgeInsets.all(8.0),
    child: InkWell(
      onTap: () {
        Get.to(() => ListUser(
            idus: idus,
            role: role,
            email: email,
            name: name,
            acces: acces,
            url: url,
            adr: adr,
            tel: tel));
      },
      splashColor: const Color.fromARGB(255, 3, 56, 109),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const <Widget>[
            Icon(
              Icons.supervised_user_circle_outlined,
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
