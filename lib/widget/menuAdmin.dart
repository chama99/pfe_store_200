// ignore_for_file: file_names, must_be_immutable

import 'package:chama_projet/widget/card_article.dart';
import 'package:chama_projet/widget/card_contact.dart';
import 'package:chama_projet/widget/card_inventaire.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'NavBottom.dart';
import 'card_achat.dart';
import 'card_devis.dart';
import 'card_employe.dart';
import 'card_facture.dart';
import 'card_plan.dart';
import 'card_role.dart';
import 'card_user.dart';
import 'loadingpage.dart';

class MenuAdmin extends StatefulWidget {
  String name, email, url, role, id, tel, adr;
  List acces;
  MenuAdmin(
      {Key? key,
      required this.tel,
      required this.adr,
      required this.id,
      required this.email,
      required this.name,
      required this.acces,
      required this.url,
      required this.role})
      : super(key: key);

  @override
  State<MenuAdmin> createState() => _MenuAdminState();
}

class _MenuAdminState extends State<MenuAdmin> {
  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.name),
            ),
            backgroundColor: Colors.orange[400],
            actions: [
              Stack(
                children: <Widget>[
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 8.0, right: 15, bottom: 4),
                    child: ClipOval(
                      child: Image.network(
                        widget.url,
                        fit: BoxFit.cover,
                        width: 50,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 30,
                    right: 18,
                    child: InkWell(
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            builder: ((builder) => ListView(
                                  padding: EdgeInsets.zero,
                                  children: [
                                    UserAccountsDrawerHeader(
                                      accountName: Text(widget.name),
                                      accountEmail: Text(widget.email),
                                      currentAccountPicture: CircleAvatar(
                                        child: ClipOval(
                                          child: Image.network(
                                            widget.url,
                                            fit: BoxFit.cover,
                                            width: 90,
                                          ),
                                        ),
                                      ),
                                      decoration: const BoxDecoration(
                                          color: Colors.orange),
                                    ),
                                    const Divider(),
                                    ListTile(
                                      leading: const Icon(Icons.exit_to_app),
                                      title: const Text("Déconnexion"),
                                      onTap: () =>
                                          Get.to(() => const LoadingPage()),
                                    ),
                                    const Divider(),
                                  ],
                                )));
                      },
                      child: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.orange,
                        size: 30,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          bottomNavigationBar: NavBottom(
              tel: widget.tel,
              adr: widget.adr,
              id: widget.id,
              email: widget.email,
              name: widget.name,
              acces: widget.acces,
              url: widget.url,
              role: widget.role),
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.all(15),
            child: GridView.count(
              crossAxisCount: 3,
              children: <Widget>[
                for (var x in widget.acces) ...[
                  if (x == "Employés") ...[
                    buildInputCardEmploye(
                        widget.id,
                        widget.name,
                        widget.email,
                        widget.url,
                        widget.acces,
                        widget.role,
                        widget.tel,
                        widget.adr)
                  ],
                  if (x == "Achats") ...[buildInputCardAchat()],
                  if (x == "Devis") ...[
                    buildInputCardDevis(
                        widget.role,
                        widget.email,
                        widget.name,
                        widget.url,
                        widget.acces,
                        widget.id,
                        widget.tel,
                        widget.adr)
                  ],
                  if (x == "Clients") ...[
                    buildInputCardContact(
                        widget.id,
                        widget.name,
                        widget.email,
                        widget.url,
                        widget.acces,
                        widget.role,
                        widget.tel,
                        widget.adr)
                  ],
                  if (x == "Articles") ...[
                    buildInputCardArtcile(
                        widget.id,
                        widget.name,
                        widget.email,
                        widget.url,
                        widget.acces,
                        widget.role,
                        widget.tel,
                        widget.adr)
                  ],
                  if (x == "Factures") ...[
                    buildInputCardFacture(
                        widget.id,
                        widget.name,
                        widget.email,
                        widget.url,
                        widget.acces,
                        widget.role,
                        widget.tel,
                        widget.adr)
                  ],
                  if (x == "Utilisateurs") ...[
                    buildInputCardUser(
                        widget.id,
                        widget.role,
                        widget.email,
                        widget.name,
                        widget.acces,
                        widget.url,
                        widget.adr,
                        widget.tel)
                  ],
                  if (x == "Applications") ...[
                    buildInputCardRole(
                        widget.id,
                        widget.name,
                        widget.email,
                        widget.url,
                        widget.acces,
                        widget.role,
                        widget.tel,
                        widget.adr)
                  ],
                  if (x == "Plan") ...[
                    buildInputCardPlan(widget.role, widget.email, widget.name)
                  ],
                  if (x == "Inventaire") ...[buildInputCardInventaire()],
                  if (x == "Conges") ...[buildInputCardConges(widget.id)]
                ]
              ],
            ),
          ),
        ),
      );
}
