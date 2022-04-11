// ignore_for_file: must_be_immutable

import 'dart:async';

import 'package:chama_projet/facture.dart/listfact.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/contact.dart';
import '../services/facture.dart';
import '../services/lignefact.dart';
import '../widget/toast.dart';
import 'AjoutLigneFact.dart';
import 'ModifierLigneFact.dart';

class UpdateFacture extends StatefulWidget {
  String titre, client, etat, adrss;
  final double order;
  double montant;
  List listfact;
  String date1, date2;

  double total;
  UpdateFacture(
      {Key? key,
      required this.titre,
      required this.client,
      required this.etat,
      required this.adrss,
      required this.total,
      required this.order,
      required this.listfact,
      required this.montant,
      required this.date1,
      required this.date2})
      : super(key: key);

  @override
  State<UpdateFacture> createState() => _UpdateFactureState();
}

class _UpdateFactureState extends State<UpdateFacture> {
  int? sortColumnIndex;
  bool isAscending = false;
  final _formKey = GlobalKey<FormState>();
  // ignore: prefer_typing_uninitialized_variables

  List listItem = ["Brouillon", "Comptabilisé"];
  double remise = 0.00;
  // ignore: non_constant_identifier_names
  final Contolleremise = TextEditingController();
  final n = TextEditingController();
  // ignore: prefer_final_fields
  StreamController<String> streamController = StreamController();
  List listitem = [];

  calculMontat() {
    var montant = 0.00;
    for (var i = 0; i < widget.listfact.length; i++) {
      montant = montant + widget.listfact[i]["sous-total"];
    }
    return montant;
  }

  @override
  void initState() {
    super.initState();
    fetchDatabaseList();
    streamController.stream.listen((item) {
      setState(() {
        var ch = item.substring(0, item.indexOf("%"));
        // ignore: unnecessary_cast
        double r = double.parse(ch) as double;

        // ignore: unnecessary_cast
        remise = r / 100 as double;
      });
    });
  }

  List userContactList = [];
  List commandeList = [];

  fetchDatabaseList() async {
    dynamic resultant = await Contact().getContactListByNom();
    dynamic resultant2 = await CommandeFact().getCommList();

    if (resultant == null) {
      // ignore: avoid_print
      print('Unable to retrieve');
    } else {
      setState(() {
        userContactList = resultant;
        commandeList = resultant2;
      });
    }
  }

