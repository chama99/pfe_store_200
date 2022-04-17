import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../devis.dart/listDevis.dart';

Card buildInputCardDevis(String role) {
  return Card(
    color: Colors.blue[200],
    margin: const EdgeInsets.all(8.0),
    child: InkWell(
      onTap: () {
        Get.to(() => ListDevis(
              role: role,
            ));
      },
      splashColor: const Color.fromARGB(255, 3, 56, 109),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const <Widget>[
            Icon(
              Icons.trending_down_sharp,
              size: 70,
              color: Colors.white,
            ),
            Text(" Devis",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
          ],
        ),
      ),
    ),
  );
}
