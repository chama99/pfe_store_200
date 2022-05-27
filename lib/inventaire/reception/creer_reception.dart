import 'package:chama_projet/inventaire/reception/LigneOperation.dart';
import 'package:chama_projet/inventaire/reception/listReception.dart';
import 'package:chama_projet/services/reception.dart';
import 'package:chama_projet/services/ligneOperation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_azure_b2c/GUIDGenerator.dart';
import 'package:get/get.dart';

import '../../widget/NavBottom.dart';
import '../../widget/toast.dart';

class CreerReception extends StatefulWidget {
  String emailus, nameus, url, roleus, adrus, telus, idus;

  List accesus;
  CreerReception({
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
  State<CreerReception> createState() => _CreerReceptionState();
}

class _CreerReceptionState extends State<CreerReception> {
  final _formKey = GlobalKey<FormState>();
  final titre = TextEditingController();
  DateTime dataTime = DateTime.now();
  List commandeList = [];
  final String uuid = GUIDGen.generate();
  var ch = "Nouveau";
  // ignore: prefer_typing_uninitialized_variables
  var typeoperation;
  // ignore: prefer_typing_uninitialized_variables
  var etat;
  // ignore: prefer_typing_uninitialized_variables
  var operation;
  // ignore: prefer_typing_uninitialized_variables
  var reception;
  List listItem = [
    "Atelier:Livraison",
    "Atelier:Réception",
    "Atelier:Transfert interne"
  ];
  List listItem2 = ["Brouillon", "En attente", "Prêt"];
  List list = [];
  List receptionList = ["Stock1", "Stock2", "Stock3", "Stock4"];
  List livraisonList = ["kgkkgk", "klklml"];
  addList() {
    for (var i = 0; i < commandeList.length; i++) {
      list.add(commandeList[i]);
    }
  }

  List recpr = [];
  fetchDatabaseList() async {
    dynamic resultant = await CommandeOperation().getCommopList();
    dynamic resr = await Reception().getReceptionList();
    if (resultant == null) {
      // ignore: avoid_print
      print('Unable to retrieve');
    } else {
      setState(() {
        commandeList = resultant;
        recpr = resr;
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
    var numr = recpr.length;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Créer un Reception"),
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
                  pageBuilder: (a, b, c) => CreerReception(
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
                            color: Colors.white,
                            margin: const EdgeInsets.only(top: 15, bottom: 20),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(13),
                                  child: InkWell(
                                    onTap: () {
                                      Get.to(() => LigneOperation(
                                          page: "Réception",
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
                                      margin: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(40),
                                        color: Colors.orange[100],
                                      ),
                                      child: Row(
                                        children: const [
                                          Padding(
                                            padding: EdgeInsets.all(15),
                                            child: Icon(
                                              Icons.add_rounded,
                                              color: Colors.indigo,
                                            ),
                                          ),
                                          Text(
                                            "Ajouter Une Opération",
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
                                            DataCell(Text(
                                                commandeList[i]['Article'])),
                                            DataCell(Text(commandeList[i]
                                                ['Colis source'])),
                                            DataCell(Text(commandeList[i]
                                                ['Colis de destination'])),
                                            DataCell(Text(
                                                "${commandeList[i]['Appartenant']}")),
                                            DataCell(Text(
                                                "${commandeList[i]['Fait']}")),
                                            DataCell(Text(
                                                "${commandeList[i]['Unite']}")),
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
                                    "Type d'opération :",
                                    style: TextStyle(
                                        fontSize: 15, letterSpacing: 2),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                      top: 30, bottom: 15),
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
                          ),
                          Container(
                            color: Colors.white,
                            child: Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(13),
                                  child: Text(
                                    "Réception de :",
                                    style: TextStyle(
                                        fontSize: 15, letterSpacing: 2),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                      top: 20, bottom: 15),
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
                          ),
                          Container(
                            color: Colors.white,
                            margin: const EdgeInsets.only(top: 20, bottom: 20),
                            child: Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 15, top: 30),
                                  child: Text(
                                    "État :",
                                    style: TextStyle(
                                        fontSize: 15, letterSpacing: 2),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                      bottom: 15, top: 30),
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
                          ),
                          Container(
                            color: Colors.white,
                            child: Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(13),
                                  child: Text(
                                    "Date prévue :",
                                    style: TextStyle(
                                        fontSize: 15, letterSpacing: 2),
                                  ),
                                ),
                                Container(
                                    margin: const EdgeInsets.all(10),
                                    child: buildDatePicker(dataTime)),
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
                  child: const Text("Sauvegarder"),
                  onPressed: () {
                    // Validate returns true if the form is valid, otherwise false.
                    if (_formKey.currentState!.validate()) {
                      // ignore: prefer_adjacent_string_concatenation

                      addList();
                      if (operation != null) {
                        if (etat != null) {
                          Reception().addReception(
                              uuid,
                              "Reception N°${numr + 1}",
                              operation,
                              etat,
                              dataTime,
                              list,
                              reception);

                          Get.to(() => ListReception(
                              idus: widget.idus,
                              url: widget.url,
                              telus: widget.telus,
                              adrus: widget.adrus,
                              accesus: widget.accesus,
                              nameus: widget.nameus,
                              emailus: widget.emailus,
                              roleus: widget.roleus));
                        } else {
                          showToast("veuillez sélectionner etat ");
                        }
                      } else {
                        showToast("veuillez sélectionner  type d'opération");
                      }
                      CommandeOperation().deleteCommdeop();
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
