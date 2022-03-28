// ignore_for_file: file_names, must_be_immutable

import 'package:chama_projet/widget/NavBar.dart';
import 'package:chama_projet/widget/card_contact.dart';
import 'package:flutter/material.dart';

import 'card_config.dart';
import 'card_devis.dart';
import 'card_employe.dart';

class MenuAdmin extends StatefulWidget {
  String name, email, url;
  List acces;
  MenuAdmin(
      {Key? key,
      required this.email,
      required this.name,
      required this.acces,
      required this.url})
      : super(key: key);

  @override
  State<MenuAdmin> createState() => _MenuAdminState();
}

class _MenuAdminState extends State<MenuAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(
        name: widget.name,
        email: widget.email,
        url: widget.url,
      ),
      appBar: AppBar(
        title: Text(widget.name),
        backgroundColor: Colors.orange[400],
      ),
      backgroundColor: Colors.white,
      body: Container(
        margin: const EdgeInsets.all(30),
        child: GridView.count(
          crossAxisCount: 3,
          children: <Widget>[
            for (var x in widget.acces) ...[
              if (x == "Configuration") ...[buildInputCardConfig(widget.name)],
              if (x == "Employé") ...[buildInputCardEmploye()],
              if (x == "Devis") ...[buildInputCardDevis()],
              if (x == "Contact") ...[buildInputCardContact()],
            ]
          ],
        ),
      ),
    );
  }
}
