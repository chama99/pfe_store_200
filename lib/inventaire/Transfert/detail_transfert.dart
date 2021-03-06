// ignore_for_file: must_be_immutable

import 'package:chama_projet/inventaire/Transfert/update_transfert.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widget/NavBottom.dart';
import '../../widget/toast.dart';

class TransfertDetaile extends StatefulWidget {
  String titre, typeoperation, etat, date, id;
  String transf;
  // ignore: non_constant_identifier_names
  List LigneOperations;
  String emailus, nameus, url, roleus, adrus, telus, idus;

  List accesus;
  TransfertDetaile({
    Key? key,
    required this.id,
    required this.titre,
    required this.typeoperation,
    required this.etat,
    required this.transf,
    required this.date,
    // ignore: non_constant_identifier_names
    required this.LigneOperations,
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
  State<TransfertDetaile> createState() => _TransfertDetaileState();
}

class _TransfertDetaileState extends State<TransfertDetaile> {
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
                  Get.to(() => UpdateTransfert(
                      id: widget.id,
                      titre: widget.titre,
                      OperationList: widget.LigneOperations,
                      transf: widget.transf,
                      etat: widget.etat,
                      date: widget.date,
                      idus: widget.idus,
                      url: widget.url,
                      telus: widget.telus,
                      adrus: widget.adrus,
                      accesus: widget.accesus,
                      nameus: widget.nameus,
                      emailus: widget.emailus,
                      roleus: widget.roleus));
                } else {
                  showToast("Ne peut pas modifier ce transfert");
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
      bottomNavigationBar: NavBottom(
          tel: widget.telus,
          adr: widget.adrus,
          id: widget.idus,
          email: widget.emailus,
          name: widget.nameus,
          acces: widget.accesus,
          url: widget.url,
          role: widget.roleus),
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
                        child: Text("S??te,le",
                            style: TextStyle(
                              fontSize: 20,
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
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
                        "??tat:",
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
                      padding: EdgeInsets.only(left: 110, top: 10),
                      child: Text(
                        "Transfert ??:",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 160),
                      child: Text(
                        widget.transf,
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
                            label: Text("Appartenant ??"),
                          ),
                          DataColumn(
                            label: Text("Fait"),
                          ),
                          DataColumn(
                            label: Text("Unit?? de mesure"),
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
