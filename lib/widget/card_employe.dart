import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../employes.dart/listeEmployes.dart';

Card buildInputCardEmploye(String idus, String nomus, String emailus,
    String url, List acces, String role, String telus, String adrus) {
  return Card(
    color: Colors.deepOrange[300],
    margin: const EdgeInsets.all(8.0),
    child: InkWell(
      onTap: () {
        Get.to(() => listEmploye(
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
