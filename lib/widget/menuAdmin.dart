// ignore_for_file: file_names, must_be_immutable

import 'package:chama_projet/widget/NavBar.dart';
import 'package:chama_projet/widget/card_article.dart';
import 'package:chama_projet/widget/card_contact.dart';
import 'package:chama_projet/widget/planning.dart';
import 'package:flutter/material.dart';

import 'card_devis.dart';
import 'card_employe.dart';
import 'card_facture.dart';
import 'card_role.dart';
import 'card_user.dart';

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
              if (x == "Employés") ...[buildInputCardEmploye()],
              if (x == "Devis") ...[buildInputCardDevis()],
              if (x == "Contacts") ...[buildInputCardContact()],
              if (x == "Articles") ...[buildInputCardArtcile()],
              if (x == "Factures") ...[buildInputCardFacture()],
              if (x == "Utilisateurs") ...[buildInputCardUser()],
              if (x == "Applications") ...[buildInputCardRole()],
              if (x == "Planning") ...[buildInputPlanning()],
            ]
          ],
        ),
      ),
    );
  }
}
