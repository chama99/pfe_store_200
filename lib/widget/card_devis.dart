import 'package:chama_projet/pages/listDevis.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Card buildInputCardDevis() {
  return Card(
    color: Colors.blue[200],
    margin: const EdgeInsets.all(8.0),
    child: InkWell(
      onTap: () {
        Get.to(() => const ListDevis());
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
