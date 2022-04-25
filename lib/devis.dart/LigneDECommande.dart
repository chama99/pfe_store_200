// ignore_for_file: prefer_typing_uninitialized_variables, file_names, non_constant_identifier_names, unused_local_variable

import 'package:chama_projet/services/article.dart';
import 'package:chama_projet/services/commande.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widget/toast.dart';
import 'creer_devis.dart';

// ignore: must_be_immutable
class LigneCommande extends StatefulWidget {
  String role;
  LigneCommande({Key? key, required this.role}) : super(key: key);

  @override
  State<LigneCommande> createState() => _LigneCommandeState();
}

class _LigneCommandeState extends State<LigneCommande> {
  final _formKey = GlobalKey<FormState>();

  List listItem = ["store12", "store15"];
  final ref = TextEditingController();
  final des = TextEditingController();
  final unite = TextEditingController();
  final qt = TextEditingController();
  final prix = TextEditingController();

  clearText() {
    ref.clear();
    des.clear();
    unite.clear();
    qt.clear();
    prix.clear();
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
  var article;
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
          title: const Text("Ajouter Ligne de le commande"),
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
                      var nom = data['nom_art'];

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Center(
                            child: Text(
                              "Description :",
                              style: TextStyle(fontSize: 20, letterSpacing: 3),
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
                            child: Text(
                              "Quantité :",
                              style: TextStyle(fontSize: 20, letterSpacing: 3),
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
                                    if (article != null) {
                                      Commande().addCommande(
                                          refv,
                                          article,
                                          des.text,
                                          unitev,
                                          int.parse(qt.text),
                                          prixv,
                                          "20 %",
                                          int.parse(qt.text) * prixv);
                                      clearText();
                                      Get.to(() => CreeDevisPage(
                                            role: widget.role,
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
