import 'dart:math';

import 'package:chama_projet/inventaire/reception.dart/LigneOperation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  List userContactList = [];
  var ch = "Nouveau";
  // ignore: prefer_typing_uninitialized_variables
  var client;
  // ignore: prefer_typing_uninitialized_variables
  var etat;
  // ignore: prefer_typing_uninitialized_variables
  var operation;
  List listItem = ["Atelier:Livraison", "Atelier:Réception"];
  List listItem2 = ["Brouillon", "En attente", "Prêt"];
  @override
  Widget build(BuildContext context) {
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
                                        Text(commandeList[i]['Description'])),
                                    DataCell(
                                        Text("${commandeList[i]['Unite']}")),
                                    DataCell(
                                        Text("${commandeList[i]['Quantite']}")),
                                    DataCell(
                                        Text("${commandeList[i]['prix']}")),
                                    const DataCell(Text("${0.2}")),
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
                        if (operation == "Atelier:Réception") ...[
                          Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 13, top: 20),
                                child: Text(
                                  "Réception de",
                                  style:
                                      TextStyle(fontSize: 15, letterSpacing: 3),
                                ),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.only(left: 28, top: 20),
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
                        ],
                        if (operation == "Atelier:Livraison") ...[
                          Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(13),
                                child: Text(
                                  "Adresse de livraison",
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
                                      padding: EdgeInsets.only(left: 80),
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
                        ],
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
          if (_formKey.currentState!.validate()) {}
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
