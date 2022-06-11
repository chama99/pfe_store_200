// ignore_for_file: file_names, must_be_immutable

import 'package:chama_projet/inventaire/Transfert/creer_transfert.dart';
import 'package:chama_projet/inventaire/Transfert/detail_transfert.dart';

import 'package:chama_projet/services/transfert.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widget/NavBottom.dart';
import '../../widget/boitedialogue.dart';

class ListTransfert extends StatefulWidget {
  String emailus, nameus, url, roleus, adrus, telus, idus;

  List accesus;
  ListTransfert({
    Key? key,
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
  State<ListTransfert> createState() => _ListTransfertState();
}

class _ListTransfertState extends State<ListTransfert> {
  TextEditingController searchcontroller = TextEditingController();
  TextEditingController editingController = TextEditingController();
  // ignore: non_constant_identifier_names
  List ListTransf = [];
  @override
  void initState() {
    super.initState();
    fetchDatabaseList();
  }

  fetchDatabaseList() async {
    dynamic resultant = await Transfert().getTransfert();

    if (resultant == null) {
      // ignore: avoid_print
      print('Unable to retrieve');
    } else {
      setState(() {
        ListTransf = resultant;
      });
    }
  }

  // ignore: prefer_typing_uninitialized_variables
  var length;

  // ignore: unnecessary_new
  Widget appBarTitle = const Text("Transfert interne");
  Icon actionIcon = const Icon(Icons.search);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: appBarTitle,
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 20, right: 30),
              child: InkWell(
                onTap: () {
                  Get.to(() => CreerTransfert(
                      idus: widget.idus,
                      url: widget.url,
                      telus: widget.telus,
                      adrus: widget.adrus,
                      accesus: widget.accesus,
                      nameus: widget.nameus,
                      emailus: widget.emailus,
                      roleus: widget.roleus));
                },
                child: Text(
                  "Créer".toUpperCase(),
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
          margin: const EdgeInsets.all(10),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  onChanged: (value) {
                    filterSearchResults(value);
                  },
                  controller: editingController,
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide:
                            const BorderSide(color: Colors.orange, width: 1.5),
                      ),
                      labelText: "Recherche",
                      labelStyle: const TextStyle(
                          fontSize: 20.0,
                          color: Color.fromARGB(255, 102, 102, 102)),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.orange,
                      ),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                      )),
                ),
              ),
              Expanded(
                child: ListTransf.isEmpty
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.orange),
                      )
                    : RefreshIndicator(
                        color: Colors.orange,
                        onRefresh: () {
                          Navigator.pushReplacement(
                              context,
                              PageRouteBuilder(
                                  pageBuilder: (a, b, c) => ListTransfert(
                                      idus: widget.idus,
                                      url: widget.url,
                                      telus: widget.telus,
                                      adrus: widget.adrus,
                                      accesus: widget.accesus,
                                      nameus: widget.nameus,
                                      emailus: widget.emailus,
                                      roleus: widget.roleus),
                                  transitionDuration:
                                      const Duration(seconds: 0)));
                          // ignore: void_checks
                          return Future.value(false);
                        },
                        child: ListView.builder(
                            itemCount: ListTransf.length,
                            itemBuilder: (context, index) {
                              final trans = ListTransf[index];
                              return Card(
                                  child: InkWell(
                                onTap: () {
                                  Get.to(() => TransfertDetaile(
                                      id: trans["IdTran"],
                                      titre: trans["numtran"],
                                      typeoperation: trans["type d'operation"],
                                      etat: trans["etat"],
                                      transf: trans["transfert à"],
                                      LigneOperations:
                                          trans["ligne d'operation"],
                                      date: trans["date prévue"]
                                          .toDate()
                                          .toString()
                                          .substring(0, 10),
                                      idus: widget.idus,
                                      url: widget.url,
                                      telus: widget.telus,
                                      adrus: widget.adrus,
                                      accesus: widget.accesus,
                                      nameus: widget.nameus,
                                      emailus: widget.emailus,
                                      roleus: widget.roleus));
                                },
                                splashColor:
                                    const Color.fromARGB(255, 3, 56, 109),
                                child: ListTile(
                                  title: Text(trans["etat"]),
                                  subtitle: Text(
                                      // ignore: unnecessary_string_interpolations
                                      "${trans["date prévue"].toDate().toString().substring(0, 10)}"),
                                  trailing: IconButton(
                                    onPressed: () => {
                                      openDialog(
                                          context,
                                          trans["IdTran"],
                                          "Êtes-vous sûr de vouloir supprimer ce produit",
                                          "transfert")
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ),
                                  leading: Text(
                                    trans["numtran"],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ));
                            })),
              ),
            ],
          ),
        ));
  }

  void filterSearchResults(String query) {
    final suggestions = ListTransf.where((trans) {
      final namemploye = trans['numtran'].toLowerCase();
      final input = query.toLowerCase();
      return namemploye.contains(input);
    }).toList();
    setState(() {
      ListTransf = suggestions;
    });
  }
}
