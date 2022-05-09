// ignore_for_file: must_be_immutable, non_constant_identifier_names

import 'package:chama_projet/inventaire/livraison/AjoutLigneliv.dart';
import 'package:chama_projet/inventaire/livraison/listLivraison.dart';

import 'package:chama_projet/services/livraison.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widget/toast.dart';
import 'Modifieroperation_liv.dart';

class UpdateLivraison extends StatefulWidget {
  String titre, id;
  List OperationList;
  String livraison, etat;
  String date;
  UpdateLivraison(
      {Key? key,
      required this.id,
      required this.titre,
      required this.OperationList,
      required this.livraison,
      required this.etat,
      required this.date})
      : super(key: key);

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
                      ),
                  // ignore: prefer_const_constructors
                  transitionDuration: Duration(seconds: 0)));
          // ignore: void_checks
          return Future.value(false);
        },
        child: Column(
          children: [
            Expanded(
                child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
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
                          Get.to(() => AjoutoperationLiv(
                                id: widget.id,
                                titre: widget.titre,
                                etat: widget.etat,
                                date: widget.date,
                                ListOperation: widget.OperationList,
                                livraison: widget.livraison,
                                page: "Livraison",
                              ));
                        },
                        icon: const Icon(
                          Icons.add,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
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
                              showToast("Veuillez entrer Numéro de ligne");
                            } else {
                              Get.to(() => ModifierOperationLiv(
                                    id: widget.id,
                                    titre: widget.titre,
                                    livraison: widget.livraison,
                                    etat: widget.etat,
                                    num: int.parse(n.text),
                                    ligneOperation: widget.OperationList,
                                    date: widget.date,
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
                              DataCell(
                                  Text(widget.OperationList[i]['Article'])),
                              DataCell(Text(
                                  widget.OperationList[i]['Colis source'])),
                              DataCell(Text(widget.OperationList[i]
                                  ['Colis de destination'])),
                              DataCell(Text(
                                  "${widget.OperationList[i]['Appartenant']}")),
                              DataCell(
                                  Text("${widget.OperationList[i]['Fait']}")),
                              DataCell(
                                  Text("${widget.OperationList[i]['Unite']}")),
                            ]),
                          ]
                        ],
                      ),
                    ),
                  ),
                ),
                Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(left: 35, top: 50),
                      child: Text(
                        "Adresse de livraison:",
                        style: TextStyle(fontSize: 15, letterSpacing: 3),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(left: 30, top: 30, right: 30),
                  child: TextFormField(
                    initialValue: widget.livraison,
                    onChanged: (value) {
                      widget.livraison = value;
                    },
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.orange, width: 1.5),
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
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 35, top: 50),
                      child: Text(
                        "État",
                        style: TextStyle(fontSize: 15, letterSpacing: 3),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 110, top: 50),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.grey, width: 1.5)),
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
              ],
            ))
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
          Livraison().updateLivraison(
              widget.id,
              "Atelier:Réception",
              widget.etat,
              DateTime.parse(widget.date),
              widget.OperationList,
              widget.livraison);
          Get.to(() => const ListLivraison());
        },
      ),
    );
  }
}
