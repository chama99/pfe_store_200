// ignore_for_file: file_names, must_be_immutable

import 'package:chama_projet/facture.dart/updateFacture.dart';
import 'package:chama_projet/services/facture.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ModifieLignFact extends StatefulWidget {
  String titre;
  List commande;
  int num, res;
  String client, etat, date1, date2, adresse;
  double total, remise, montant;
  ModifieLignFact(
      {Key? key,
      required this.titre,
      required this.commande,
      required this.num,
      required this.adresse,
      required this.client,
      required this.date1,
      required this.date2,
      required this.etat,
      required this.montant,
      required this.remise,
      required this.total,
      required this.res})
      : super(key: key);

  @override
  State<ModifieLignFact> createState() => _ModifieLignFactState();
}

class _ModifieLignFactState extends State<ModifieLignFact> {
  final _formKey = GlobalKey<FormState>();
  // ignore: prefer_typing_uninitialized_variables
  var article;
  List lignFact = [];

  final lib = TextEditingController();
  final comp = TextEditingController();
  final etq = TextEditingController();
  final qt = TextEditingController();
  final prix = TextEditingController();

  clearText() {
    lib.clear();
    comp.clear();
    etq.clear();
    qt.clear();
    prix.clear();

    article = null;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    lib.dispose();
    etq.dispose();
    comp.dispose();
    qt.dispose();
    prix.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                      fontSize: 20, letterSpacing: 3, color: Colors.indigo),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Text(
                    "Libélle :",
                    style: TextStyle(fontSize: 15, letterSpacing: 3),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: widget.commande[widget.num]["Libélle"],
                    onChanged: (value) =>
                        widget.commande[widget.num]["Libélle"] = value,
                    decoration: InputDecoration(
                      hintText: 'Libellé',
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
                const Text(
                  "Compte analytique :",
                  style: TextStyle(fontSize: 15, letterSpacing: 3),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: widget.commande[widget.num]
                        ["Compte analytique"],
                    onChanged: (value) => widget.commande[widget.num]
                        ["Compte analytique"] = value,
                    decoration: InputDecoration(
                      hintText: 'Compte analytique',
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
                const Text(
                  "Etiquette analytique :",
                  style: TextStyle(fontSize: 15, letterSpacing: 3),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: widget.commande[widget.num]
                        ["Etiquette analytique"],
                    onChanged: (value) => widget.commande[widget.num]
                        ["Etiquette analytique"] = value,
                    decoration: InputDecoration(
                      hintText: 'Étiquette analytique',
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
                const Text(
                  "Quantité :",
                  style: TextStyle(fontSize: 15, letterSpacing: 3),
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
                          widget.commande[widget.num]["sous-total"] =
                              widget.commande[widget.num]["prix"] *
                                  widget.commande[widget.num]["Quantite"];
                          Facture().updateFacture(
                              widget.titre,
                              widget.client,
                              widget.etat,
                              DateTime.parse(widget.date1),
                              DateTime.parse(widget.date2),
                              widget.adresse,
                              widget.total,
                              widget.commande,
                              widget.remise,
                              widget.montant);
                          clearText();
                          Get.to(() => UpdateFacture(
                                titre: widget.titre,
                                client: widget.client,
                                etat: widget.etat,
                                adrss: widget.adresse,
                                total: widget.total,
                                order: 20,
                                listfact: widget.commande,
                                montant: widget.montant,
                                date1: widget.date1,
                                date2: widget.date2,
                                res: widget.res,
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
