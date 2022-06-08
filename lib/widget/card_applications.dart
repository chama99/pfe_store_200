import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../users/acces.dart';

Card buildInputCardRole(String idus, String nomus, String emailus, String url,
    List acces, String role, String telus, String adrus) {
  return Card(
    color: Colors.brown[200],
    margin: const EdgeInsets.all(8.0),
    child: InkWell(
      onTap: () {
        Get.to(() => Roles(
            idus: idus,
            url: url,
            emailus: emailus,
            nameus: nomus,
            roleus: role,
            accesus: acces,
            telus: telus,
            adrus: adrus));
      },
      splashColor: const Color.fromARGB(255, 3, 56, 109),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const <Widget>[
            Icon(
              Icons.view_module,
              size: 70,
              color: Colors.white,
            ),
            Text("Applications",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
          ],
        ),
      ),
    ),
  );
}
