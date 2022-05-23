// ignore_for_file: must_be_immutable

import 'package:chama_projet/inventaire/reception/update_reception.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widget/toast.dart';

class ReceptionDetaile extends StatefulWidget {
  String titre, typeoperation, etat, date, id;
  String receptions;
  // ignore: non_constant_identifier_names
  List LigneOperations;
  ReceptionDetaile(
      {Key? key,
      required this.id,
      required this.titre,
      required this.typeoperation,
      required this.etat,
      required this.receptions,
      required this.date,
      // ignore: non_constant_identifier_names
      required this.LigneOperations})
      : super(key: key);

  @override
  State<ReceptionDetaile> createState() => _ReceptionDetaileState();
}

class _ReceptionDetaileState extends State<ReceptionDetaile> {
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
                if (widget.etat == "Brouillon" || widget.etat == "En attente") {
                  Get.to(() => UpdateReception(
                        id: widget.id,
                        titre: widget.titre,
                        OperationList: widget.LigneOperations,
                        reception: widget.receptions,
                        etat: widget.etat,
                        date: widget.date,
                      ));
                } else {
                  showToast("Ne peut pas modifier cette réception");
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
        color: Colors.grey[200],
        child: ListView(
          children: [
            Column(
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
                        padding: const EdgeInsets.only(left: 10),
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
                Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 160, top: 40),
                      child: Text(
                        "Type d'operation:",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 160),
                      child: Text(
                        widget.typeoperation,
                        style: const TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 195, top: 10),
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
                Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 140, top: 10),
                      child: Text(
                        "Réception de :",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 160),
                      child: Text(
                        widget.receptions,
                        style: const TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 20,
                        ),
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
                              i < widget.LigneOperations.length;
                              i++) ...[
                            DataRow(cells: [
                              DataCell(
                                  Text(widget.LigneOperations[i]['Article'])),
                              DataCell(Text(
                                  widget.LigneOperations[i]['Colis source'])),
                              DataCell(Text(widget.LigneOperations[i]
                                  ['Colis de destination'])),
                              DataCell(Text(
                                  "${widget.LigneOperations[i]['Appartenant']}")),
                              DataCell(
                                  Text("${widget.LigneOperations[i]['Fait']}")),
                              DataCell(Text(
                                  "${widget.LigneOperations[i]['Unite']}")),
                            ]),
                          ]
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
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
