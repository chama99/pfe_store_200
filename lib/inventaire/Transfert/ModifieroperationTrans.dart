// ignore_for_file: must_be_immutable, file_names

import 'package:chama_projet/inventaire/Transfert/update_transfert.dart';

import 'package:chama_projet/services/transfert.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widget/NavBottom.dart';

class ModifierOperationTran extends StatefulWidget {
  int num;
  List ligneOperation;
  String titre, date, id;
  String transf, etat;
  String emailus, nameus, url, roleus, adrus, telus, idus;

  List accesus;
  ModifierOperationTran({
    Key? key,
    required this.id,
    required this.titre,
    required this.transf,
    required this.etat,
    required this.num,
    required this.ligneOperation,
    required this.date,
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
  State<ModifierOperationTran> createState() => _ModifierOperationTranState();
}

class _ModifierOperationTranState extends State<ModifierOperationTran> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Modifier Opération ${widget.num}"),
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
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(30),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Article :${widget.ligneOperation[widget.num]["Article"]}",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w500),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    "Colis de destination :",
                    style: TextStyle(fontSize: 15, letterSpacing: 3),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: widget.ligneOperation[widget.num]
                        ["Colis de destination"],
                    onChanged: (value) => widget.ligneOperation[widget.num]
                        ["Colis de destination"] = value,
                    decoration: InputDecoration(
                      hintText: 'Colis de destination',
                      filled: true,
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide:
                            const BorderSide(color: Colors.orange, width: 1.5),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(
                          color: Colors.white,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
                const Text(
                  "Appartenant :",
                  style: TextStyle(fontSize: 15, letterSpacing: 3),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: widget.ligneOperation[widget.num]
                        ["Appartenant"],
                    onChanged: (value) => widget.ligneOperation[widget.num]
                        ["Appartenant"] = value,
                    decoration: InputDecoration(
                      hintText: 'Appartenant à',
                      filled: true,
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide:
                            const BorderSide(color: Colors.orange, width: 1.5),
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
                const Text(
                  "Fait :",
                  style: TextStyle(fontSize: 15, letterSpacing: 3),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: widget.ligneOperation[widget.num]["Fait"],
                    onChanged: (value) =>
                        widget.ligneOperation[widget.num]["Fait"] = value,
                    decoration: InputDecoration(
                      hintText: 'Fait',
                      filled: true,
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide:
                            const BorderSide(color: Colors.orange, width: 1.5),
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
                const Text(
                  "Unité :",
                  style: TextStyle(fontSize: 15, letterSpacing: 3),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue:
                        widget.ligneOperation[widget.num]["Unite"].toString(),
                    onChanged: (value) => widget.ligneOperation[widget.num]
                        ["Unite"] = int.parse(value),
                    decoration: InputDecoration(
                      hintText: 'Unité de mesure',
                      filled: true,
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide:
                            const BorderSide(color: Colors.orange, width: 1.5),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Transfert().updateTransfert(
                            widget.id,
                            "Atelier:Livraison",
                            widget.etat,
                            DateTime.parse(widget.date),
                            widget.ligneOperation,
                            widget.transf);
                        Get.to(() => UpdateTransfert(
                            id: widget.id,
                            titre: widget.titre,
                            OperationList: widget.ligneOperation,
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
                      },
                      child: const Text(
                        "Modifier",
                        style: TextStyle(fontSize: 25),
                      ),
                      style: ElevatedButton.styleFrom(primary: Colors.orange),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
