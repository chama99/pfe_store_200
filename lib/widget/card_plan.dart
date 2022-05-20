import 'package:chama_projet/pages/congescreens/conge_screen.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Planning/calander.dart';
import '../Planning/home_page_planning.dart';

Card buildInputCardPlan(String role, String email, String username) {
  return Card(
    color: const Color.fromARGB(255, 237, 96, 96),
    margin: const EdgeInsets.all(8.0),
    child: InkWell(
      onTap: () {
        if (role == "Admin") {
          Get.to(() => MultiSelection(role: role));
        } else if (role == "Technicien") {
          Get.to(
              () => Calander(techName: email, username: username, role: role));
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

Card buildInputCardConges(String userID) {
  return Card(
    color: const Color.fromARGB(255, 239, 158, 181),
    margin: const EdgeInsets.all(8.0),
    child: InkWell(
      onTap: () {
        Get.to(() => CongeScreen(userID: userID));
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
            Text("Congés",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
          ],
        ),
      ),
    ),
  );
}
