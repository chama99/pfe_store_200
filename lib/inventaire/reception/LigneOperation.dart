// ignore_for_file: file_names, must_be_immutable

import 'package:chama_projet/inventaire/Transfert/creer_transfert.dart';
import 'package:chama_projet/inventaire/livraison/creer_livraison.dart';
import 'package:chama_projet/services/ligneOperation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widget/toast.dart';
import 'creer_reception.dart';

class LigneOperation extends StatefulWidget {
  String page;
  LigneOperation({Key? key, required this.page}) : super(key: key);

  @override
  State<LigneOperation> createState() => _LigneOperationState();
}

class _LigneOperationState extends State<LigneOperation> {
  final _formKey = GlobalKey<FormState>();
  // ignore: prefer_typing_uninitialized_variables
  var article;

  List listItem = ["store12", "store15"];
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

    article = null;
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text("Ajouter Ligne de opérations"),
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
                    controller: colis,
                    decoration: InputDecoration(
                      hintText: 'Colis source',
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
                    controller: fait,
                    decoration: InputDecoration(
                      hintText: 'Fait',
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
                    controller: unite,
                    decoration: InputDecoration(
                      hintText: 'Unité de mesure',
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
                        return "Veuillez entrer unité de mesure";
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
                            CommandeOperation().addCommdeop(
                                colis.text,
                                colisDes.text,
                                article,
                                appartenant.text,
                                fait.text,
                                int.parse(unite.text));
                            clearText();
                            if (widget.page == "reception") {
                              Get.to(() => const CreerReception());
                            } else if (widget.page == "transfert") {
                              Get.to(() => const CreerTransfert());
                            } else {
                              Get.to(() => const CreerLivraison());
                            }
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
