// ignore_for_file: file_names, unused_local_variable, must_be_immutable

import 'package:chama_projet/facture.dart/detille_facture.dart';
import 'package:chama_projet/services/facture.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/autofacture.dart';
import '../widget/NavBottom.dart';

class ListFactureDev extends StatefulWidget {
  String emailus, nameus, url, roleus, adrus, telus, idus;

  List accesus;
  ListFactureDev({
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
  _ListFactureDevState createState() => _ListFactureDevState();
}

class _ListFactureDevState extends State<ListFactureDev> {
  TextEditingController searchcontroller = TextEditingController();
  TextEditingController editingController = TextEditingController();
  // ignore: non_constant_identifier_names
  List ListFact = [];
  @override
  void initState() {
    super.initState();
    fetchDatabaseList();
  }

  var i = 0;
  List fact = [];
  List test = [];
  fetchDatabaseList() async {
    dynamic resfa = await AutoFacture().getFacturesList();

    dynamic resf = await Facture().getFacturesList();

    if (resfa == null) {
      // ignore: avoid_print
      print('Unable to retrieve');
    } else {
      setState(() {
        fact = resf;
        ListFact = resfa;
      });
    }
  }

  // ignore: prefer_typing_uninitialized_variables
  var length;

  // ignore: unnecessary_new
  Widget appBarTitle = const Text("Factures");
  Icon actionIcon = const Icon(Icons.search);

  @override
  Widget build(BuildContext context) {
    var l = fact.length;
    return Scaffold(
        appBar: AppBar(
          title: appBarTitle,
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
                child: ListFact.isEmpty
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.orange),
                      )
                    : RefreshIndicator(
                        color: Colors.orange,
                        onRefresh: () {
                          Navigator.pushReplacement(
                              context,
                              PageRouteBuilder(
                                  pageBuilder: (a, b, c) => ListFactureDev(
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
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                  itemCount: ListFact.length,
                                  itemBuilder: (context, index) {
                                    final facture = ListFact[index];
                                    l = l + 1;
                                    return Card(
                                        child: InkWell(
                                      onTap: () {
                                        Get.to(
                                          () => DetailFacture(
                                              id: facture["IdFact"],
                                              titre: facture["numfact"],
                                              client: facture['client'],
                                              etat: facture['etat'],
                                              date1:
                                                  facture["date de facturation"]
                                                      .toDate()
                                                      .toString()
                                                      .substring(0, 10),
                                              total: facture['total'],
                                              listfact:
                                                  facture["ligne facture"],
                                              montant: facture["montant"],
                                              res: facture['remise'],
                                              page: "autofacture",
                                              idus: widget.idus,
                                              url: widget.url,
                                              telus: widget.telus,
                                              adrus: widget.adrus,
                                              accesus: widget.accesus,
                                              nameus: widget.nameus,
                                              emailus: widget.emailus,
                                              roleus: widget.roleus),
                                        );
                                      },
                                      splashColor:
                                          const Color.fromARGB(255, 3, 56, 109),
                                      child: ListTile(
                                        title: Text(facture["etat"]),
                                        subtitle: Text(
                                            // ignore: unnecessary_string_interpolations
                                            "${facture["date de facturation"].toDate().toString().substring(0, 10)}     ${facture["total"]}£"),
                                        leading: Text(
                                          facture["numfact"],
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        trailing: Text(
                                          facture["numdevis"],
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ));
                                  }),
                            ),
                          ],
                        )),
              ),
            ],
          ),
        ));
  }

  void filterSearchResults(String query) {
    final suggestions = ListFact.where((facture) {
      final namfact = facture['numfact'].toLowerCase();
      final input = query.toLowerCase();
      return namfact.contains(input);
    }).toList();
    setState(() {
      ListFact = suggestions;
    });
  }
}
