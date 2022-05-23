// ignore_for_file: file_names

import 'package:chama_projet/inventaire/livraison/creer_livraison.dart';
import 'package:chama_projet/services/livraison.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../widget/boitedialogue.dart';

import 'dtail_livraison.dart';

class ListLivraison extends StatefulWidget {
  const ListLivraison({Key? key}) : super(key: key);

  @override
  State<ListLivraison> createState() => _ListLivraisonState();
}

class _ListLivraisonState extends State<ListLivraison> {
  TextEditingController searchcontroller = TextEditingController();
  TextEditingController editingController = TextEditingController();
  // ignore: non_constant_identifier_names
  List Listlivraison = [];
  @override
  void initState() {
    super.initState();
    fetchDatabaseList();
  }

  fetchDatabaseList() async {
    dynamic resultant = await Livraison().getLivraisonList();

    if (resultant == null) {
      // ignore: avoid_print
      print('Unable to retrieve');
    } else {
      setState(() {
        Listlivraison = resultant;
      });
    }
  }

  // ignore: prefer_typing_uninitialized_variables
  var length;

  // ignore: unnecessary_new
  Widget appBarTitle = const Text("Livraison");
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
                  Get.to(() => const CreerLivraison());
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
                child: Listlivraison.isEmpty
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : RefreshIndicator(
                        onRefresh: () {
                          Navigator.pushReplacement(
                              context,
                              PageRouteBuilder(
                                  pageBuilder: (a, b, c) =>
                                      const ListLivraison(),
                                  transitionDuration:
                                      const Duration(seconds: 0)));
                          // ignore: void_checks
                          return Future.value(false);
                        },
                        child: ListView.builder(
                            itemCount: Listlivraison.length,
                            itemBuilder: (context, index) {
                              final liv = Listlivraison[index];
                              return Card(
                                  child: InkWell(
                                onTap: () {
                                  Get.to(() => LivraisonDetaile(
                                      id: liv["IdLiv"],
                                      titre: liv["numliv"],
                                      typeoperation: liv["type d'operation"],
                                      etat: liv["etat"],
                                      livraison: liv["Adresse de livraison"],
                                      LigneOperations: liv["ligne d'operation"],
                                      date: liv["date prévue"]
                                          .toDate()
                                          .toString()
                                          .substring(0, 10)));
                                },
                                splashColor:
                                    const Color.fromARGB(255, 3, 56, 109),
                                child: ListTile(
                                  title: Text(liv["etat"]),
                                  subtitle: Text(
                                      // ignore: unnecessary_string_interpolations
                                      "${liv["date prévue"].toDate().toString().substring(0, 10)}"),
                                  trailing: IconButton(
                                    onPressed: () => {
                                      openDialog(
                                          context,
                                          liv["IdLiv"],
                                          "Êtes-vous sûr de vouloir supprimer ce produit",
                                          "livraison")
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ),
                                  leading: Text(
                                    liv["numliv"],
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
    final suggestions = Listlivraison.where((liv) {
      final namemploye = liv['numliv'].toLowerCase();
      final input = query.toLowerCase();
      return namemploye.contains(input);
    }).toList();
    setState(() {
      Listlivraison = suggestions;
    });
  }

  String formattedDate(timeStamp) {
    var dateFromTimeStamp =
        DateTime.fromMicrosecondsSinceEpoch(timeStamp.seconds * 1000);
    return DateFormat('dd-MM-yyyy').format(dateFromTimeStamp);
  }
}
