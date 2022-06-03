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
  String titre, client, etat, role, id, idus;
  int remise;
  List commande;
  double total, montant;
  String date;
  String name, email, url, adr, tel;
  List acces;
  DevisDetailler(
      {Key? key,
      required this.idus,
      required this.titre,
      required this.id,
      required this.client,
      required this.etat,
      required this.commande,
      required this.total,
      required this.remise,
      required this.montant,
      required this.date,
      required this.role,
      required this.email,
      required this.name,
      required this.acces,
      required this.url,
      required this.adr,
      required this.tel})
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 20, right: 30),
            child: InkWell(
              onTap: () {
                if (widget.etat == "Devis") {
                  Get.to(() => UpdateDevis(
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
      bottomNavigationBar: ElevatedButton(
        style: ElevatedButton.styleFrom(
          maximumSize: const Size(double.infinity, 50),
          primary: Color.fromARGB(255, 11, 64, 117),
        ),
        child: const Text("Convertir  au format PDF",
            style: TextStyle(fontSize: 20)),
        onPressed: onSubmit,
      ),
      body: ListView(
        children: [
          Container(
            color: Colors.grey[200],
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      Text(
                        widget.titre,
                        style: TextStyle(
                          fontSize: 20,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 1
                            ..color = Colors.black,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 50),
                        child: Text("Sète,le",
                            style: TextStyle(
                              fontSize: 20,
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 50),
                        child: Text(
                          widget.date,
                          style: TextStyle(
                            fontSize: 20,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 1
                              ..color = Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 160, top: 40),
                      child: Text(
                        "Nom du Client:",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, top: 40),
                      child: Text(
                        widget.client,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 160, top: 10),
                      child: Text(
                        "État:",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, top: 10),
                      child: Text(
                        widget.etat,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      child: DataTable(
                        dataRowColor:
                            MaterialStateProperty.resolveWith(_getDataRowColor),
                        sortAscending: isAscending,
                        sortColumnIndex: sortColumnIndex,
                        columns: const [
                          DataColumn(
                            label: Text(
                              "réf",
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "Article",
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "Description",
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "Unité",
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "Quantité",
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "Prix unitaire",
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "Taxes",
                            ),
                          ),
                          DataColumn(
                            label: Text("Sous-total"),
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
                Padding(
                  padding: const EdgeInsets.only(top: 60, left: 100),
                  child: Table(
                      defaultColumnWidth: const FixedColumnWidth(120.0),
                      border: TableBorder.all(
                          style: BorderStyle.solid,
                          width: 0,
                          color: Colors.grey),
                      children: [
                        TableRow(children: [
                          Column(children: const [
                            Text('Montant', style: TextStyle(fontSize: 15))
                          ]),
                          Container(
                              color: Colors.orange[100],
                              child: Column(
                                  children: [Text('${widget.montant}£')])),
                        ]),
                        TableRow(children: [
                          Column(children: const [
                            Text('Remise ', style: TextStyle(fontSize: 15))
                          ]),
                          Container(
                              color: Colors.orange[100],
                              child: Column(
                                  children: [Text('${widget.remise}%')])),
                        ]),
                        TableRow(children: [
                          Column(children: const [
                            Text('Taxes', style: TextStyle(fontSize: 15))
                          ]),
                          Container(
                              color: Colors.orange[100],
                              child: Column(children: const [Text('20%')])),
                        ]),
                        TableRow(children: [
                          Column(children: const [
                            Text('Total', style: TextStyle(fontSize: 15))
                          ]),
                          Container(
                              color: Colors.orange[100],
                              child:
                                  Column(children: [Text('${widget.total}£')])),
                        ]),
                      ]),
                ),
                Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(30),
                      child: Text(
                        "Signature:",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 0, left: 20, right: 20),
                      child: SfSignaturePad(
                        key: keySignaturePad,
                        backgroundColor:
                            const Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
      montant: widget.montant,
      remise: widget.remise,
      nom: widget.name,
      email: widget.email,
      commnd: widget.commande,
      titre: widget.titre,
      client: widget.client,
      date1: widget.date,
      total: widget.total,
    );
    Navigator.of(context).pop();
    await OpenFile.open(file.path);
  }

  Color _getDataRowColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };

    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return const Color.fromRGBO(255, 224, 178, 1);
  }
}
