// ignore_for_file: must_be_immutable, file_names

import 'package:chama_projet/inventaire/livraison/update_livraison.dart';

import 'package:chama_projet/services/livraison.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ModifierOperationLiv extends StatefulWidget {
  int num;
  List ligneOperation;
  String titre, date;
  String livraison, etat, id;
  ModifierOperationLiv(
      {Key? key,
      required this.id,
      required this.titre,
      required this.livraison,
      required this.etat,
      required this.num,
      required this.ligneOperation,
      required this.date})
      : super(key: key);

  @override
  State<ModifierOperationLiv> createState() => _ModifierOperationLivState();
}

class _ModifierOperationLivState extends State<ModifierOperationLiv> {
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
                  "Article :${widget.ligneOperation[widget.num]["Article"]}",
                  style: const TextStyle(
                      fontSize: 20, color: Colors.indigo, letterSpacing: 3),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    "Colis source :",
                    style: TextStyle(fontSize: 15, letterSpacing: 3),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: widget.ligneOperation[widget.num]
                        ["Colis source"],
                    onChanged: (value) => widget.ligneOperation[widget.num]
                        ["Colis source"] = value,
                    decoration: InputDecoration(
                      hintText: 'Colis source',
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
                  "Colis de destination :",
                  style: TextStyle(fontSize: 15, letterSpacing: 3),
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
                  "Appartenant a  :",
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
                        Livraison().updateLivraison(
                            widget.id,
                            "Atelier:Livraison",
                            widget.etat,
                            DateTime.parse(widget.date),
                            widget.ligneOperation,
                            widget.livraison);
                        Get.to(() => UpdateLivraison(
                            id: widget.id,
                            titre: widget.titre,
                            OperationList: widget.ligneOperation,
                            livraison: widget.livraison,
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
