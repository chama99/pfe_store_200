import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Planning/home_page_planning.dart';

Card buildInputCardPlan() {
  return Card(
    color: const Color.fromARGB(255, 141, 214, 209),
    margin: const EdgeInsets.all(8.0),
    child: InkWell(
      onTap: () {
        Get.to(() => const MultiSelection());
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
