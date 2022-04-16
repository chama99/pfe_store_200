// ignore_for_file: unused_import, deprecated_member_use

// ignore: avoid_web_libraries_in_flutter

import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:chama_projet/services/commande.dart';
import 'package:chama_projet/services/contact.dart';
import 'package:chama_projet/services/devis.dart';
import 'package:chama_projet/widget/toast.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multiselect/flutter_multiselect.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import '../services/employe.dart';
import '../widget/InputDeco_design.dart';
import 'LigneDECommande.dart';
import 'listDevis.dart';

class CreeDevisPage extends StatefulWidget {
  const CreeDevisPage({Key? key}) : super(key: key);

  @override
  _CreeDevisPageState createState() => _CreeDevisPageState();
}

class _CreeDevisPageState extends State<CreeDevisPage> {
  // ignore: non_constant_identifier_names
  final Contolleremise = TextEditingController();
  DateTime dataTime = DateTime.now();
  int? sortColumnIndex;
  bool isAscending = false;

  final _formKey = GlobalKey<FormState>();
  final titre = TextEditingController();

  // ignore: prefer_typing_uninitialized_variables
  var client;
  // ignore: prefer_typing_uninitialized_variables
  var etat;
  List listItem = ["Devis", "Bon de commande"];

  var taxe = 0.00;
  var total = 0.00;
  // ignore: prefer_typing_uninitialized_variables
  late double remisee = 0.00;
  // ignore: prefer_final_fields
  StreamController<String> _streamController = StreamController();

  bool test = false;
  @override
  void initState() {
    super.initState();
    fetchDatabaseList();
    _streamController.stream.listen((item) {
      setState(() {
        var ch = item.substring(0, item.indexOf("%"));
        // ignore: unnecessary_cast
        double r = double.parse(ch) as double;

        // ignore: unnecessary_cast
        remisee = r / 100 as double;
      });
    });
  }

  List userContactList = [];
  List commandeList = [];
  List listTotal = [];
  List list = [];

  fetchDatabaseList() async {
    dynamic resultant = await Contact().getContactListByNom();
    dynamic resultant2 = await Commande().getCommandesList();

    if (resultant == null) {
      // ignore: avoid_print
      print('Unable to retrieve');
    } else {
      setState(() {
        userContactList = resultant;
        commandeList = resultant2;
        Commande().deleteCommande();
      });
    }
  }

  addList() {
    for (var i = 0; i < commandeList.length; i++) {
      list.add(commandeList[i]);
    }
  }

  var ch = "Nouveau";

  calculMontat() {
    var montant = 0.00;
    for (var i = 0; i < commandeList.length; i++) {
      montant = montant + commandeList[i]["sous-total"];
    }
    return montant;
  }

