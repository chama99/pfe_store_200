// ignore_for_file: unused_import, deprecated_member_use

// ignore: avoid_web_libraries_in_flutter

import 'dart:io';
import 'package:chama_projet/pages/table.dart';
import 'package:chama_projet/services/contact.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multiselect/flutter_multiselect.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import '../services/employe.dart';
import '../widget/InputDeco_design.dart';

class CreeDevisPage extends StatefulWidget {
  const CreeDevisPage({Key? key}) : super(key: key);

  @override
  _CreeDevisPageState createState() => _CreeDevisPageState();
}

class _CreeDevisPageState extends State<CreeDevisPage> {
  final lists = [
    'First Name',
    'Last Name',
    'chama',
    'hadd',
    'manar',
    'tess',
    'maloika',
    'tess'
  ];
  // ignore: non_constant_identifier_names
  final Contolleremise = TextEditingController();

  int? sortColumnIndex;
  bool isAscending = false;
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  XFile? imageFile;

  final _formKey = GlobalKey<FormState>();

  // ignore: prefer_typing_uninitialized_variables
  var ch;
  List listItem = ["Devis", "Bon de commande"];
  var montant = "0,00";
  var taxe = "0,00";

  bool test = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    fetchDatabaseList();
  }

  List userContactList = [];

  fetchDatabaseList() async {
    dynamic resultant = await Contact().getContactListByNom();

    if (resultant == null) {
      // ignore: avoid_print
      print('Unable to retrieve');
    } else {
      setState(() {
        userContactList = resultant;
      });
    }
  }

  late String dropdown;

  @override
  Widget build(BuildContext context) {
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
                            child: TextFormField(
                              decoration: InputDecoration(
                                hintText: 'Titire',
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
                                    value: ch,
                                    onChanged: (newValue) {
                                      setState(() {
                                        ch = newValue.toString();
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
                                  "Etat",
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
                                    value: ch,
                                    onChanged: (newValue) {
                                      setState(() {
                                        ch = newValue.toString();
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
                          Padding(
                            padding: const EdgeInsets.all(13),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const Tabletest()));
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
                                  DataRow(cells: getCells(lists)),
                                ],
                              ),
                            ),
                          ),
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
                                  margin: const EdgeInsets.only(
                                      left: 45, right: 65),
                                  child: TextFormField(
                                    controller: Contolleremise,
                                    decoration: InputDecoration(
                                      hintText: 'Pourcentage(%)',
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
                              )
                            ],
                          ),
                          if (Contolleremise.text.isEmpty) ...[
                            Row(
                              children: [
                                Container(
                                  width: 220,
                                  height: 200,
                                  margin: const EdgeInsets.only(
                                      top: 30, right: 50, left: 80, bottom: 40),
                                  decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                      color:
                                          Color.fromARGB(255, 245, 245, 245)),
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(left: 8, top: 15),
                                    child: Column(
                                      children: [
                                        Text(
                                          "Montant HT: $montant",
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            "Remise: 0,00",
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "Taxes: $taxe",
                                            style:
                                                const TextStyle(fontSize: 20),
                                          ),
                                        ),
                                        const Divider(
                                          color: Colors.black,
                                        ),
                                        Text(
                                          "Total: $taxe",
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ] else ...[
                            Row(
                              children: [
                                Container(
                                  width: 220,
                                  height: 200,
                                  margin: const EdgeInsets.only(
                                      top: 30, right: 50, left: 80, bottom: 40),
                                  decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                      color:
                                          Color.fromARGB(255, 245, 245, 245)),
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(left: 8, top: 15),
                                    child: Column(
                                      children: [
                                        Text(
                                          "Montant HT: $montant",
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "Remise: ${int.parse("Contolleremise.text") / 100}",
                                            style:
                                                const TextStyle(fontSize: 20),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "Taxes: $taxe",
                                            style:
                                                const TextStyle(fontSize: 20),
                                          ),
                                        ),
                                        const Divider(
                                          color: Colors.black,
                                        ),
                                        Text(
                                          "Total: $taxe",
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  // Validate returns true if the form is valid, otherwise false.
                                  if (_formKey.currentState!.validate()) {}
                                },
                                child: const Text(
                                  "Sauvegarder",
                                  style: TextStyle(fontSize: 18.0),
                                ),
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.orange),
                              ),
                            ],
                          )
                        ],
                      )),
                    ],
                  ),
                ),
              )),
            ],
          ),
        ));
  }

  showToast(mssg) => Fluttertoast.showToast(
      msg: mssg,
      fontSize: 50,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.red,
      textColor: Colors.white);
  void onSort(int columnIndex, bool ascending) {
    setState(() {
      sortColumnIndex = columnIndex;
      isAscending = ascending;
    });
  }

  List<DataCell> getCells(List<dynamic> cells) =>
      cells.map((data) => DataCell(Text('$data'))).toList();
}
