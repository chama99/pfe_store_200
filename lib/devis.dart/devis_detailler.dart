// ignore_for_file: must_be_immutable

import 'dart:ui';

import 'package:chama_projet/devis.dart/updateDevis.dart';
import 'package:chama_projet/widget/toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

import '../services/pdf_devis.dart';

class DevisDetailler extends StatefulWidget {
  String titre, client, etat, role;
  double remise;
  List commande;
  double total, montant;
  String date;
  DevisDetailler(
      {Key? key,
      required this.titre,
      required this.client,
      required this.etat,
      required this.commande,
      required this.total,
      required this.remise,
      required this.montant,
      required this.date,
      required this.role})
      : super(key: key);

  @override
  State<DevisDetailler> createState() => _DevisDetaillerState();
}

class _DevisDetaillerState extends State<DevisDetailler> {
  int? sortColumnIndex;
  bool isAscending = false;
  final keySignaturePad = GlobalKey<SfSignaturePadState>();
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
                if (widget.etat == "Devis" && widget.role == "Admin") {
                  Get.to(() => UpdateDevis(
                        titre: widget.titre,
                        client: widget.client,
                        etat: widget.etat,
                        commande: widget.commande,
                        remise: widget.remise,
                        total: widget.total,
                        montant: widget.montant,
                        role: widget.role,
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
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 30, left: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 8, top: 20),
                      child: Text(
                        "Client:",
                        style: TextStyle(fontSize: 20, letterSpacing: 3),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, top: 20),
                      child: Text(
                        widget.client,
                        style: const TextStyle(
                            color: Colors.indigo,
                            fontSize: 25,
                            letterSpacing: 3),
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
                        style: TextStyle(fontSize: 20, letterSpacing: 3),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, top: 30),
                      child: Text(
                        widget.etat,
                        style: const TextStyle(
                            color: Colors.indigo,
                            fontSize: 25,
                            letterSpacing: 3),
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Text(
                    "Lignes de la commande :",
                    style: TextStyle(fontSize: 20, letterSpacing: 3),
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
                              DataCell(Text("${widget.commande[i]['réf']}")),
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
                        style: TextStyle(fontSize: 20, letterSpacing: 3),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, top: 30),
                      child: Text(
                        "${widget.total}£",
                        style: const TextStyle(
                            color: Colors.indigo,
                            fontSize: 25,
                            letterSpacing: 3),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      "Signature:",
                      style: TextStyle(fontSize: 20, letterSpacing: 3),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: SfSignaturePad(
                        key: keySignaturePad,
                        backgroundColor: Colors.yellow[100],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: ElevatedButton(
        style: ElevatedButton.styleFrom(
          maximumSize: const Size(double.infinity, 50),
          primary: Colors.indigo,
        ),
        child: const Text("Convertir  au format PDF"),
        onPressed: onSubmit,
      ),
    );
  }

  void onSort(int columnIndex, bool ascending) {
    setState(() {
      sortColumnIndex = columnIndex;
      isAscending = ascending;
    });
  }

  Future onSubmit() async {
    showDialog(
        context: context,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    final image = await keySignaturePad.currentState?.toImage();
    final imageSignature = await image!.toByteData(format: ImageByteFormat.png);
    final file = await PdDevis.generatePDF(
      imageSignature: imageSignature!,
      commnd: widget.commande,
      titre: widget.titre,
      client: widget.client,
      date1: widget.date,
      total: widget.total,
    );
    Navigator.of(context).pop();
    await OpenFile.open(file.path);
  }
}
