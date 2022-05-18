// ignore_for_file: must_be_immutable, file_names

import 'dart:async';

import 'package:chama_projet/devis.dart/Modifiercommande.dart';
import 'package:chama_projet/devis.dart/listDevis.dart';
import 'package:flutter/material.dart';
import 'package:flutter_azure_b2c/GUIDGenerator.dart';
import 'package:get/get.dart';

import '../services/autofacture.dart';
import '../services/devis.dart';
import '../services/facture.dart';
import '../widget/NavBottom.dart';
import '../widget/toast.dart';
import 'AjoutligneCommande.dart';

class UpdateDevis extends StatefulWidget {
  List commande;
  String role, date, idus, tel, adr;
  String titre, id;
  String etat, client;
  int remise;
  double total, montant;
  String name, email, url;
  List acces;
  UpdateDevis(
      {Key? key,
      required this.idus,
      required this.id,
      required this.titre,
      required this.client,
      required this.etat,
      required this.commande,
      required this.remise,
      required this.total,
      required this.montant,
      required this.role,
      required this.date,
      required this.email,
      required this.name,
      required this.acces,
      required this.url,
      required this.tel,
      required this.adr})
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
  int remise = 0;
  final String uuid = GUIDGen.generate();
  // ignore: non_constant_identifier_names
  final Contolleremise = TextEditingController();
  final n = TextEditingController();
  // ignore: prefer_final_fields
  StreamController<String> streamController = StreamController();
  List listitem = [];
  calculMontat() {
    var montant = 0.00;
    for (var i = 0; i < widget.commande.length; i++) {
      montant = montant + widget.commande[i]["sous-total"];
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
        int r = int.parse(ch);
        // ignore: unnecessary_cast
        remise = r;
      });
    });
  }

  List fact = [];
  List facta = [];
  fetchDatabaseList() async {
    dynamic resf = await Facture().getFacturesList();
    dynamic resfa = await AutoFacture().getFacturesList();

    if (resf == null) {
      // ignore: avoid_print
      print('Unable to retrieve');
    } else {
      setState(() {
        fact = resf;
        facta = resfa;
      });
    }
  }

  var taxe = 0.00;

  @override
  Widget build(BuildContext context) {
    var lf = fact.length + facta.length;
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
      bottomNavigationBar: NavBottom(
          tel: widget.tel,
          adr: widget.adr,
          id: widget.idus,
          email: widget.email,
          name: widget.name,
          acces: widget.acces,
          url: widget.url,
          role: widget.role),
      body: RefreshIndicator(
        onRefresh: () {
          Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                  // ignore: prefer_const_constructors
                  pageBuilder: (a, b, c) => UpdateDevis(
                        idus: widget.idus,
                        id: widget.id,
                        titre: widget.titre,
                        client: widget.client,
                        etat: widget.etat,
                        commande: widget.commande,
                        remise: widget.remise,
                        total: widget.total,
                        montant: widget.montant,
                        role: widget.role,
                        date: widget.date,
                        email: widget.email,
                        name: widget.name,
                        acces: widget.acces,
                        url: widget.url,
                        adr: widget.adr,
                        tel: widget.tel,
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
                                      idus: widget.idus,
                                      id: widget.id,
                                      titre: widget.titre,
                                      client: widget.client,
                                      etat: widget.etat,
                                      commande: widget.commande,
                                      remise: widget.remise,
                                      total: widget.total,
                                      montant: widget.montant,
                                      role: widget.role,
                                      date: widget.date,
                                      email: widget.email,
                                      name: widget.name,
                                      acces: widget.acces,
                                      url: widget.url,
                                      tel: widget.tel,
                                      adr: widget.adr,
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
                                          idus: widget.idus,
                                          id: widget.id,
                                          num: int.parse(n.text),
                                          titre: widget.titre,
                                          client: widget.client,
                                          etat: widget.etat,
                                          commande: widget.commande,
                                          remise: widget.remise,
                                          total: widget.total,
                                          montant: widget.montant,
                                          role: widget.role,
                                          date: widget.date,
                                          email: widget.email,
                                          name: widget.name,
                                          acces: widget.acces,
                                          url: widget.url,
                                          tel: widget.tel,
                                          adr: widget.adr,
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
                                    hintText: '${widget.remise}%',
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
                                // Validate returns true if the form is valid, otherwise false.
                                if (_formKey.currentState!.validate()) {
                                  streamController.add(Contolleremise.text);
                                  var ch = Contolleremise.text.substring(
                                      0, Contolleremise.text.indexOf("%"));
                                  // ignore: unnecessary_cast
                                  remise = int.parse(ch);
                                  // ignore: unnecessary_cast

                                  widget.remise = remise;
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
                                      "Montant HT:${calculMontat()} ",
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Remise:${widget.remise / 100} ",
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
                                      "Total: ${(calculMontat() * (1 + 0.2)) * (1 - (widget.remise / 100))}",
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
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                maximumSize: const Size(double.infinity, 50),
                primary: Colors.indigo,
              ),
              child: const Text("Modifier"),
              onPressed: () {
                // Validate returns true if the form is valid, otherwise false.

                Devis().updateDevis(
                    widget.id,
                    widget.client,
                    widget.etat,
                    (calculMontat() * (1 + 0.2)) * (1 - (widget.remise / 100)),
                    widget.commande,
                    widget.remise,
                    calculMontat());
                Get.to(() => ListDevis(
                      idus: widget.idus,
                      role: widget.role,
                      email: widget.email,
                      name: widget.name,
                      acces: widget.acces,
                      url: widget.url,
                      tel: widget.tel,
                      adr: widget.adr,
                    ));
                if (widget.etat == "Bon de commande") {
                  AutoFacture().addFacture(
                      uuid,
                      "Facture N°${lf + 1}",
                      widget.titre,
                      widget.client,
                      "Brouillon",
                      widget.date,
                      (calculMontat() * (1 + 0.2)) *
                          (1 - (widget.remise / 100)),
                      widget.commande,
                      widget.remise,
                      calculMontat());
                }
              },
            ),
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
