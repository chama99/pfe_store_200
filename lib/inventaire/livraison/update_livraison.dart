// ignore_for_file: must_be_immutable, non_constant_identifier_names

import 'package:chama_projet/inventaire/livraison/AjoutLigneliv.dart';
import 'package:chama_projet/inventaire/livraison/listLivraison.dart';

import 'package:chama_projet/services/livraison.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widget/NavBottom.dart';
import '../../widget/toast.dart';
import 'Modifieroperation_liv.dart';

class UpdateLivraison extends StatefulWidget {
  String titre, id;
  List OperationList;
  String livraison, etat;
  String date;
  String emailus, nameus, url, roleus, adrus, telus, idus;

  List accesus;
  UpdateLivraison({
    Key? key,
    required this.id,
    required this.titre,
    required this.OperationList,
    required this.livraison,
    required this.etat,
    required this.date,
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
  State<UpdateLivraison> createState() => _UpdateLivraisonState();
}

class _UpdateLivraisonState extends State<UpdateLivraison> {
  final n = TextEditingController();

  List listItem3 = ["Brouillon", "En attente", "Prêt"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Livraison / ${widget.titre}",
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
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
                  pageBuilder: (a, b, c) => UpdateLivraison(
                      id: widget.id,
                      titre: widget.titre,
                      OperationList: widget.OperationList,
                      livraison: widget.livraison,
                      etat: widget.etat,
                      date: widget.date,
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
                  child: ListView(
                children: [
                  Container(
                    color: Colors.white,
                    margin: const EdgeInsets.only(top: 30),
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: Colors.orange[100],
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  Get.to(() => AjoutoperationLiv(
                                      id: widget.id,
                                      titre: widget.titre,
                                      etat: widget.etat,
                                      date: widget.date,
                                      ListOperation: widget.OperationList,
                                      livraison: widget.livraison,
                                      page: "Livraison",
                                      idus: widget.idus,
                                      url: widget.url,
                                      telus: widget.telus,
                                      adrus: widget.adrus,
                                      accesus: widget.accesus,
                                      nameus: widget.nameus,
                                      emailus: widget.emailus,
                                      roleus: widget.roleus));
                                },
                                icon: const Icon(
                                  Icons.add,
                                  color: Colors.orange,
                                ),
                              ),
                              const Text(
                                "Ajouter lignes de commande ",
                                style: TextStyle(
                                    fontSize: 15,
                                    letterSpacing: 3,
                                    color: Colors.indigo),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: Colors.orange[100],
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: IconButton(
                                      onPressed: () {
                                        if (n.text.isEmpty) {
                                          showToast(
                                              "Veuillez entrer Numéro de ligne");
                                        } else if (int.parse(n.text) >
                                            widget.OperationList.length - 1) {
                                          showToast(
                                              "le numéro de ligne n'existe pas");
                                        } else {
                                          Get.to(() => ModifierOperationLiv(
                                              id: widget.id,
                                              titre: widget.titre,
                                              livraison: widget.livraison,
                                              etat: widget.etat,
                                              num: int.parse(n.text),
                                              ligneOperation:
                                                  widget.OperationList,
                                              date: widget.date,
                                              idus: widget.idus,
                                              url: widget.url,
                                              telus: widget.telus,
                                              adrus: widget.adrus,
                                              accesus: widget.accesus,
                                              nameus: widget.nameus,
                                              emailus: widget.emailus,
                                              roleus: widget.roleus));
                                        }
                                      },
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.orange,
                                      ),
                                    ),
                                  ),
                                  const Text(
                                    "Modifier la commande Numéro :",
                                    style: TextStyle(
                                        fontSize: 14,
                                        letterSpacing: 3,
                                        color: Colors.indigo),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 15, right: 150, left: 150),
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
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SingleChildScrollView(
                              child: DataTable(
                                columns: const [
                                  DataColumn(
                                    label: Text("Numéro de ligne"),
                                  ),
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
                                      i < widget.OperationList.length;
                                      i++) ...[
                                    DataRow(cells: [
                                      DataCell(Text("$i")),
                                      DataCell(Text(
                                          widget.OperationList[i]['Article'])),
                                      DataCell(Text(widget.OperationList[i]
                                          ['Colis source'])),
                                      DataCell(Text(widget.OperationList[i]
                                          ['Colis de destination'])),
                                      DataCell(Text(
                                          "${widget.OperationList[i]['Appartenant']}")),
                                      DataCell(Text(
                                          "${widget.OperationList[i]['Fait']}")),
                                      DataCell(Text(
                                          "${widget.OperationList[i]['Unite']}")),
                                    ]),
                                  ]
                                ],
                              ),
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
                          padding: EdgeInsets.only(left: 35, top: 20),
                          child: Text(
                            "Adresse de livraison:",
                            style: TextStyle(fontSize: 15, letterSpacing: 3),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              bottom: 15, left: 20, right: 20, top: 20),
                          child: TextFormField(
                            initialValue: widget.livraison,
                            onChanged: (value) {
                              widget.livraison = value;
                            },
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.orange, width: 1.5),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.orange,
                                  width: 1.5,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey,
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
                    color: Colors.white,
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 35, top: 20),
                          child: Text(
                            "État :",
                            style: TextStyle(fontSize: 15, letterSpacing: 3),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 20, bottom: 15),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border:
                                  Border.all(color: Colors.grey, width: 1.5)),
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
                              value: widget.etat,
                              onChanged: (newValue) {
                                setState(() {
                                  widget.etat = newValue.toString();
                                });
                              },
                              items: listItem3.map((valueItem) {
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
                ],
              )),
              SizedBox(
                width: 370,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    maximumSize: const Size(double.infinity, 50),
                    primary: Color.fromARGB(255, 11, 64, 117),
                  ),
                  child: const Text(
                    "Modifier",
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    Livraison().updateLivraison(
                        widget.id,
                        "Atelier:Réception",
                        widget.etat,
                        DateTime.parse(widget.date),
                        widget.OperationList,
                        widget.livraison);
                    Get.to(() => ListLivraison(
                        idus: widget.idus,
                        url: widget.url,
                        telus: widget.telus,
                        adrus: widget.adrus,
                        accesus: widget.accesus,
                        nameus: widget.nameus,
                        emailus: widget.emailus,
                        roleus: widget.roleus));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
