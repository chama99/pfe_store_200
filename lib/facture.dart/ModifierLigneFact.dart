// ignore_for_file: file_names, must_be_immutable, non_constant_identifier_names

import 'package:chama_projet/facture.dart/updateFacture.dart';
import 'package:chama_projet/services/autofacture.dart';
import 'package:chama_projet/services/facture.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/article.dart';

class ModifieLignFact extends StatefulWidget {
  String titre, id, page;
  List commande;
  int num, res;
  String client, etat, date1;
  double total, remise, montant;
  ModifieLignFact(
      {Key? key,
      required this.id,
      required this.titre,
      required this.commande,
      required this.num,
      required this.client,
      required this.date1,
      required this.etat,
      required this.montant,
      required this.remise,
      required this.total,
      required this.res,
      required this.page})
      : super(key: key);

  @override
  State<ModifieLignFact> createState() => _ModifieLignFactState();
}

class _ModifieLignFactState extends State<ModifieLignFact> {
  final _formKey = GlobalKey<FormState>();
  // ignore: prefer_typing_uninitialized_variables
  var article;
  List lignFact = [];

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
        title: Text("Modifier Ligne de facture ${widget.num}"),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(30),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Article : ${widget.commande[widget.num]["Article"]}",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w500),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 30, bottom: 20),
                  child: Text(
                    "Description:",
                    style: TextStyle(fontSize: 15, letterSpacing: 3),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: widget.commande[widget.num]["Description"],
                    onChanged: (value) =>
                        widget.commande[widget.num]["Description"] = value,
                    decoration: InputDecoration(
                      hintText: 'Description',
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
                          color: Colors.white,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 30, bottom: 20),
                  child: Text(
                    "Quantité :",
                    style: TextStyle(fontSize: 15, letterSpacing: 3),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    initialValue:
                        widget.commande[widget.num]["Quantite"].toString(),
                    onChanged: (value) => widget.commande[widget.num]
                        ["Quantite"] = int.parse(value),
                    decoration: InputDecoration(
                      hintText: 'Quantité',
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
                        if (_formKey.currentState!.validate()) {
                          int q = ListArticle[0] - qt;
                          Article().updateQuantite(
                              widget.commande[widget.num]["Article"], q);

                          widget.commande[widget.num]["sous-total"] =
                              widget.commande[widget.num]["prix"] *
                                  widget.commande[widget.num]["Quantite"];
                          if (widget.page == "nouvellefacture") {
                            Facture().updateFacture(
                                widget.id,
                                widget.client,
                                widget.etat,
                                DateTime.parse(widget.date1),
                                widget.total,
                                widget.commande,
                                widget.remise,
                                widget.montant);
                          } else {
                            AutoFacture().updateFacture(
                                widget.id,
                                widget.client,
                                widget.etat,
                                DateTime.parse(widget.date1),
                                widget.total,
                                widget.commande,
                                widget.remise,
                                widget.montant);
                          }

                          Get.to(() => UpdateFacture(
                                id: widget.id,
                                titre: widget.titre,
                                client: widget.client,
                                etat: widget.etat,
                                total: widget.total,
                                listfact: widget.commande,
                                montant: widget.montant,
                                date1: widget.date1,
                                res: widget.res,
                                page: widget.page,
                              ));
                        }
                      },
                      child: const Text(
                        "Modifier",
                        style: TextStyle(fontSize: 25),
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
