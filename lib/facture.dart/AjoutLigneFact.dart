// ignore: file_names
// ignore_for_file: must_be_immutable, file_names, duplicate_ignore, prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:chama_projet/facture.dart/updateFacture.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/facture.dart';
import '../widget/toast.dart';

class AjoutLigneFacture extends StatefulWidget {
  String titre;
  List commande;

  String client, etat, date1, date2, adresse;
  double total, remise, montant;
  AjoutLigneFacture(
      {Key? key,
      required this.titre,
      required this.commande,
      required this.adresse,
      required this.client,
      required this.date1,
      required this.date2,
      required this.etat,
      required this.montant,
      required this.remise,
      required this.total})
      : super(key: key);

  @override
  State<AjoutLigneFacture> createState() => AjoutLigneFactureState();
}

class AjoutLigneFactureState extends State<AjoutLigneFacture> {
  final _formKey = GlobalKey<FormState>();
  var article;
  List lignFact = [];
  List listItem = ["store12", "store15"];
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
        title: const Text("Ajouter Ligne de facture"),
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
                  child: Container(
                    width: 320,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey, width: 1)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        hint: const Text("Article "),
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
                    controller: lib,
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
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Veuillez entrer  libellé ";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: comp,
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: etq,
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: qt,
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
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Veuillez entrer Quantité ";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: prix,
                    decoration: InputDecoration(
                      hintText: 'Prix ',
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
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Veuillez entrer Prix ";
                      }
                      return null;
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (article != null) {
                            var a = ({
                              'Libélle': lib.text,
                              'Article': article,
                              'Compte analytique': comp.text,
                              'Etiquette analytique': etq.text,
                              'Quantite': int.parse(qt.text),
                              'prix': double.parse(prix.text),
                              'sous-total':
                                  int.parse(qt.text) * double.parse(prix.text),
                            });

                            var data = json.decode(json.encode(a));
                            widget.commande.add(data);
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
                                date2: widget.date2));
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
