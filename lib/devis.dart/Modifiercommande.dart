// ignore_for_file: prefer_typing_uninitialized_variables, file_names, must_be_immutable

import 'package:chama_projet/devis.dart/updateDevis.dart';
import 'package:chama_projet/services/devis.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ModifierCommande extends StatefulWidget {
  String titre, client, etat;
  String num;
  double remise;
  List commande;
  double total, montant;
  ModifierCommande({
    Key? key,
    required this.titre,
    required this.client,
    required this.etat,
    required this.commande,
    required this.total,
    required this.remise,
    required this.montant,
    required this.num,
  }) : super(key: key);

  @override
  State<ModifierCommande> createState() => _ModifierCommandeState();
}

class _ModifierCommandeState extends State<ModifierCommande> {
  final _formKey = GlobalKey<FormState>();
  var article;
  List listItem = ["store12", "store15"];
  final ref = TextEditingController();
  final des = TextEditingController();
  final unite = TextEditingController();
  final qt = TextEditingController();
  final prix = TextEditingController();
  List list = [];
  var ch;

  clearText() {
    ref.clear();
    des.clear();
    unite.clear();
    qt.clear();
    prix.clear();

    article = null;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    ref.dispose();
    des.dispose();
    unite.dispose();
    qt.dispose();
    prix.dispose();

    super.dispose();
  }

  addcomm(r, a, d, u, q, p) {
    widget.commande[int.parse(widget.num)]["réf"] = r;
    widget.commande[int.parse(widget.num)]["Article"] = a;
    widget.commande[int.parse(widget.num)]["Description"] = d;
    widget.commande[int.parse(widget.num)]["Unite"] = u;
    widget.commande[int.parse(widget.num)]["Quantite"] = q;
    widget.commande[int.parse(widget.num)]["prix"] = p;
    widget.commande[int.parse(widget.num)]["taxe"] = "20%";
    widget.commande[int.parse(widget.num)]["sous-total"] = q * p;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text("Modifier  Ligne de la commande\n Numéro ${widget.num}"),
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
                    controller: ref,
                    decoration: InputDecoration(
                      hintText:
                          '${widget.commande[int.parse(widget.num)]["réf"]}',
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
                        hint: Text(
                            "${widget.commande[int.parse(widget.num)]["Article"]}"),
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
                        value: ch,
                        onChanged: (newValue) {
                          setState(() {
                            ch = newValue.toString();
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
                    controller: des,
                    decoration: InputDecoration(
                      hintText:
                          '${widget.commande[int.parse(widget.num)]["Description"]}',
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
                    controller: unite,
                    decoration: InputDecoration(
                      hintText:
                          '${widget.commande[int.parse(widget.num)]["Unite"]}',
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
                    controller: qt,
                    decoration: InputDecoration(
                      hintText:
                          '${widget.commande[int.parse(widget.num)]["Quantite"]}',
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
                    controller: prix,
                    decoration: InputDecoration(
                      hintText: 'Prix unitaire',
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
                        if (_formKey.currentState!.validate()) {
                          var r;
                          var a;
                          var d;
                          var u;
                          var q;
                          var p;
                          if (ref.text.isEmpty) {
                            r = widget.commande[int.parse(widget.num)]["réf"];
                          } else {
                            r = ref.text;
                          }
                          if (ch != null) {
                            a = ch;
                          } else {
                            a = widget.commande[int.parse(widget.num)]
                                ["Article"];
                          }
                          if (des.text.isEmpty) {
                            d = widget.commande[int.parse(widget.num)]
                                ["Description"];
                          } else {
                            d = des.text;
                          }
                          if (unite.text.isEmpty) {
                            u = widget.commande[int.parse(widget.num)]["Unite"];
                          } else {
                            u = unite.text;
                          }
                          if (qt.text.isEmpty) {
                            q = widget.commande[int.parse(widget.num)]
                                ["Quantite"];
                          } else {
                            q = int.parse(qt.text);
                          }
                          if (prix.text.isEmpty) {
                            p = widget.commande[int.parse(widget.num)]["prix"];
                          } else {
                            p = double.parse(prix.text);
                          }
                          addcomm(r, a, d, u, q, p);
                          Devis().updateDevis(
                              widget.titre,
                              widget.client,
                              widget.etat,
                              widget.total,
                              widget.commande,
                              widget.remise,
                              widget.montant);
                          clearText();
                          Get.to(() => UpdateDevis(
                              titre: widget.titre,
                              client: widget.client,
                              etat: widget.etat,
                              total: widget.total,
                              commande: widget.commande,
                              remise: widget.remise,
                              montant: widget.montant));
                        }
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
