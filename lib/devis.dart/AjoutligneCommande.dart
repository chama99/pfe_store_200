// ignore_for_file: prefer_typing_uninitialized_variables, file_names, must_be_immutable

import 'dart:convert';

import 'package:chama_projet/devis.dart/updateDevis.dart';
import 'package:chama_projet/services/devis.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widget/toast.dart';

class AjoutCommande extends StatefulWidget {
  String titre, client, etat;

  double remise;
  List commande;
  double total, montant;
  AjoutCommande({
    Key? key,
    required this.titre,
    required this.client,
    required this.etat,
    required this.commande,
    required this.total,
    required this.remise,
    required this.montant,
  }) : super(key: key);

  @override
  State<AjoutCommande> createState() => _AjoutCommandeState();
}

class _AjoutCommandeState extends State<AjoutCommande> {
  final _formKey = GlobalKey<FormState>();
  var article;
  List listItem = ["store12", "store15"];
  final ref = TextEditingController();
  final des = TextEditingController();
  final unite = TextEditingController();
  final qt = TextEditingController();
  final prix = TextEditingController();
  List list = [];

  clearText() {
    ref.clear();
    des.clear();
    unite.clear();
    qt.clear();
    prix.clear();

    article = null;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    ref.dispose();
    des.dispose();
    unite.dispose();
    qt.dispose();
    prix.dispose();

    super.dispose();
  }

  addcomm() {
    var a = {
      ref.text,
      article,
      des.text,
      unite.text,
      int.parse(qt.text),
      double.parse(prix.text),
      "20%",
      int.parse(qt.text) * double.parse(prix.text)
    };
    return a;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text("Ajouter Ligne de la commande"),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(30),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: ref,
                    decoration: InputDecoration(
                      hintText: 'réf',
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 320,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey, width: 1)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        hint: const Text("Article"),
                        dropdownColor: Colors.white,
                        icon: const Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: Icon(
                            Icons.arrow_drop_down,
                            color: Colors.orange,
                          ),
                        ),
                        style:
                            const TextStyle(fontSize: 20, color: Colors.black),
                        iconSize: 40,
                        value: article,
                        onChanged: (newValue) {
                          setState(() {
                            article = newValue.toString();
                          });
                        },
                        items: listItem.map((valueItem) {
                          return DropdownMenuItem(
                            value: valueItem,
                            child: Text(valueItem),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: des,
                    decoration: InputDecoration(
                      hintText: 'description',
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: unite,
                    decoration: InputDecoration(
                      hintText: 'unité',
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: qt,
                    decoration: InputDecoration(
                      hintText: 'quantite',
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: prix,
                    decoration: InputDecoration(
                      hintText: 'prix',
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
                          var a = ({
                            'réf': ref.text,
                            'Article': article,
                            'Description': des.text,
                            'Unite': unite.text,
                            'Quantite': int.parse(qt.text),
                            'prix': double.parse(prix.text),
                            'taxe': "20%",
                            'sous-total':
                                int.parse(qt.text) * double.parse(prix.text)
                          });

                          var data = json.decode(json.encode(a));

                          widget.commande.add(data);
                          if (article != null) {
                            Devis().updateDevis(
                                widget.titre,
                                widget.client,
                                widget.etat,
                                widget.total,
                                widget.commande,
                                widget.remise,
                                widget.montant);
                            clearText();
                            Get.to(() => UpdateDevis(
                                titre: widget.titre,
                                client: widget.client,
                                etat: widget.etat,
                                total: widget.total,
                                commande: widget.commande,
                                remise: widget.remise,
                                montant: widget.montant));
                          } else {
                            showToast("veuillez sélectionner Article ");
                          }
                        }
                      },
                      child: const Text(
                        "Ajouter",
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
