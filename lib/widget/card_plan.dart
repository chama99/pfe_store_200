import 'package:chama_projet/pages/congescreens/conge_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Planning/calander.dart';
import '../Planning/home_page_planning.dart';

Card buildInputCardPlan(String role, String email, String username) {
  return Card(
    color: const Color.fromARGB(255, 141, 214, 209),
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

Card buildInputCardConges() {
  return Card(
    color: const Color.fromARGB(255, 117, 29, 54),
    margin: const EdgeInsets.all(8.0),
    child: InkWell(
      onTap: () {
        Get.to(() => const CongeScreen());
      },
      splashColor: const Color.fromARGB(255, 3, 56, 109),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const <Widget>[
            Icon(
              CupertinoIcons.zzz,
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
