// ignore: file_names
// ignore_for_file: must_be_immutable, file_names, duplicate_ignore, prefer_typing_uninitialized_variables, non_constant_identifier_names, unused_local_variable

import 'dart:convert';

import 'package:chama_projet/facture.dart/updateFacture.dart';
import 'package:chama_projet/services/autofacture.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/article.dart';
import '../services/facture.dart';
import '../widget/toast.dart';

class AjoutLigneFacture extends StatefulWidget {
  String titre, id, page;
  List commande;
  int res;
  String client, etat, date1;
  double total, remise, montant;
  AjoutLigneFacture(
      {Key? key,
      required this.id,
      required this.titre,
      required this.commande,
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
  State<AjoutLigneFacture> createState() => AjoutLigneFactureState();
}

class AjoutLigneFactureState extends State<AjoutLigneFacture> {
  final _formKey = GlobalKey<FormState>();
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
  void initState() {
    super.initState();

    fetchDatabaseList();
  }

  List ListArticle = [];

  fetchDatabaseList() async {
    dynamic resultant = await Article().getArticleListByTypeVendu();

    if (resultant == null) {
      // ignore: avoid_print
      print('Unable to retrieve');
    } else {
      setState(() {
        ListArticle = resultant;
        article = resultant[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          title: const Text("Ajouter Ligne de facture"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const Center(
                child: Text(
                  "Article :",
                  style: TextStyle(fontSize: 20, letterSpacing: 3),
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
                      hint: const Text("Article "),
                      dropdownColor: Colors.white,
                      icon: const Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.orange,
                        ),
                      ),
                      style: const TextStyle(fontSize: 20, color: Colors.black),
                      iconSize: 40,
                      value: article,
                      onChanged: (newValue) {
                        setState(() {
                          article = newValue.toString();
                        });
                      },
                      items: ListArticle.map((valueItem) {
                        return DropdownMenuItem(
                          value: valueItem,
                          child: Text(valueItem),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              Form(
                key: _formKey,
                child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    future: FirebaseFirestore.instance
                        .collection('Articles')
                        .doc(article)
                        .get(),
                    builder: (_, snapshot) {
                      if (snapshot.hasError) {
                        // ignore: avoid_print
                        print('Something Went Wrong');
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      var data = snapshot.data!.data();
                      var id = snapshot.data!.reference.id;

                      var quant = data!['Quantité'];
                      var prixv = data['prix_de_vente'];
                      var unitev = data['unite'];
                      var refv = data['reference_interne'];

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: lib,
                              decoration: InputDecoration(
                                hintText: 'Description',
                                filled: true,
                                fillColor: Colors.white,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: const BorderSide(
                                      color: Colors.orange, width: 1.5),
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
                                  return "Veuillez entrer  description ";
                                }
                                return null;
                              },
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
                                  borderSide: const BorderSide(
                                      color: Colors.orange, width: 1.5),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    if (article != null) {
                                      var a = ({
                                        'Description': lib.text,
                                        'Article': article,
                                        'Unite': unitev,
                                        'réf': refv,
                                        'Quantite': int.parse(qt.text),
                                        'prix': prixv,
                                        'sous-total':
                                            int.parse(qt.text) * prixv,
                                      });

                                      var data = json.decode(json.encode(a));
                                      widget.commande.add(data);
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
                                      clearText();
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
                                    } else {
                                      showToast(
                                          "veuillez sélectionner Article ");
                                    }
                                  }
                                },
                                child: const Text(
                                  "Ajouter",
                                  style: TextStyle(fontSize: 25),
                                ),
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.orange),
                              ),
                            ],
                          )
                        ],
                      );
                    }),
              )
            ],
          ),
        ));
  }
}
