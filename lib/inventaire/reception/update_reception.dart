// ignore_for_file: must_be_immutable, non_constant_identifier_names

import 'package:chama_projet/inventaire/reception/AjoutOperation.dart';
import 'package:chama_projet/inventaire/reception/listReception.dart';
import 'package:chama_projet/services/reception.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widget/toast.dart';
import 'ModifierLigneOperation.dart';

class UpdateReception extends StatefulWidget {
  String titre;
  List OperationList;
  String reception, etat;
  String date;
  UpdateReception(
      {Key? key,
      required this.titre,
      required this.OperationList,
      required this.reception,
      required this.etat,
      required this.date})
      : super(key: key);

  @override
  State<UpdateReception> createState() => _UpdateReceptionState();
}

class _UpdateReceptionState extends State<UpdateReception> {
  final n = TextEditingController();
  List receptionList = ["Stock1", "Stock2", "Stock3", "Stock4"];
  List listItem2 = ["Brouillon", "En attente", "Prêt"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Reception / ${widget.titre}",
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
                  pageBuilder: (a, b, c) => UpdateReception(
                        titre: widget.titre,
                        OperationList: widget.OperationList,
                        reception: widget.reception,
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
                          Get.to(() => Ajoutoperation(
                              titre: widget.titre,
                              etat: widget.etat,
                              date: widget.date,
                              ListOperation: widget.OperationList,
                              reception: widget.reception));
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
                              Get.to(() => ModifierOperation(
                                    titre: widget.titre,
                                    reception: widget.reception,
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
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 35, top: 50),
                      child: Text(
                        "Réception de",
                        style: TextStyle(fontSize: 15, letterSpacing: 3),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 50),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.grey, width: 1.5)),
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
                          value: widget.reception,
                          onChanged: (newValue) {
                            setState(() {
                              widget.reception = newValue.toString();
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
          Reception().updateReception(
              widget.titre,
              "Atelier:Réception",
              widget.etat,
              DateTime.parse(widget.date),
              widget.OperationList,
              widget.reception);
          Get.to(() => const ListReception());
        },
      ),
    );
  }
}