  var taxe = 0.00;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Facture / ${widget.titre}",
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.orange,
      ),
      body: RefreshIndicator(
        onRefresh: () {
          Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                  // ignore: prefer_const_constructors
                  pageBuilder: (a, b, c) => UpdateFacture(
                        titre: widget.titre,
                        client: widget.client,
                        etat: widget.etat,
                        adrss: widget.adrss,
                        total: widget.total,
                        order: widget.order,
                        listfact: widget.listfact,
                        montant: widget.montant,
                        date1: widget.date1,
                        date2: widget.date2,
                      ),
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
                        Row(
                          children: [
                            const Text(
                              "Ajouter lignes de commande ",
                              style: TextStyle(
                                  fontSize: 15,
                                  letterSpacing: 3,
                                  color: Colors.indigo),
                              textAlign: TextAlign.left,
                            ),
                            IconButton(
                              onPressed: () {
                                Get.to(() => AjoutLigneFacture(
                                    titre: widget.titre,
                                    commande: widget.listfact,
                                    adresse: widget.adrss,
                                    client: widget.client,
                                    date1: widget.date1,
                                    date2: widget.date2,
                                    etat: widget.etat,
                                    montant: widget.montant,
                                    remise: remise,
                                    total: widget.total));
                              },
                              icon: const Icon(
                                Icons.add,
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              "Modifier la commande Numéro :",
                              style: TextStyle(
                                  fontSize: 15,
                                  letterSpacing: 3,
                                  color: Colors.indigo),
                              textAlign: TextAlign.left,
                            ),
                            Flexible(
                              child: TextFormField(
                                controller: n,
                                decoration: InputDecoration(
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
                            Flexible(
                              child: IconButton(
                                onPressed: () {
                                  if (n.text.isEmpty) {
                                    showToast(
                                        "Veuillez entrer Numéro de ligne");
                                  } else {
                                    Get.to(() => ModifieLignFact(
                                        titre: widget.titre,
                                        commande: widget.listfact,
                                        num: int.parse(n.text),
                                        adresse: widget.adrss,
                                        client: widget.client,
                                        date1: widget.date1,
                                        date2: widget.date2,
                                        etat: widget.etat,
                                        montant: widget.montant,
                                        remise: remise,
                                        total: widget.total));
                                  }
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.orange,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SingleChildScrollView(
                            child: DataTable(
                              columns: const [
                                DataColumn(
                                  label: Text("Numéro de ligne"),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Article",
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Libélle",
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Compte analytique",
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Étiquette analytique",
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Quantité",
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Prix ",
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "TVA",
                                  ),
                                ),
                                DataColumn(
                                  label: Text("Sous-total"),
                                )
                              ],
                              rows: [
                                for (var i = 0;
                                    i < widget.listfact.length;
                                    i++) ...[
                                  DataRow(cells: [
                                    DataCell(Text("$i")),
                                    DataCell(
                                        Text(widget.listfact[i]['Article'])),
                                    DataCell(
                                        Text(widget.listfact[i]['Libélle'])),
                                    DataCell(Text(
                                        "${widget.listfact[i]['Compte analytique']}")),
                                    DataCell(Text(
                                        "${widget.listfact[i]['Etiquette analytique']}")),
                                    DataCell(Text(
                                        "${widget.listfact[i]['Quantite']}")),
                                    DataCell(
                                        Text("${widget.listfact[i]['prix']}")),
                                    const DataCell(Text("20%")),
                                    DataCell(Text(
                                        "${widget.listfact[i]["sous-total"]}")),
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
                                  value: widget.client,
                                  onChanged: (newValue) {
                                    setState(() {
                                      widget.client = newValue.toString();
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
                                  value: widget.etat,
                                  onChanged: (newValue) {
                                    setState(() {
                                      widget.etat = newValue.toString();
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
                        Container(
                          margin: const EdgeInsets.only(top: 40, bottom: 40),
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(20),
                                child: Text(
                                  "Adresse d'intervention",
                                  style:
                                      TextStyle(fontSize: 15, letterSpacing: 3),
                                ),
                              ),
                              Flexible(
                                child: TextFormField(
                                  initialValue: widget.adrss,
                                  onChanged: (value) => widget.adrss = value,
                                  decoration: InputDecoration(
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
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 40),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(
                                    top: 30, right: 13, left: 13, bottom: 10),
                                child: const Text(
                                  "Modifier une remise",
                                  style:
                                      TextStyle(fontSize: 15, letterSpacing: 3),
                                ),
                              ),
                              Flexible(
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 10, right: 65, top: 30),
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
                                        return "Veuillez\nentrer\nvaleur\navec % ";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                // Validate returns true if the form is valid, otherwise false.
                                if (_formKey.currentState!.validate()) {
                                  streamController.add(Contolleremise.text);
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
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          child: Row(
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
                                      Text(
                                        "Remise: $remise",
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                      const Divider(
                                        color: Colors.black,
                                      ),
                                      Text(
                                        "Total: ${calculMontat() - remise}",
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
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
        child: const Text("Modifier"),
        onPressed: () {
          // Validate returns true if the form is valid, otherwise false.
          if (_formKey.currentState!.validate()) {
            // ignore: prefer_adjacent_string_concatenation
            Facture().updateFacture(
                widget.titre,
                widget.client,
                widget.etat,
                DateTime.parse(widget.date1),
                DateTime.parse(widget.date2),
                widget.adrss,
                calculMontat() - remise,
                widget.listfact,
                remise,
                calculMontat());
            Get.to(() => const ListFacture());
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
