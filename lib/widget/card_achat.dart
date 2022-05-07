import 'package:chama_projet/achat/listAchat.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Card buildInputCardAchat() {
  return Card(
    color: const Color.fromARGB(255, 228, 169, 40),
    margin: const EdgeInsets.all(8.0),
    child: InkWell(
      onTap: () {
        Get.to(() => const ListAchat());
      },
      splashColor: const Color.fromARGB(255, 3, 56, 109),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const <Widget>[
            Icon(
              Icons.shopping_bag_outlined,
              size: 70,
              color: Colors.white,
            ),
            Text(" Achats",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
          ],
        ),
      ),
    ),
  );
}
