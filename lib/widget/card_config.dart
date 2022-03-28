import 'package:chama_projet/widget/configuration.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Card buildInputCardConfig(name) {
  return Card(
    color: Colors.green[300],
    margin: const EdgeInsets.all(8.0),
    child: InkWell(
      onTap: () {
        Get.to(() => Configuration(name: name));
      },
      splashColor: const Color.fromARGB(255, 3, 56, 109),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const <Widget>[
            Icon(
              Icons.settings,
              size: 70,
              color: Colors.white,
            ),
            Text(" Configuration",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
          ],
        ),
      ),
    ),
  );
}
