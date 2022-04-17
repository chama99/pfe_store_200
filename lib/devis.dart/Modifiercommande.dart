// ignore_for_file: prefer_typing_uninitialized_variables, file_names, must_be_immutable

import 'package:chama_projet/devis.dart/updateDevis.dart';
import 'package:chama_projet/services/devis.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ModifierCommande extends StatefulWidget {
  String titre, client, etat, role;
  int num;
  double remise;
  List commande;
  double total, montant;
  ModifierCommande(
      {Key? key,
      required this.titre,
      required this.client,
      required this.etat,
      required this.commande,
      required this.total,
      required this.remise,
      required this.montant,
      required this.num,
      required this.role})
      : super(key: key);

  @override
  State<ModifierCommande> createState() => _ModifierCommandeState();
}

class _ModifierCommandeState extends State<ModifierCommande> {
  final _formKey = GlobalKey<FormState>();
  var article;
  List listItem = ["store12", "store15"];

  List list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text("Modifier  Ligne de la commande ${widget.num}"),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(30),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: '${widget.commande[widget.num]["réf"]}',
                    onChanged: (value) {
                      widget.commande[widget.num]["réf"] = value;
                    },
                    decoration: InputDecoration(
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 320,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey, width: 1)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        dropdownColor: Colors.white,
                        icon: const Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: Icon(
                            Icons.arrow_drop_down,
                            color: Colors.orange,
                          ),
                        ),
                        style:
                            const TextStyle(fontSize: 20, color: Colors.black),
                        iconSize: 40,
                        value: "${widget.commande[widget.num]["Article"]}",
                        onChanged: (newValue) {
                          setState(() {
                            widget.commande[widget.num]["Article"] =
                                newValue.toString();
                          });
                        },
                        items: listItem.map((valueItem) {
                          return DropdownMenuItem(
                            value: valueItem,
                            child: Text(valueItem),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue:
                        '${widget.commande[widget.num]["Description"]}',
                    onChanged: (value) {
                      widget.commande[widget.num]["Description"] = value;
                    },
                    decoration: InputDecoration(
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: '${widget.commande[widget.num]["Unite"]}',
                    onChanged: (value) {
                      widget.commande[widget.num]["Unite"] = int.parse(value);
                    },
                    decoration: InputDecoration(
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    initialValue: '${widget.commande[widget.num]["Quantite"]}',
                    onChanged: (value) {
                      widget.commande[widget.num]["Quantite"] =
                          int.parse(value);
                    },
                    decoration: InputDecoration(
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    initialValue: '${widget.commande[widget.num]["prix"]}',
                    onChanged: (value) {
                      widget.commande[widget.num]["prix"] = double.parse(value);
                    },
                    decoration: InputDecoration(
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
                        widget.commande[widget.num]["sous-total"] =
                            widget.commande[widget.num]["Quantite"] *
                                widget.commande[widget.num]["prix"];
                        Devis().updateDevis(
                            widget.titre,
                            widget.client,
                            widget.etat,
                            widget.total,
                            widget.commande,
                            widget.remise,
                            widget.montant);

                        Get.to(() => UpdateDevis(
                              titre: widget.titre,
                              client: widget.client,
                              etat: widget.etat,
                              total: widget.total,
                              commande: widget.commande,
                              remise: widget.remise,
                              montant: widget.montant,
                              role: widget.role,
                            ));
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
