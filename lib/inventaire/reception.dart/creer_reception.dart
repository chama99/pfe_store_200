import 'dart:math';

import 'package:chama_projet/inventaire/reception.dart/LigneOperation.dart';
import 'package:chama_projet/inventaire/reception.dart/listReception.dart';
import 'package:chama_projet/services/reception.dart';
import 'package:chama_projet/services/ligneOperation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widget/toast.dart';

class CreerReception extends StatefulWidget {
  const CreerReception({Key? key}) : super(key: key);

  @override
  State<CreerReception> createState() => _CreerReceptionState();
}

class _CreerReceptionState extends State<CreerReception> {
  final _formKey = GlobalKey<FormState>();
  final titre = TextEditingController();
  DateTime dataTime = DateTime.now();
  List commandeList = [];

  var ch = "Nouveau";
  // ignore: prefer_typing_uninitialized_variables
  var typeoperation;
  // ignore: prefer_typing_uninitialized_variables
  var etat;
  // ignore: prefer_typing_uninitialized_variables
  var operation;
  // ignore: prefer_typing_uninitialized_variables
  var reception;
  List listItem = ["Atelier:Livraison", "Atelier:Réception"];
  List listItem2 = ["Brouillon", "En attente", "Prêt"];
  List list = [];
  List receptionList = ["Stock1", "Stock2", "Stock3", "Stock4"];
  List livraisonList = ["kgkkgk", "klklml"];
  addList() {
    for (var i = 0; i < commandeList.length; i++) {
      list.add(commandeList[i]);
    }
  }

  fetchDatabaseList() async {
    dynamic resultant = await CommandeOperation().getCommopList();

    if (resultant == null) {
      // ignore: avoid_print
      print('Unable to retrieve');
    } else {
      setState(() {
        commandeList = resultant;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDatabaseList();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final number = Random().nextInt(20);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Créer un Reception"),
        backgroundColor: Colors.orange,
      ),
      body: RefreshIndicator(
        onRefresh: () {
          Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                  // ignore: prefer_const_constructors
                  pageBuilder: (a, b, c) => CreerReception(),
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
                              Get.to(() => const LigneOperation());
                            },
                            child: const Text(
                              "Ajouter Une Opération",
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
                              columns: const [
                                DataColumn(
                                  label: Text("Article"),
                                ),
                                DataColumn(
                                  label: Text("Colis source"),
                                ),
                                DataColumn(
                                  label: Text("Colis de destination"),
                                ),
                                DataColumn(
                                  label: Text("Appartenant à"),
                                ),
                                DataColumn(
                                  label: Text("Fait"),
                                ),
                                DataColumn(
                                  label: Text("Unité de mesure"),
                                ),
                              ],
                              rows: [
                                for (var i = 0;
                                    i < commandeList.length;
                                    i++) ...[
                                  DataRow(cells: [
                                    DataCell(Text(commandeList[i]['Article'])),
                                    DataCell(
                                        Text(commandeList[i]['Colis source'])),
                                    DataCell(Text(commandeList[i]
                                        ['Colis de destination'])),
                                    DataCell(Text(
                                        "${commandeList[i]['Appartenant']}")),
                                    DataCell(
                                        Text("${commandeList[i]['Fait']}")),
                                    DataCell(
                                        Text("${commandeList[i]['Unite']}")),
                                  ]),
                                ]
                              ],
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 10, top: 30),
                              child: Text(
                                "Type d'opération",
                                style:
                                    TextStyle(fontSize: 15, letterSpacing: 3),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 30),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                      color: Colors.grey, width: 1.5)),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  dropdownColor: Colors.white,
                                  icon: const Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.orange,
                                  ),
                                  style: const TextStyle(
                                      fontSize: 20, color: Colors.black),
                                  iconSize: 40,
                                  value: operation,
                                  onChanged: (newValue) {
                                    setState(() {
                                      operation = newValue.toString();
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
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 35, top: 20),
                              child: Text(
                                "Réception de",
                                style:
                                    TextStyle(fontSize: 15, letterSpacing: 3),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                      color: Colors.grey, width: 1.5)),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  dropdownColor: Colors.white,
                                  icon: const Padding(
                                    padding: EdgeInsets.only(left: 100),
                                    child: Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.orange,
                                    ),
                                  ),
                                  style: const TextStyle(
                                      fontSize: 20, color: Colors.black),
                                  iconSize: 40,
                                  value: reception,
                                  onChanged: (newValue) {
                                    setState(() {
                                      reception = newValue.toString();
                                    });
                                  },
                                  items: receptionList.map((valueItem) {
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
                              padding: EdgeInsets.only(left: 15, top: 30),
                              child: Text(
                                "État",
                                style:
                                    TextStyle(fontSize: 15, letterSpacing: 3),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 110, top: 30),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                      color: Colors.grey, width: 1.5)),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  dropdownColor: Colors.white,
                                  icon: const Padding(
                                    padding: EdgeInsets.only(left: 10),
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
                                  items: listItem2.map((valueItem) {
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
                                "Date prévue",
                                style:
                                    TextStyle(fontSize: 15, letterSpacing: 3),
                              ),
                            ),
                          ],
                        ),
                        Container(child: buildDatePicker(dataTime)),
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
            // ignore: prefer_adjacent_string_concatenation
            ch = "Inventaire" + "$number";
            addList();
            if (operation != null) {
              if (etat != null) {
                Reception().addReception(
                    ch, operation, etat, dataTime, list, reception);
                CommandeOperation().deleteCommdeop();
                Get.to(() => const ListReception());
              } else {
                showToast("veuillez sélectionner etat ");
              }
            } else {
              showToast("veuillez sélectionner client type d'opération");
            }
          }
        },
      ),
    );
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
