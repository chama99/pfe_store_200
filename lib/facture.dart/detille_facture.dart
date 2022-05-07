// ignore_for_file: must_be_immutable

import 'dart:ui';

import 'package:chama_projet/facture.dart/updateFacture.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:open_file/open_file.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

import '../services/pdf_api.dart';
import '../widget/toast.dart';

class DetailFacture extends StatefulWidget {
  String id, titre, client, etat, date1, page;

  List listfact;
  double montant;
  int res;
  double total;
  DetailFacture(
      {Key? key,
      required this.id,
      required this.titre,
      required this.client,
      required this.etat,
      required this.date1,
      required this.total,
      required this.listfact,
      required this.montant,
      required this.res,
      required this.page})
      : super(key: key);

  @override
  State<DetailFacture> createState() => _DetailFactureState();
}

class _DetailFactureState extends State<DetailFacture> {
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
                if (widget.etat == "Brouillon" || widget.etat == "Avoir") {
                  Get.to(() => UpdateFacture(
                        id: widget.id,
                        titre: widget.titre,
                        client: widget.client,
                        etat: widget.etat,
                        total: widget.total,
                        listfact: widget.listfact,
                        montant: widget.montant,
                        date1: widget.date1,
                        res: widget.res,
                        page: widget.page,
                      ));
                } else {
                  showToast("Ne peut pas modifier cette facture");
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
                    "Lignes de facture :",
                    style: TextStyle(fontSize: 20, letterSpacing: 3),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: SingleChildScrollView(
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
                          for (var i = 0; i < widget.listfact.length; i++) ...[
                            DataRow(cells: [
                              DataCell(Text("${widget.listfact[i]['réf']}")),
                              DataCell(Text(widget.listfact[i]['Article'])),
                              DataCell(Text(widget.listfact[i]['Description'])),
                              DataCell(Text("${widget.listfact[i]['Unite']}")),
                              DataCell(
                                  Text("${widget.listfact[i]['Quantite']}")),
                              DataCell(Text("${widget.listfact[i]['prix']}")),
                              const DataCell(Text("20%")),
                              DataCell(
                                  Text("${widget.listfact[i]["sous-total"]}")),
                            ]),
                          ]
                        ],
                      ),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
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
                              color: Colors.indigo, fontSize: 25),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    const Text(
                      "Signature:",
                      style: TextStyle(fontSize: 20, letterSpacing: 3),
                    ),
                    SfSignaturePad(
                      key: keySignaturePad,
                      backgroundColor: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ],
                ),
              ],
            ),
          )
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

  Future onSubmit() async {
    showDialog(
        context: context,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    final image = await keySignaturePad.currentState?.toImage();
    final imageSignature = await image!.toByteData(format: ImageByteFormat.png);
    final file = await PdfApi.generatePDF(
      imageSignature: imageSignature!,
      commnd: widget.listfact,
      titre: widget.titre,
      client: widget.client,
      date1: widget.date1,
      montant: widget.montant,
      remise: widget.res,
      total: widget.total,
    );
    Navigator.of(context).pop();
    await OpenFile.open(file.path);
  }
}
