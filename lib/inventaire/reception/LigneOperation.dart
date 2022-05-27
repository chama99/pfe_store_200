// ignore_for_file: file_names, must_be_immutable, non_constant_identifier_names, unused_local_variable

import 'package:chama_projet/inventaire/Transfert/creer_transfert.dart';
import 'package:chama_projet/inventaire/livraison/creer_livraison.dart';
import 'package:chama_projet/services/ligneOperation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/article.dart';
import '../../widget/NavBottom.dart';
import '../../widget/toast.dart';
import 'creer_reception.dart';

class LigneOperation extends StatefulWidget {
  String page;
  String emailus, nameus, url, roleus, adrus, telus, idus;

  List accesus;
  LigneOperation({
    Key? key,
    required this.page,
    required this.idus,
    required this.url,
    required this.emailus,
    required this.nameus,
    required this.roleus,
    required this.accesus,
    required this.telus,
    required this.adrus,
  }) : super(key: key);

  @override
  State<LigneOperation> createState() => _LigneOperationState();
}

class _LigneOperationState extends State<LigneOperation> {
  final _formKey = GlobalKey<FormState>();
  // ignore: prefer_typing_uninitialized_variables
  var article;

  final colis = TextEditingController();
  final colisDes = TextEditingController();
  final appartenant = TextEditingController();
  final fait = TextEditingController();
  final unite = TextEditingController();

  clearText() {
    colis.clear();
    appartenant.clear();
    fait.clear();
    unite.clear();

    article = "";
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    colis.dispose();
    appartenant.dispose();
    fait.dispose();
    unite.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    fetchDatabaseList();
  }

  List ListArticle = [];

  fetchDatabaseList() async {
    dynamic resultants = await Article().getArticleListByTypeservice();
    dynamic resultantc = await Article().getArticleListByTypeconsom();
    dynamic resultantsk = await Article().getArticleListByTypestock();

    if (resultants == null) {
      // ignore: avoid_print
      print('Unable to retrieve');
    } else {
      setState(() {
        if (widget.page == "Transfert") {
          for (var i = 0; i < resultants.length; i++) {
            ListArticle.add(resultants[i]["nom_art"]);
            article = resultants[i]["nom_art"];
          }
        } else if (widget.page == "Livraison") {
          for (var i = 0; i < resultantc.length; i++) {
            ListArticle.add(resultantc[i]["nom_art"]);
            article = resultantc[i]["nom_art"];
          }
        } else {
          for (var i = 0; i < resultantsk.length; i++) {
            ListArticle.add(resultantsk[i]["nom_art"]);
            article = resultantsk[i]["nom_art"];
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text("Ajouter Ligne de opérations"),
      ),
      bottomNavigationBar: NavBottom(
          tel: widget.telus,
          adr: widget.adrus,
          id: widget.idus,
          email: widget.emailus,
          name: widget.nameus,
          acces: widget.accesus,
          url: widget.url,
          role: widget.roleus),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Center(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Article :",
                  style: TextStyle(fontSize: 20, letterSpacing: 3),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Container(
                width: 365,
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
            if (article != null) ...[
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
                      var quant = data!['Quantité'];
                      var prixv = data['prix_de_vente'];
                      var unitev = data['unite'];
                      var refv = data['reference_interne'];
                      var nom = data['nom'];
                      var code = data['code_a_barre'];
                      var type = data['type'];
                      var role = data['role'];
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
                              controller: colis,
                              decoration: InputDecoration(
                                hintText: 'Colis source',
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
                                  return "Veuillez entrer  colis de destination";
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: colisDes,
                              decoration: InputDecoration(
                                hintText: 'Colis de destination',
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
                                  return "Veuillez entrer  colis de destination";
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: appartenant,
                              decoration: InputDecoration(
                                hintText: 'Appartenant à',
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
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: fait,
                              decoration: InputDecoration(
                                hintText: 'Fait',
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
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    if (article != null) {
                                      CommandeOperation().addCommdeop(
                                          colis.text,
                                          colisDes.text,
                                          article,
                                          appartenant.text,
                                          fait.text,
                                          unitev);
                                      clearText();
                                      if (widget.page == "Réception") {
                                        Get.to(() => CreerReception(
                                            idus: widget.idus,
                                            url: widget.url,
                                            telus: widget.telus,
                                            adrus: widget.adrus,
                                            accesus: widget.accesus,
                                            nameus: widget.nameus,
                                            emailus: widget.emailus,
                                            roleus: widget.roleus));
                                      } else if (widget.page == "Transfert") {
                                        Get.to(() => CreerTransfert(
                                            idus: widget.idus,
                                            url: widget.url,
                                            telus: widget.telus,
                                            adrus: widget.adrus,
                                            accesus: widget.accesus,
                                            nameus: widget.nameus,
                                            emailus: widget.emailus,
                                            roleus: widget.roleus));
                                      } else {
                                        Get.to(() => CreerLivraison(
                                            idus: widget.idus,
                                            url: widget.url,
                                            telus: widget.telus,
                                            adrus: widget.adrus,
                                            accesus: widget.accesus,
                                            nameus: widget.nameus,
                                            emailus: widget.emailus,
                                            roleus: widget.roleus));
                                      }
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
              ),
            ] else ...[
              const Text(""),
            ]
          ],
        ),
      ),
    );
  }
}
