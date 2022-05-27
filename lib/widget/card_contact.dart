import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../clients/contact_home_page.dart';

Card buildInputCardContact(String idus, String nomus, String emailus,
    String url, List acces, String role, String telus, String adrus) {
  return Card(
    color: const Color.fromARGB(255, 224, 207, 46),
    margin: const EdgeInsets.all(8.0),
    child: InkWell(
      onTap: () {
        Get.to(() => listContact(
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
              Icons.supervised_user_circle,
              size: 70,
              color: Colors.white,
            ),
            Text(" Clients",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
          ],
        ),
      ),
    ),
  );
}
