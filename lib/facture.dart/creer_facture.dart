// ignore_for_file: unused_import, deprecated_member_use

// ignore: avoid_web_libraries_in_flutter

import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:chama_projet/facture.dart/LigneFact.dart';
import 'package:chama_projet/facture.dart/listfact.dart';
import 'package:chama_projet/services/commande.dart';
import 'package:chama_projet/services/contact.dart';
import 'package:chama_projet/services/devis.dart';
import 'package:chama_projet/services/facture.dart';
import 'package:chama_projet/services/lignefact.dart';
import 'package:chama_projet/widget/toast.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_azure_b2c/GUIDGenerator.dart';
import 'package:flutter_multiselect/flutter_multiselect.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import '../services/autofacture.dart';
import '../services/employe.dart';
import '../widget/InputDeco_design.dart';
import '../widget/NavBottom.dart';

class CreeFacturePage extends StatefulWidget {
  String emailus, nameus, url, roleus, adrus, telus, idus;

  List accesus;
  CreeFacturePage({
    Key? key,
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
  _CreeFacturePageState createState() => _CreeFacturePageState();
}

class _CreeFacturePageState extends State<CreeFacturePage> {
  DateTime dataTime = DateTime.now();

  final String uuid = GUIDGen.generate();

  // ignore: non_constant_identifier_names
  final Contolleremise = TextEditingController();
  // ignore: non_constant_identifier_names
  final Contollertitre = TextEditingController();

  int? sortColumnIndex;
  bool isAscending = false;
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  XFile? imageFile;
  final CollectionReference contactsCollection =
      FirebaseFirestore.instance.collection('clients');
  Future getData() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await contactsCollection.get();

    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  final _formKey = GlobalKey<FormState>();
  final titre = TextEditingController();
  final adresse = TextEditingController();

  // ignore: prefer_typing_uninitialized_variables
  var client;
  // ignore: prefer_typing_uninitialized_variables
  var etat;
  List listItem = ["Brouillon", "Payée", "Avoir"];

  var taxe = 0.00;
  var total = 0.00;
  // ignore: prefer_typing_uninitialized_variables
  int remisee = 0;
  // ignore: prefer_final_fields
  StreamController<String> _streamController = StreamController();

  bool test = false;
  List clients = [];
  @override
  void initState() {
    super.initState();
    fetchDatabaseList();
    _streamController.stream.listen((item) {
      setState(() {
        var ch = item.substring(0, item.indexOf("%"));
        // ignore: unnecessary_cast
        int r = int.parse(ch);

        // ignore: unnecessary_cast
        remisee = r;
      });
    });
    getData().then((client) {
      for (int i = 0; i < client.length; i++) {
        clients.add(client[i]["name"]);
      }
    });
  }

  List userContactList = [];
  List commandeList = [];

  List list = [];
  List fact = [];
  List facto = [];
  fetchDatabaseList() async {
    dynamic resultant2 = await CommandeFact().getCommList();
    dynamic resultf = await Facture().getFacturesList();
    dynamic resfa = await AutoFacture().getFacturesList();

    setState(() {
      commandeList = resultant2;
      fact = resultf;
      facto = resfa;
    });
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
    var lf = fact.length + facto.length;
    final number = Random().nextInt(20);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Créer Un Facture"),
        backgroundColor: Colors.orange,
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
      body: RefreshIndicator(
        onRefresh: () {
          Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                  // ignore: prefer_const_constructors
                  pageBuilder: (a, b, c) => CreeFacturePage(
                      idus: widget.idus,
                      url: widget.url,
                      telus: widget.telus,
                      adrus: widget.adrus,
                      accesus: widget.accesus,
                      nameus: widget.nameus,
                      emailus: widget.emailus,
                      roleus: widget.roleus),
                  // ignore: prefer_const_constructors
                  transitionDuration: Duration(seconds: 0)));
          // ignore: void_checks
          return Future.value(false);
        },
        child: Container(
          color: Colors.grey[200],
          child: Column(
            children: [
              Expanded(
                  child: Form(
                key: _formKey,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                  child: Column(
                    children: [
                      Expanded(
                          child: ListView(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 10, bottom: 20),
                            color: Colors.white,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(13),
                                  child: InkWell(
                                    onTap: () {
                                      Get.to(() => LigneFacture(
                                          titre: Contollertitre.text,
                                          idus: widget.idus,
                                          url: widget.url,
                                          telus: widget.telus,
                                          adrus: widget.adrus,
                                          accesus: widget.accesus,
                                          nameus: widget.nameus,
                                          emailus: widget.emailus,
                                          roleus: widget.roleus));
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(40),
                                        color: Colors.orange[100],
                                      ),
                                      child: Row(
                                        children: const [
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Icon(
                                              Icons.add_outlined,
                                              color: Colors.indigo,
                                            ),
                                          ),
                                          Text(
                                            "Ajouter Lignes de facture",
                                            style: TextStyle(
                                                fontSize: 15,
                                                letterSpacing: 3,
                                                color: Colors.indigo),
                                            textAlign: TextAlign.left,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: SingleChildScrollView(
                                    child: DataTable(
                                      sortAscending: isAscending,
                                      sortColumnIndex: sortColumnIndex,
                                      columns: const [
                                        DataColumn(
                                          label: Text("réf"),
                                        ),
                                        DataColumn(
                                          label: Text("Article"),
                                        ),
                                        DataColumn(
                                          label: Text("Description"),
                                        ),
                                        DataColumn(
                                          label: Text(" Unité"),
                                        ),
                                        DataColumn(
                                          label: Text("Quantité"),
                                        ),
                                        DataColumn(
                                          label: Text("Prix Unitaire"),
                                        ),
                                        DataColumn(
                                          label: Text("TVA"),
                                        ),
                                        DataColumn(
                                          label: Text("Sous-total"),
                                        )
                                      ],
                                      rows: [
                                        for (var i = 0;
                                            i < commandeList.length;
                                            i++) ...[
                                          DataRow(cells: [
                                            DataCell(Text(
                                                "${commandeList[i]['réf']}")),
                                            DataCell(Text(
                                                "${commandeList[i]['Article']}")),
                                            DataCell(Text(commandeList[i]
                                                ['Description'])),
                                            DataCell(
                                                Text(commandeList[i]['Unite'])),
                                            DataCell(Text(
                                                "${commandeList[i]['Quantite']}")),
                                            DataCell(Text(
                                                "${commandeList[i]['prix']}")),
                                            const DataCell(Text("${0.2}")),
                                            DataCell(Text(
                                                "${commandeList[i]['Quantite'] * commandeList[i]['prix']}")),
                                          ]),
                                        ]
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            color: Colors.white,
                            child: Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(13),
                                  child: Text(
                                    "Client :",
                                    style: TextStyle(
                                        fontSize: 15, letterSpacing: 3),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 0, bottom: 15),
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
                                      items: clients.map((valueItem) {
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
                          ),
                          Container(
                            color: Colors.white,
                            margin: const EdgeInsets.only(top: 20, bottom: 20),
                            child: Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(13),
                                  child: Text(
                                    "État :",
                                    style: TextStyle(
                                        fontSize: 15, letterSpacing: 3),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left: 0),
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
                          ),
                          Container(
                            color: Colors.white,
                            child: Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(13),
                                  child: Text(
                                    "Date de facturations :",
                                    style: TextStyle(
                                        fontSize: 15, letterSpacing: 3),
                                  ),
                                ),
                                Container(child: buildDatePicker(dataTime)),
                              ],
                            ),
                          ),
                          Container(
                            color: Colors.white,
                            margin: const EdgeInsets.only(top: 20, bottom: 20),
                            child: Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(
                                      top: 40, bottom: 40),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(
                                            top: 30,
                                            right: 13,
                                            left: 13,
                                            bottom: 10),
                                        child: const Text(
                                          "Ajouter une remise :",
                                          style: TextStyle(
                                              fontSize: 15, letterSpacing: 2),
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
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                borderSide: const BorderSide(
                                                    color: Colors.orange,
                                                    width: 1.5),
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                borderSide: const BorderSide(
                                                  color: Colors.orange,
                                                  width: 1.5,
                                                ),
                                              ),
                                            ),
                                            validator: (value) {
                                              if (!RegExp("%")
                                                  .hasMatch(value!)) {
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        // Validate returns true if the form is valid, otherwise false.
                                        if (_formKey.currentState!.validate()) {
                                          _streamController
                                              .add(Contolleremise.text);
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
                              ],
                            ),
                          ),
                          Container(
                            color: Colors.white,
                            child: Row(
                              children: [
                                Container(
                                  margin:
                                      const EdgeInsets.only(top: 10, left: 10),
                                  width: 365,
                                  height: 200,
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
                                          "Montant HT: ${calculMontat()}",
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "Remise: $remisee",
                                            style:
                                                const TextStyle(fontSize: 20),
                                          ),
                                        ),
                                        const Divider(
                                          color: Colors.black,
                                        ),
                                        Text(
                                          "Total: ${(calculMontat() * (1 + 0.2)) * (1 - (remisee / 100))}",
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
              SizedBox(
                width: 370,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    maximumSize: const Size(double.infinity, 50),
                    primary: Color.fromARGB(255, 11, 64, 117),
                  ),
                  child: const Text("Sauvgarder"),
                  onPressed: () {
                    // Validate returns true if the form is valid, otherwise false.
                    if (_formKey.currentState!.validate()) {
                      // ignore: prefer_adjacent_string_concatenation
                      ch = "F" + "$number";
                      addList();
                      if (client != null) {
                        if (etat != null) {
                          Facture().addFacture(
                              uuid,
                              "Facture N° ${lf + 1}",
                              client,
                              etat,
                              dataTime,
                              (calculMontat() * (1 + 0.2)) *
                                  (1 - (remisee / 100)),
                              list,
                              remisee,
                              calculMontat());
                          CommandeFact().deleteCommde();
                          Get.to(() => ListFacture(
                              idus: widget.idus,
                              url: widget.url,
                              telus: widget.telus,
                              adrus: widget.adrus,
                              accesus: widget.accesus,
                              nameus: widget.nameus,
                              emailus: widget.emailus,
                              roleus: widget.roleus));
                        } else {
                          showToast("veuillez sélectionner état ");
                        }
                      } else {
                        showToast("veuillez sélectionner client ");
                      }
                      CommandeFact().deleteCommde();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
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
