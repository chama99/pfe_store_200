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
  String emailus, nameus, url, roleus, adrus, telus, idus;

  List accesus;
  DetailFacture({
    Key? key,
    required this.id,
    required this.titre,
    required this.client,
    required this.etat,
    required this.date1,
    required this.total,
    required this.listfact,
    required this.montant,
    required this.res,
    required this.page,
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
                      tab: widget.listfact,
                      etat: widget.etat,
                      res: widget.res,
                      client: widget.client,
                      page: widget.page,
                      total: widget.total,
                      montant: widget.montant,
                      date1: widget.date1,
                      idus: widget.idus,
                      url: widget.url,
                      telus: widget.telus,
                      adrus: widget.adrus,
                      accesus: widget.accesus,
                      nameus: widget.nameus,
                      emailus: widget.emailus,
                      roleus: widget.roleus));
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
            color: Colors.grey[200],
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
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
                          padding: const EdgeInsets.only(left: 33),
                          child: Text(
                            widget.date1,
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
                  padding: const EdgeInsets.only(top: 30),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      child: DataTable(
                        dataRowColor:
                            MaterialStateProperty.resolveWith(_getDataRowColor),
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
                              child:
                                  Column(children: [Text('${widget.res}%')])),
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
          )
        ],
      ),
      bottomNavigationBar: ElevatedButton(
        style: ElevatedButton.styleFrom(
          maximumSize: const Size(double.infinity, 50),
          primary: Colors.indigo,
        ),
        child: const Text(
          "Convertir  au format PDF",
          style: TextStyle(fontSize: 20),
        ),
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
