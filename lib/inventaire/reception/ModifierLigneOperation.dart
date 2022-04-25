// ignore_for_file: must_be_immutable, file_names

import 'package:chama_projet/inventaire/reception/update_reception.dart';
import 'package:chama_projet/services/reception.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ModifierOperation extends StatefulWidget {
  int num;
  List ligneOperation;
  String titre, date;
  String reception, etat;
  ModifierOperation(
      {Key? key,
      required this.titre,
      required this.reception,
      required this.etat,
      required this.num,
      required this.ligneOperation,
      required this.date})
      : super(key: key);

  @override
  State<ModifierOperation> createState() => _ModifierOperationState();
}

class _ModifierOperationState extends State<ModifierOperation> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Modifier Opération ${widget.num}"),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(30),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Article : ${widget.ligneOperation[widget.num]["Article"]}",
                  style: const TextStyle(
                      fontSize: 20, letterSpacing: 3, color: Colors.indigo),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    "Colis de destination :",
                    style: TextStyle(fontSize: 20, letterSpacing: 3),
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
                  "Appartenant a :",
                  style: TextStyle(fontSize: 20, letterSpacing: 3),
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
                  style: TextStyle(fontSize: 20, letterSpacing: 3),
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
                  "Unite :",
                  style: TextStyle(fontSize: 20, letterSpacing: 3),
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
                        Reception().updateReception(
                            widget.titre,
                            "Atelier:Réception",
                            widget.etat,
                            DateTime.parse(widget.date),
                            widget.ligneOperation,
                            widget.reception);
                        Get.to(() => UpdateReception(
                            titre: widget.titre,
                            OperationList: widget.ligneOperation,
                            reception: widget.reception,
                            etat: widget.etat,
                            date: widget.date));
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
