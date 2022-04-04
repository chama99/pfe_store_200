// ignore_for_file: must_be_immutable, file_names

import 'dart:async';

import 'package:chama_projet/devis.dart/Modifiercommande.dart';
import 'package:chama_projet/devis.dart/listDevis.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/devis.dart';
import '../widget/toast.dart';
import 'AjoutligneCommande.dart';

class UpdateDevis extends StatefulWidget {
  List commande;
  String titre;
  String etat, client;
  double remise;
  double total, montant;
  UpdateDevis(
      {Key? key,
      required this.titre,
      required this.client,
      required this.etat,
      required this.commande,
      required this.remise,
      required this.total,
      required this.montant})
      : super(key: key);

  @override
  State<UpdateDevis> createState() => _UpdateDevisState();
}

class _UpdateDevisState extends State<UpdateDevis> {
  int? sortColumnIndex;
  bool isAscending = false;
  final _formKey = GlobalKey<FormState>();
  // ignore: prefer_typing_uninitialized_variables

  List listItem = ["Devis", "Bon de commande"];
  double remise = 0.00;
  // ignore: non_constant_identifier_names
  final Contolleremise = TextEditingController();
  final n = TextEditingController();
  // ignore: prefer_final_fields
  StreamController<String> _streamController = StreamController();
  List listitem = [];

  @override
  void initState() {
    super.initState();

    _streamController.stream.listen((item) {
      setState(() {
        var ch = item.substring(0, item.indexOf("%"));
        // ignore: unnecessary_cast
        double r = double.parse(ch) as double;

        // ignore: unnecessary_cast
        remise = r / 100 as double;
      });
    });
  }

  calculMontat(List list) {
    for (var i = 0; i < list.length; i++) {
      montant = montant + list[i]["sous-total"];
    }
  }

  var montant = 0.00;
  var taxe = 0.00;
  var total = 0.00;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Devis / ${widget.titre}",
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
                  pageBuilder: (a, b, c) => UpdateDevis(
                        titre: widget.titre,
                        client: widget.client,
                        etat: widget.etat,
                        commande: widget.commande,
                        remise: widget.remise,
                        total: widget.total,
                        montant: widget.montant,
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
                                Get.to(() => AjoutCommande(
                                      titre: widget.titre,
                                      client: widget.client,
                                      etat: widget.etat,
                                      commande: widget.commande,
                                      remise: widget.remise,
                                      total: widget.total,
                                      montant: widget.montant,
                                    ));
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
                                    Get.to(() => ModifierCommande(
                                          num: n.text,
                                          titre: widget.titre,
                                          client: widget.client,
                                          etat: widget.etat,
                                          commande: widget.commande,
                                          remise: widget.remise,
                                          total: widget.total,
                                          montant: widget.montant,
                                        ));
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
                              sortAscending: isAscending,
                              sortColumnIndex: sortColumnIndex,
                              columns: [
                                DataColumn(
                                  label: const Text("Numéro de ligne"),
                                  onSort: onSort,
                                ),
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
                                    i < widget.commande.length;
                                    i++) ...[
                                  DataRow(cells: [
                                    DataCell(Text("$i")),
                                    DataCell(
                                        Text("${widget.commande[i]['réf']}")),
                                    DataCell(
                                        Text(widget.commande[i]['Article'])),
                                    DataCell(Text(
                                        widget.commande[i]['Description'])),
                                    DataCell(
                                        Text("${widget.commande[i]['Unite']}")),
                                    DataCell(Text(
                                        "${widget.commande[i]['Quantite']}")),
                                    DataCell(
                                        Text("${widget.commande[i]['prix']}")),
                                    const DataCell(Text("${0.2}")),
                                    DataCell(Text(
                                        "${widget.commande[i]["Quantite"] * widget.commande[i]["prix"]}")),
                                  ]),
                                ]
                              ],
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 20, top: 30),
                              child: Text(
                                "État",
                                style:
                                    TextStyle(fontSize: 15, letterSpacing: 3),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 43, top: 25),
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
                                    const EdgeInsets.only(left: 10, right: 65),
                                child: TextFormField(
                                  controller: Contolleremise,
                                  decoration: InputDecoration(
                                    hintText: '${widget.remise}',
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
                                      return "Veuillez entrer valeur\n de remise ";
                                    }
                                    if (!RegExp("%").hasMatch(value)) {
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
                                if (Contolleremise.text.isEmpty) {
                                  _streamController
                                      .add("${widget.remise * 100}%");
                                } else {
                                  _streamController.add(Contolleremise.text);
                                }
                                calculMontat(widget.commande);

                                total = (0.2 + montant) - remise;
                              },
                              child: const Text(
                                "Calculer",
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
                                      "Montant HT:$montant ",
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Remise:$remise ",
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        "Taxes: 0.2",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                    const Divider(
                                      color: Colors.black,
                                    ),
                                    Text(
                                      "Total: $total",
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: ElevatedButton(
                            onPressed: () {
                              Devis().updateDevis(
                                  widget.titre,
                                  widget.client,
                                  widget.etat,
                                  total,
                                  widget.commande,
                                  remise,
                                  montant);
                              Get.to(() => const ListDevis());
                            },
                            child: const Text(
                              "Sauvgarder",
                              style: TextStyle(fontSize: 18.0),
                            ),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.indigo),
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
    );
  }

  void onSort(int columnIndex, bool ascending) {
    setState(() {
      sortColumnIndex = columnIndex;
      isAscending = ascending;
    });
  }
}

class $ {}
