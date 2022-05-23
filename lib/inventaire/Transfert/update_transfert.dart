// ignore_for_file: must_be_immutable, non_constant_identifier_names

import 'package:chama_projet/inventaire/Transfert/AjoutLigneTran.dart';
import 'package:chama_projet/inventaire/Transfert/ModifieroperationTrans.dart';
import 'package:chama_projet/inventaire/Transfert/listTransfert.dart';

import 'package:chama_projet/services/transfert.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widget/toast.dart';

class UpdateTransfert extends StatefulWidget {
  String titre, id;
  List OperationList;
  String transf, etat;
  String date;
  UpdateTransfert(
      {Key? key,
      required this.id,
      required this.titre,
      required this.OperationList,
      required this.transf,
      required this.etat,
      required this.date})
      : super(key: key);

  @override
  State<UpdateTransfert> createState() => _UpdateTransfertState();
}

class _UpdateTransfertState extends State<UpdateTransfert> {
  final n = TextEditingController();

  List listItem3 = ["Brouillon", "En attente", "Prêt"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Transfert / ${widget.titre}",
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
                  pageBuilder: (a, b, c) => UpdateTransfert(
                        id: widget.id,
                        titre: widget.titre,
                        OperationList: widget.OperationList,
                        transf: widget.transf,
                        etat: widget.etat,
                        date: widget.date,
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
                                  Get.to(() => AjoutoperationTran(
                                        id: widget.id,
                                        titre: widget.titre,
                                        etat: widget.etat,
                                        date: widget.date,
                                        ListOperation: widget.OperationList,
                                        transf: widget.transf,
                                        page: "Transfert",
                                      ));
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
                        Column(
                          children: [
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
                                            } else {
                                              Get.to(() =>
                                                  ModifierOperationTran(
                                                      id: widget.id,
                                                      titre: widget.titre,
                                                      transf: widget.transf,
                                                      etat: widget.etat,
                                                      num: int.parse(n.text),
                                                      ligneOperation:
                                                          widget.OperationList,
                                                      date: widget.date));
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
                                            fontSize: 15,
                                            letterSpacing: 3,
                                            color: Colors.indigo),
                                        textAlign: TextAlign.left,
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 150, right: 150, bottom: 15),
                                    child: TextFormField(
                                      controller: n,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide: const BorderSide(
                                              color: Colors.orange, width: 1.5),
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
                                ],
                              ),
                            ),
                          ],
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
                            "Transfert à:",
                            style: TextStyle(fontSize: 15, letterSpacing: 3),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 30, top: 20, right: 30, bottom: 15),
                          child: TextFormField(
                            initialValue: widget.transf,
                            onChanged: (value) {
                              widget.transf = value;
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
              ))
            ],
          ),
        ),
      ),
      bottomNavigationBar: ElevatedButton(
        style: ElevatedButton.styleFrom(
          maximumSize: const Size(double.infinity, 50),
          primary: Colors.indigo,
        ),
        child: const Text("Modifier", style: TextStyle(fontSize: 20)),
        onPressed: () {
          Transfert().updateTransfert(
              widget.id,
              "Atelier:Réception",
              widget.etat,
              DateTime.parse(widget.date),
              widget.OperationList,
              widget.transf);
          Get.to(() => const ListTransfert());
        },
      ),
    );
  }
}
