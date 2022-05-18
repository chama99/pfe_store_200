// ignore_for_file: file_names, unused_local_variable, must_be_immutable

import 'package:chama_projet/services/devis.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../widget/NavBottom.dart';
import '../widget/boitedialogue.dart';
import 'creer_devis.dart';
import 'devis_detailler.dart';

class ListDevis extends StatefulWidget {
  String role, idus;
  String name, email, url, tel, adr;
  List acces;
  ListDevis(
      {Key? key,
      required this.idus,
      required this.role,
      required this.email,
      required this.name,
      required this.acces,
      required this.url,
      required this.adr,
      required this.tel})
      : super(key: key);

  @override
  _ListDevisState createState() => _ListDevisState();
}

class _ListDevisState extends State<ListDevis> {
  TextEditingController searchcontroller = TextEditingController();
  TextEditingController editingController = TextEditingController();
  // ignore: non_constant_identifier_names
  List Listdevis = [];
  @override
  void initState() {
    super.initState();

    fetchDatabaseList();
  }

  fetchDatabaseList() async {
    dynamic resultant = await Devis().getDevisList();

    if (resultant == null) {
      // ignore: avoid_print
      print('Unable to retrieve');
    } else {
      setState(() {
        Listdevis = resultant;
      });
    }
  }

  // ignore: prefer_typing_uninitialized_variables
  var length;

  // ignore: unnecessary_new
  Widget appBarTitle = const Text("Devis");
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreeDevisPage(
                                idus: widget.idus,
                                role: widget.role,
                                email: widget.email,
                                acces: widget.acces,
                                name: widget.name,
                                url: widget.url,
                                tel: widget.tel,
                                adr: widget.adr,
                              )));
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
            tel: widget.tel,
            adr: widget.adr,
            id: widget.idus,
            email: widget.email,
            name: widget.name,
            acces: widget.acces,
            url: widget.url,
            role: widget.role),
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
                child: Listdevis.isEmpty
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : RefreshIndicator(
                        onRefresh: () {
                          Navigator.pushReplacement(
                              context,
                              PageRouteBuilder(
                                  pageBuilder: (a, b, c) => ListDevis(
                                        idus: widget.idus,
                                        role: widget.role,
                                        email: widget.email,
                                        acces: widget.acces,
                                        name: widget.name,
                                        url: widget.url,
                                        adr: widget.adr,
                                        tel: widget.tel,
                                      ),
                                  transitionDuration:
                                      const Duration(seconds: 0)));
                          // ignore: void_checks
                          return Future.value(false);
                        },
                        child: ListView.builder(
                            itemCount: Listdevis.length,
                            itemBuilder: (context, index) {
                              final devis = Listdevis[index];
                              return Card(
                                  child: InkWell(
                                onTap: () {
                                  Get.to(() => DevisDetailler(
                                        idus: widget.idus,
                                        titre: devis["numdevis"],
                                        id: devis["idDevis"],
                                        client: devis["client"],
                                        etat: devis["etat"],
                                        commande: devis["commande"],
                                        total: devis["total"],
                                        remise: devis["remise"],
                                        montant: devis["montant"],
                                        date: devis["date de devis"]
                                            .toDate()
                                            .toString()
                                            .substring(0, 10),
                                        role: widget.role,
                                        email: widget.email,
                                        name: widget.name,
                                        acces: widget.acces,
                                        url: widget.url,
                                        adr: widget.adr,
                                        tel: widget.tel,
                                      ));
                                },
                                splashColor:
                                    const Color.fromARGB(255, 3, 56, 109),
                                child: ListTile(
                                  title: Text(devis["etat"]),
                                  subtitle: Text(
                                      "${devis["date de devis"].toDate().toString().substring(0, 10)}               ${devis["total"]}£"),
                                  trailing: IconButton(
                                    onPressed: () => {
                                      openDialog(
                                          context,
                                          devis["idDevis"],
                                          "Êtes-vous sûr de vouloir supprimer ce devis",
                                          "devis")
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ),
                                  leading: Text(
                                    devis["numdevis"],
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
    final suggestions = Listdevis.where((devis) {
      final namemploye = devis['numdevis'].toLowerCase();
      final input = query.toLowerCase();
      return namemploye.contains(input);
    }).toList();
    setState(() {
      Listdevis = suggestions;
    });
  }

  String formattedDate(timeStamp) {
    var dateFromTimeStamp =
        DateTime.fromMicrosecondsSinceEpoch(timeStamp.seconds * 2000);
    return DateFormat('MM/dd/yyyy').format(dateFromTimeStamp);
  }
}
