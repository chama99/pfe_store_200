// ignore_for_file: prefer_typing_uninitialized_variables, file_names, must_be_immutable, non_constant_identifier_names

import 'dart:convert';

import 'package:chama_projet/devis.dart/updateDevis.dart';
import 'package:chama_projet/services/devis.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/article.dart';
import '../widget/NavBottom.dart';
import '../widget/toast.dart';

class AjoutCommande extends StatefulWidget {
  String titre, client, etat, id, idus, tel, adr;
  String role, date;
  int remise;
  List commande;
  double total, montant;
  String name, email, url;
  List acces;
  AjoutCommande(
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
      required this.role,
      required this.date,
      required this.email,
      required this.name,
      required this.acces,
      required this.url,
      required this.tel,
      required this.adr})
      : super(key: key);

  @override
  State<AjoutCommande> createState() => _AjoutCommandeState();
}

class _AjoutCommandeState extends State<AjoutCommande> {
  final _formKey = GlobalKey<FormState>();
  var article;

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
          child: Column(
            children: [
              const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 30, bottom: 20),
                  child: Text(
                    "Article :",
                    style: TextStyle(fontSize: 20, letterSpacing: 3),
                  ),
                ),
              ),
              Container(
                width: 400,
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
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: Text(
                                "Description :",
                                style:
                                    TextStyle(fontSize: 20, letterSpacing: 3),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: des,
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
                                    color: Colors.orange,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Veuillez écrire une  description";
                                }
                                return null;
                              },
                            ),
                          ),
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: Text(
                                "Quantité :",
                                style:
                                    TextStyle(fontSize: 20, letterSpacing: 3),
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
                                if (int.parse(value) > quant) {
                                  return "Vous avez dépassé la quantité ";
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
                                    int r = int.parse(qt.text);
                                    int q = quant - r;
                                    Article().updateQuantite(id, q);
                                    var a = ({
                                      'réf': refv,
                                      'Article': id,
                                      'Description': des.text,
                                      'Unite': unitev,
                                      'Quantite': int.parse(qt.text),
                                      'prix': prixv,
                                      'taxe': "20%",
                                      'sous-total': int.parse(qt.text) * prixv
                                    });

                                    var data = json.decode(json.encode(a));

                                    widget.commande.add(data);
                                    if (article != null) {
                                      Devis().updateDevis(
                                          widget.id,
                                          widget.client,
                                          widget.etat,
                                          widget.total,
                                          widget.commande,
                                          widget.remise,
                                          widget.montant);
                                      clearText();
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
                                            tel: widget.tel,
                                            adr: widget.adr,
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
