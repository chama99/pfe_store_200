import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../inventaire/home_page_inventaire.dart';

Card buildInputCardInventaire() {
  return Card(
    color: const Color.fromARGB(255, 160, 179, 19),
    margin: const EdgeInsets.all(8.0),
    child: InkWell(
      onTap: () {
        Get.to(() => const ListInventaire());
      },
      splashColor: const Color.fromARGB(255, 3, 56, 109),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const <Widget>[
            Icon(
              Icons.inventory,
              size: 70,
              color: Colors.white,
            ),
            Text(" Inventaire",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
          ],
        ),
      ),
    ),
  );
}