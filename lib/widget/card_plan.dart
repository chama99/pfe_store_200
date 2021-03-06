import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Planning/calander.dart';
import '../Planning/home_page_planning.dart';
import '../congescreens/conges_screen.dart';

Card buildInputCardPlan(
    String role,
    String email,
    String username,
    String idus,
    String nomus,
    String emailus,
    String url,
    List acces,
    String roleus,
    String telus,
    String adrus) {
  return Card(
    color: const Color.fromARGB(255, 237, 96, 96),
    margin: const EdgeInsets.all(8.0),
    child: InkWell(
      onTap: () {
        if (role == "Admin") {
          Get.to(() => MultiSelection(
              role: role,
              idus: idus,
              url: url,
              emailus: emailus,
              nameus: nomus,
              roleus: roleus,
              accesus: acces,
              telus: telus,
              adrus: adrus));
        } else if (role == "Technicien") {
          Get.to(() => Calander(
                techName: email,
                username: username,
                role: role,
                idus: idus,
                url: url,
                telus: telus,
                adrus: adrus,
                accesus: acces,
                nameus: nomus,
                emailus: emailus,
                roleus: roleus,
              ));
        }
      },
      splashColor: const Color.fromARGB(255, 3, 56, 109),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const <Widget>[
            Icon(
              Icons.calendar_month,
              size: 70,
              color: Colors.white,
            ),
            Text(" Plan",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
          ],
        ),
      ),
    ),
  );
}

Card buildInputCardConges(
    String userID,
    String role,
    String email,
    String username,
    String idus,
    String nomus,
    String emailus,
    String url,
    List acces,
    String roleus,
    String telus,
    String adrus) {
  return Card(
    color: const Color.fromARGB(255, 239, 158, 181),
    margin: const EdgeInsets.all(8.0),
    child: InkWell(
      onTap: () {
        Get.to(() => CongesScreen(
            userID: userID,
            role: role,
            idus: idus,
            url: url,
            telus: telus,
            adrus: adrus,
            accesus: acces,
            nameus: username,
            emailus: emailus,
            roleus: roleus));
      },
      splashColor: const Color.fromARGB(255, 3, 56, 109),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const <Widget>[
            Icon(
              Icons.calendar_today,
              size: 70,
              color: Colors.white,
            ),
            Text("Cong??s",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
          ],
        ),
      ),
    ),
  );
}