  late String dropdown;
  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final number = Random().nextInt(20);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Créer Un Devis"),
        backgroundColor: Colors.orange,
      ),
      body: RefreshIndicator(
        onRefresh: () {
          Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                  // ignore: prefer_const_constructors
                  pageBuilder: (a, b, c) => CreeDevisPage(),
                  // ignore: prefer_const_constructors
                  transitionDuration: Duration(seconds: 0)));
          // ignore: void_checks
          return Future.value(false);
        },
        child: Column(
          children: [
            Expanded(
                child: Form(
              key: _formKey,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: Column(
                  children: [
                    Expanded(
                        child: ListView(
                      children: [
                        Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              ch,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                  color: Colors.grey),
                            )),
                        Padding(
                          padding: const EdgeInsets.all(13),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LigneCommande()));
                            },
                            child: const Text(
                              "Ajouter Lignes de la commande",
                              style: TextStyle(
                                  fontSize: 15,
                                  letterSpacing: 3,
                                  color: Colors.indigo),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SingleChildScrollView(
                            child: DataTable(
                              sortAscending: isAscending,
                              sortColumnIndex: sortColumnIndex,
                              columns: [
                                DataColumn(
                                  label: const Text("réf"),
                                  onSort: onSort,
                                ),
                                DataColumn(
                                  label: const Text("Article"),
                                  onSort: onSort,
                                ),
                                DataColumn(
                                  label: const Text("Description"),
                                  onSort: onSort,
                                ),
                                DataColumn(
                                  label: const Text("Unité"),
                                  onSort: onSort,
                                ),
                                DataColumn(
                                  label: const Text("Quantité"),
                                  onSort: onSort,
                                ),
                                DataColumn(
                                  label: const Text("Prix unitaire"),
                                  onSort: onSort,
                                ),
                                DataColumn(
                                  label: const Text("Taxes"),
                                  onSort: onSort,
                                ),
                                DataColumn(
                                  label: const Text("Sous-total"),
                                  onSort: onSort,
                                )
                              ],
                              rows: [
                                for (var i = 0;
                                    i < commandeList.length;
                                    i++) ...[
                                  DataRow(cells: [
                                    DataCell(Text("${commandeList[i]['réf']}")),
                                    DataCell(Text(commandeList[i]['Article'])),
                                    DataCell(
                                        Text(commandeList[i]['Description'])),
                                    DataCell(
                                        Text("${commandeList[i]['Unite']}")),
                                    DataCell(
                                        Text("${commandeList[i]['Quantite']}")),
                                    DataCell(
                                        Text("${commandeList[i]['prix']}")),
                                    const DataCell(Text("${0.2}")),
                                    DataCell(Text(
                                        "${commandeList[i]["sous-total"]}")),
                                  ]),
                                ]
                              ],
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(13),
                              child: Text(
                                "Client",
                                style:
                                    TextStyle(fontSize: 15, letterSpacing: 3),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 38),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                      color: Colors.grey, width: 1.5)),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  dropdownColor: Colors.white,
                                  icon: const Padding(
                                    padding: EdgeInsets.only(left: 115),
                                    child: Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.orange,
                                    ),
                                  ),
                                  style: const TextStyle(
                                      fontSize: 20, color: Colors.black),
                                  iconSize: 40,
                                  value: client,
                                  onChanged: (newValue) {
                                    setState(() {
                                      client = newValue.toString();
                                    });
                                  },
                                  items: userContactList.map((valueItem) {
                                    return DropdownMenuItem(
                                      value: valueItem,
                                      child: Text(valueItem),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(20),
                              child: Text(
                                "État",
                                style:
                                    TextStyle(fontSize: 15, letterSpacing: 3),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 43),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                      color: Colors.grey, width: 1.5)),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  dropdownColor: Colors.white,
                                  icon: const Padding(
                                    padding: EdgeInsets.only(left: 20),
                                    child: Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.orange,
                                    ),
                                  ),
                                  style: const TextStyle(
                                      fontSize: 20, color: Colors.black),
                                  iconSize: 40,
                                  value: etat,
                                  onChanged: (newValue) {
                                    setState(() {
                                      etat = newValue.toString();
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
                          ],
                        ),
                        Row(
                          children: const [
                            Padding(
                              padding: EdgeInsets.all(20),
                              child: Text(
                                "Date de facturations",
                                style:
                                    TextStyle(fontSize: 15, letterSpacing: 3),
                              ),
                            ),
                          ],
                        ),
                        Container(child: buildDatePicker(dataTime)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(
                                  top: 30, right: 13, left: 13, bottom: 40),
                              child: const Text(
                                "Remise",
                                style:
                                    TextStyle(fontSize: 15, letterSpacing: 3),
                              ),
                            ),
                            Flexible(
                              child: Container(
                                margin:
                                    const EdgeInsets.only(left: 45, right: 65),
                                child: TextFormField(
                                  controller: Contolleremise,
                                  decoration: InputDecoration(
                                    hintText: 'valeur %',
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
                                    if (!RegExp("%").hasMatch(value!)) {
                                      return "Veuillez entrer\n  valeur avec % ";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                // Validate returns true if the form is valid, otherwise false.
                                if (_formKey.currentState!.validate()) {
                                  _streamController.add(Contolleremise.text);
                                }
                              },
                              child: const Text(
                                "Ajouter",
                                style: TextStyle(fontSize: 18.0),
                              ),
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.orange),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: 350,
                              height: 200,
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  color: Color.fromARGB(255, 245, 245, 245)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 8, top: 15),
                                child: Column(
                                  children: [
                                    Text(
                                      "Montant HT: ${calculMontat()}",
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Remise: $remisee",
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Taxes: $taxe",
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                    ),
                                    const Divider(
                                      color: Colors.black,
                                    ),
                                    Text(
                                      "Total:  ${calculMontat() - remisee}",
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )),
                  ],
                ),
              ),
            )),
          ],
        ),
      ),
      bottomNavigationBar: ElevatedButton(
        style: ElevatedButton.styleFrom(
          maximumSize: const Size(double.infinity, 50),
          primary: Colors.indigo,
        ),
        child: const Text("Saufgarder"),
        onPressed: () {
          // Validate returns true if the form is valid, otherwise false.
          if (_formKey.currentState!.validate()) {
            if (client != null) {
              if (etat != null) {
                // ignore: prefer_adjacent_string_concatenation
                ch = "D" + "$number";
                addList();

                Devis().addDevis(ch, client, etat, calculMontat() - remisee,
                    list, remisee, calculMontat(), dataTime);

                Get.to(() => const ListDevis());
              } else {
                showToast("veuillez sélectionner état");
              }
            } else {
              showToast("veuillez sélectionner client");
            }
          }
        },
      ),
    );
  }

  void onSort(int columnIndex, bool ascending) {
    setState(() {
      sortColumnIndex = columnIndex;
      isAscending = ascending;
    });
  }

  Widget buildDatePicker(date) => SizedBox(
        height: 150,
        child: CupertinoDatePicker(
          initialDateTime: date,
          mode: CupertinoDatePickerMode.date,
          onDateTimeChanged: (dateTime) => setState(() {
            date = dateTime;
          }),
        ),
      );
}
