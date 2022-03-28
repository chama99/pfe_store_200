// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import 'card_employe.dart';
import 'card_role.dart';
import 'card_user.dart';

class Configuration extends StatefulWidget {
  String name;
  Configuration({Key? key, required this.name}) : super(key: key);

  @override
  State<Configuration> createState() => _ConfigurationState();
}

class _ConfigurationState extends State<Configuration> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        backgroundColor: Colors.orange[400],
      ),
      backgroundColor: Colors.white,
      body: Container(
        margin: const EdgeInsets.all(120),
        child: GridView.count(
          crossAxisCount: 1,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: buildInputCardRole(),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: buildInputCardUser(),
            ),
          ],
        ),
      ),
    );
  }
}
