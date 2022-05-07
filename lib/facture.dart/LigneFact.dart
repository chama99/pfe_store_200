// ignore: file_names
// ignore_for_file: must_be_immutable, file_names, duplicate_ignore, non_constant_identifier_names, prefer_typing_uninitialized_variables, unused_local_variable

import 'package:chama_projet/facture.dart/creer_facture.dart';

import 'package:chama_projet/services/lignefact.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/article.dart';
import '../widget/toast.dart';

class LigneFacture extends StatefulWidget {
  String titre;
  LigneFacture({Key? key, required this.titre}) : super(key: key);

  @override
  State<LigneFacture> createState() => _LigneFactureState();
}

class _LigneFactureState extends State<LigneFacture> {
  final _formKey = GlobalKey<FormState>();

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
  }

  @override
  void initState() {
    super.initState();

    fetchDatabaseList();
  }

  @override
  void dispose() {
    lib.dispose();
    etq.dispose();
    comp.dispose();
    qt.dispose();
    prix.dispose();

    super.dispose();
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
                        article = newValue;
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
                    var code = data['code_a_barre'];
                    var type = data['type_art'];
                    var role = data['role_art'];
                    var cat = data['cat'];
                    var taxesalavente = data['taxes_a_la_vente'];
                    var prixdachat = data['prix_dachat'];
                    var saleprix = data['sale_prix'];
                    var url = data['image'];
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
                                return "Veuillez entrer  libellé ";
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
                                  if (article != null) {
                                    int r = int.parse(qt.text);
                                    int q = quant - r;
                                    Article().updateQuantite(id, q);
                                    CommandeFact().addCommde(
                                        refv,
                                        unitev,
                                        lib.text,
                                        article,
                                        int.parse(qt.text),
                                        prixv,
                                        int.parse(qt.text) * prixv);
                                    clearText();
                                    Get.to(() => const CreeFacturePage());
                                  } else {
                                    showToast("veuillez sélectionner Article ");
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
            ),
          ],
        ),
      ),
    );
  }
}
