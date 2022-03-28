import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../contacts/contact_home_page.dart';

Card buildInputCardContact() {
  return Card(
    color: const Color.fromARGB(255, 224, 207, 46),
    margin: const EdgeInsets.all(8.0),
    child: InkWell(
      onTap: () {
        Get.to(() => const listContact());
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
            Text(" Contacts",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
          ],
        ),
      ),
    ),
  );
}
