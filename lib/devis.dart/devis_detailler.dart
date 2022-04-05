// ignore_for_file: must_be_immutable

import 'package:chama_projet/devis.dart/updateDevis.dart';
import 'package:chama_projet/widget/toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DevisDetailler extends StatefulWidget {
  String titre, client, etat;
  double remise;
  List commande;
  double total, montant;
  DevisDetailler(
      {Key? key,
      required this.titre,
      required this.client,
      required this.etat,
      required this.commande,
      required this.total,
      required this.remise,
      required this.montant})
      : super(key: key);

  @override
  State<DevisDetailler> createState() => _DevisDetaillerState();
}

class _DevisDetaillerState extends State<DevisDetailler> {
  int? sortColumnIndex;
  bool isAscending = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.titre),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 20, right: 30),
            child: InkWell(
              onTap: () {
                if (widget.etat == "Devis") {
                  Get.to(() => UpdateDevis(
                        titre: widget.titre,
                        client: widget.client,
                        etat: widget.etat,
                        commande: widget.commande,
                        remise: widget.remise,
                        total: widget.total,
                        montant: widget.montant,
                      ));
                } else {
                  showToast("Ne peut pas modifier ce devis");
                }
              },
              child: Text(
                "Modifier".toUpperCase(),
                style: const TextStyle(
                    fontSize: 15, color: Colors.white, letterSpacing: 3),
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ],
        backgroundColor: Colors.orange,
      ),
      body: Container(
          width: 500,
          height: 800,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
            color: Color.fromARGB(255, 248, 243, 243),
          ),
          margin: const EdgeInsets.all(10),
          child: Container(
            margin: const EdgeInsets.only(top: 30, left: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 8, top: 20),
                      child: Text(
                        "Client:",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, top: 20),
                      child: Text(
                        widget.client,
                        style:
                            const TextStyle(color: Colors.indigo, fontSize: 25),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 8, top: 30),
                      child: Text(
                        "État:",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, top: 30),
                      child: Text(
                        widget.etat,
                        style:
                            const TextStyle(color: Colors.indigo, fontSize: 25),
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Text(
                    "Lignes de la commande :",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      child: DataTable(
                        sortAscending: isAscending,
                        sortColumnIndex: sortColumnIndex,
                        columns: [
                          DataColumn(
                            label: const Text(
                              "Numéro de ligne",
                            ),
                            onSort: onSort,
                          ),
                          DataColumn(
                            label: const Text(
                              "réf",
                            ),
                            onSort: onSort,
                          ),
                          DataColumn(
                            label: const Text(
                              "Article",
                            ),
                            onSort: onSort,
                          ),
                          DataColumn(
                            label: const Text(
                              "Description",
                            ),
                            onSort: onSort,
                          ),
                          DataColumn(
                            label: const Text(
                              "Unité",
                            ),
                            onSort: onSort,
                          ),
                          DataColumn(
                            label: const Text(
                              "Quantité",
                            ),
                            onSort: onSort,
                          ),
                          DataColumn(
                            label: const Text(
                              "Prix unitaire",
                            ),
                            onSort: onSort,
                          ),
                          DataColumn(
                            label: const Text(
                              "Taxes",
                            ),
                            onSort: onSort,
                          ),
                          DataColumn(
                            label: const Text("Sous-total"),
                            onSort: onSort,
                          )
                        ],
                        rows: [
                          for (var i = 0; i < widget.commande.length; i++) ...[
                            DataRow(cells: [
                              DataCell(Text("$i")),
                              DataCell(Text(widget.commande[i]['réf'])),
                              DataCell(Text(widget.commande[i]['Article'])),
                              DataCell(Text(widget.commande[i]['Description'])),
                              DataCell(Text("${widget.commande[i]['Unite']}")),
                              DataCell(
                                  Text("${widget.commande[i]['Quantite']}")),
                              DataCell(Text("${widget.commande[i]['prix']}")),
                              DataCell(Text("${widget.commande[i]['taxe']}")),
                              DataCell(
                                  Text("${widget.commande[i]["sous-total"]}")),
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
                      padding: EdgeInsets.only(left: 8, top: 30),
                      child: Text(
                        "Total =",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, top: 30),
                      child: Text(
                        "${widget.total}",
                        style:
                            const TextStyle(color: Colors.indigo, fontSize: 25),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }

  void onSort(int columnIndex, bool ascending) {
    setState(() {
      sortColumnIndex = columnIndex;
      isAscending = ascending;
    });
  }
}
