import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../facture.dart/home_page_fact.dart';

Card buildInputCardFacture() {
  return Card(
    color: const Color.fromARGB(255, 169, 66, 162),
    margin: const EdgeInsets.all(8.0),
    child: InkWell(
      onTap: () {
        Get.to(() => const ListFactt());
      },
      splashColor: const Color.fromARGB(255, 3, 56, 109),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const <Widget>[
            Icon(
              Icons.description_outlined,
              size: 70,
              color: Colors.white,
            ),
            Text(" Factures",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
          ],
        ),
      ),
    ),
  );
}
