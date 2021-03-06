// ignore_for_file: prefer_typing_uninitialized_variables, file_names, must_be_immutable, non_constant_identifier_names

import 'package:chama_projet/devis.dart/updateDevis.dart';
import 'package:chama_projet/services/devis.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/article.dart';
import '../widget/NavBottom.dart';

class ModifierCommande extends StatefulWidget {
  String titre, client, etat, role, id, date, tel, adr;
  int num;
  int remise;
  List commande;
  double total, montant;
  String name, email, url, idus;
  List acces;
  ModifierCommande(
      {Key? key,
      required this.idus,
      required this.id,
      required this.titre,
      required this.client,
      required this.etat,
      required this.commande,
      required this.total,
      required this.remise,
      required this.montant,
      required this.num,
      required this.role,
      required this.date,
      required this.email,
      required this.name,
      required this.acces,
      required this.url,
      required this.adr,
      required this.tel})
      : super(key: key);

  @override
  State<ModifierCommande> createState() => _ModifierCommandeState();
}

class _ModifierCommandeState extends State<ModifierCommande> {
  final _formKey = GlobalKey<FormState>();
  var article;
  List listItem = ["store12", "store15"];

  List list = [];
  @override
  void initState() {
    super.initState();

    fetchDatabaseList();
  }

  List ListArticle = [];

  fetchDatabaseList() async {
    dynamic resultant = await Article()
        .getArticleListByid(widget.commande[widget.num]["Article"]);

    if (resultant == null) {
      // ignore: avoid_print
      print('Unable to retrieve');
    } else {
      setState(() {
        ListArticle = resultant;
      });
    }
  }

  var qt = 0;

  @override
  Widget build(BuildContext context) {
    qt = widget.commande[widget.num]["Quantite"];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text("Modifier  Ligne de la commande ${widget.num}"),
      ),
      bottomNavigationBar: NavBottom(
          tel: widget.tel,
          adr: widget.adr,
          id: widget.idus,
          email: widget.email,
          name: widget.name,
          acces: widget.acces,
          url: widget.url,
          role: widget.role),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(30),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Article : ${widget.commande[widget.num]["Article"]} ",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w500),
                ),
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text("Description :",
                      style: TextStyle(fontSize: 20, letterSpacing: 3)),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue:
                        '${widget.commande[widget.num]["Description"]}',
                    onChanged: (value) {
                      widget.commande[widget.num]["Description"] = value;
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide:
                            const BorderSide(color: Colors.orange, width: 1.5),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(
                          color: Colors.orange,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text("Quantit?? :",
                      style: TextStyle(fontSize: 20, letterSpacing: 3)),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    initialValue: '$qt',
                    onChanged: (value) {
                      qt = int.parse(value);
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide:
                            const BorderSide(color: Colors.orange, width: 1.5),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(
                          color: Colors.orange,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        int q = ListArticle[0] - qt;
                        Article().updateQuantite(
                            widget.commande[widget.num]["Article"], q);
                        widget.commande[widget.num]["Quantite"] = qt;
                        widget.commande[widget.num]["sous-total"] =
                            widget.commande[widget.num]["Quantite"] *
                                widget.commande[widget.num]["prix"];
                        Devis().updateDevis(
                            widget.id,
                            widget.client,
                            widget.etat,
                            widget.total,
                            widget.commande,
                            widget.remise,
                            widget.montant);

                        Get.to(() => UpdateDevis(
                              idus: widget.idus,
                              id: widget.id,
                              titre: widget.titre,
                              client: widget.client,
                              etat: widget.etat,
                              total: widget.total,
                              commande: widget.commande,
                              remise: widget.remise,
                              montant: widget.montant,
                              role: widget.role,
                              date: widget.date,
                              email: widget.email,
                              name: widget.name,
                              acces: widget.acces,
                              url: widget.url,
                              adr: widget.adr,
                              tel: widget.tel,
                            ));
                      },
                      child: const Text(
                        "Modifier",
                        style: TextStyle(fontSize: 20),
                      ),
                      style: ElevatedButton.styleFrom(primary: Colors.orange),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
