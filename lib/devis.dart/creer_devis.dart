// ignore: avoid_web_libraries_in_flutter

// ignore_for_file: must_be_immutable

import 'dart:async';

import 'package:chama_projet/services/autofacture.dart';
import 'package:chama_projet/services/commande.dart';

import 'package:chama_projet/services/devis.dart';
import 'package:chama_projet/widget/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_azure_b2c/GUIDGenerator.dart';

import 'package:get/get.dart';

import '../services/facture.dart';
import '../widget/NavBottom.dart';
import 'LigneDECommande.dart';
import 'listDevis.dart';

class CreeDevisPage extends StatefulWidget {
  String role;
  String name, email, url, idus, tel, adr;
  List acces;
  CreeDevisPage(
      {Key? key,
      required this.idus,
      required this.role,
      required this.email,
      required this.name,
      required this.acces,
      required this.url,
      required this.adr,
      required this.tel})
      : super(key: key);

  @override
  _CreeDevisPageState createState() => _CreeDevisPageState();
}

class _CreeDevisPageState extends State<CreeDevisPage> {
  // ignore: non_constant_identifier_names
  final Contolleremise = TextEditingController();
  DateTime dataTime = DateTime.now();

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
  late int remisee = 0;
  // ignore: prefer_final_fields
  StreamController<String> _streamController = StreamController();
  final String uuid = GUIDGen.generate();
  bool test = false;
  final CollectionReference contactsCollection =
      FirebaseFirestore.instance.collection('clients');
  Future getData() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await contactsCollection.get();

    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

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
  List listTotal = [];
  List list = [];
  List devis = [];
  List fact = [];
  List facta = [];
  fetchDatabaseList() async {
    dynamic resultant2 = await Commande().getCommandesList();
    dynamic resd = await Devis().getDevisList();
    dynamic resf = await Facture().getFacturesList();
    dynamic resfa = await AutoFacture().getFacturesList();

    setState(() {
      commandeList = resultant2;
      devis = resd;
      fact = resf;
      facta = resfa;
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
    var l = devis.length;
    var lf = fact.length + facta.length;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Créer Un Devis"),
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
        color: Colors.orange,
        onRefresh: () {
          Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                  // ignore: prefer_const_constructors
                  pageBuilder: (a, b, c) => CreeDevisPage(
                        idus: widget.idus,
                        role: widget.role,
                        acces: widget.acces,
                        name: widget.name,
                        url: widget.url,
                        email: widget.email,
                        tel: widget.tel,
                        adr: widget.adr,
                      ),
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
                                  padding: const EdgeInsets.all(0),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LigneCommande(
                                                    idus: widget.idus,
                                                    role: widget.role,
                                                    email: widget.email,
                                                    acces: widget.acces,
                                                    name: widget.name,
                                                    url: widget.url,
                                                    tel: widget.tel,
                                                    adr: widget.adr,
                                                  )));
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
                                              Icons.add_rounded,
                                              color: Colors.indigo,
                                            ),
                                          ),
                                          Text(
                                            "Ajouter Lignes de la commande",
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
                                          label: Text("Unité"),
                                        ),
                                        DataColumn(
                                          label: Text("Quantité"),
                                        ),
                                        DataColumn(
                                          label: Text("Prix unitaire"),
                                        ),
                                        DataColumn(
                                          label: Text("Taxes"),
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
                                                commandeList[i]['Article'])),
                                            DataCell(Text(commandeList[i]
                                                ['Description'])),
                                            DataCell(Text(
                                                "${commandeList[i]['Unite']}")),
                                            DataCell(Text(
                                                "${commandeList[i]['Quantite']}")),
                                            DataCell(Text(
                                                "${commandeList[i]['prix']}")),
                                            const DataCell(Text("${0.2}")),
                                            DataCell(Text(
                                                "${commandeList[i]["sous-total"]}")),
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
                                        fontSize: 15, letterSpacing: 2),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 38, bottom: 15),
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
                                  padding: EdgeInsets.all(20),
                                  child: Text(
                                    "État :",
                                    style: TextStyle(
                                        fontSize: 15, letterSpacing: 2),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 20, bottom: 15),
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
                                  padding: EdgeInsets.all(20),
                                  child: Text(
                                    "Date de devis :",
                                    style: TextStyle(
                                        fontSize: 15, letterSpacing: 2),
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
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(
                                          top: 30,
                                          right: 13,
                                          left: 13,
                                          bottom: 40),
                                      child: const Text(
                                        "Remise :",
                                        style: TextStyle(
                                            fontSize: 15, letterSpacing: 2),
                                      ),
                                    ),
                                    Flexible(
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            left: 45, right: 65),
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
                                        ),
                                      ),
                                    )
                                  ],
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
                                              .add("${Contolleremise.text}%");
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
                                  width: 350,
                                  height: 200,
                                  margin: const EdgeInsets.only(
                                      left: 10, top: 10, bottom: 10),
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
                                          "Total:  ${(calculMontat() * (1 + 0.2)) * (1 - (remisee / 100))}",
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
                      SizedBox(
                        width: 370,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            maximumSize: const Size(double.infinity, 50),
                            primary: Color.fromARGB(255, 11, 64, 117),
                          ),
                          child: const Text("Sauvegarder"),
                          onPressed: () {
                            // Validate returns true if the form is valid, otherwise false.
                            if (_formKey.currentState!.validate()) {
                              if (Contolleremise.text.isEmpty == false) {
                                if (client != null) {
                                  if (etat != null) {
                                    addList();
                                    if (etat == "Bon de commande") {
                                      AutoFacture().addFacture(
                                          uuid,
                                          "Facture N°${lf + 1}",
                                          "Devis N°${l + 1}",
                                          client,
                                          "Brouillon",
                                          dataTime,
                                          (calculMontat() * (1 + 0.2)) *
                                              (1 - (remisee / 100)),
                                          list,
                                          remisee,
                                          calculMontat());
                                    }
                                    Devis().addDevis(
                                        uuid,
                                        "Devis N°${l + 1}",
                                        client,
                                        etat,
                                        (calculMontat() * (1 + 0.2)) *
                                            (1 - (remisee / 100)),
                                        list,
                                        remisee,
                                        calculMontat(),
                                        dataTime);

                                    Get.to(() => ListDevis(
                                          idus: widget.idus,
                                          role: widget.role,
                                          email: widget.email,
                                          acces: widget.acces,
                                          name: widget.name,
                                          url: widget.url,
                                          tel: widget.tel,
                                          adr: widget.adr,
                                        ));
                                  } else {
                                    showToast("veuillez sélectionner état");
                                  }
                                } else {
                                  showToast("veuillez sélectionner client");
                                }
                              } else {
                                showToast("Veuillez entrer remise");
                              }

                              Commande().deleteCommande();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )),
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
