// ignore_for_file: file_names, unused_local_variable, camel_case_types

import 'package:chama_projet/widget/boitedialogue.dart';

import 'package:flutter/material.dart';

import '../services/employe.dart';
import '../widget/NavBottom.dart';
import 'creer_employe.dart';
import 'employe_detaille.dart';

class listEmploye extends StatefulWidget {
  String emailus, nameus, url, roleus, adrus, telus, idus;

  List accesus;
  listEmploye({
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
  _listEmployeState createState() => _listEmployeState();
}

class _listEmployeState extends State<listEmploye> {
  TextEditingController searchcontroller = TextEditingController();
  TextEditingController editingController = TextEditingController();
  List userProfilesList = [];
  @override
  void initState() {
    super.initState();

    fetchDatabaseList();
  }

  fetchDatabaseList() async {
    dynamic resultant = await Employe().getEmployesList();

    if (resultant == null) {
      // ignore: avoid_print
      print('Unable to retrieve');
    } else {
      setState(() {
        userProfilesList = resultant;
      });
    }
  }

  // ignore: prefer_typing_uninitialized_variables
  var length;

  // ignore: unnecessary_new
  Widget appBarTitle = const Text("Employés");
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
                          builder: (context) => CreeEmployePage(
                              idus: widget.idus,
                              url: widget.url,
                              telus: widget.telus,
                              adrus: widget.adrus,
                              accesus: widget.accesus,
                              nameus: widget.nameus,
                              emailus: widget.emailus,
                              roleus: widget.roleus)));
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
                child: userProfilesList.isEmpty
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.orange,
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () {
                          Navigator.pushReplacement(
                              context,
                              PageRouteBuilder(
                                  pageBuilder: (a, b, c) => listEmploye(
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
                            itemCount: userProfilesList.length,
                            itemBuilder: (context, index) {
                              final employe = userProfilesList[index];
                              return Card(
                                  child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EmployeDetail(
                                              id: userProfilesList[index]
                                                  ['IdEmp'],
                                              nom: userProfilesList[index]
                                                  ['name'],
                                              tel: userProfilesList[index]
                                                  ['portable professionnel'],
                                              adresse: userProfilesList[index]
                                                  ['Adresse professionnelle'],
                                              idus: widget.idus,
                                              url: widget.url,
                                              telus: widget.telus,
                                              adrus: widget.adrus,
                                              accesus: widget.accesus,
                                              nameus: widget.nameus,
                                              emailus: widget.emailus,
                                              roleus: widget.roleus)));
                                },
                                splashColor:
                                    const Color.fromARGB(255, 3, 56, 109),
                                child: ListTile(
                                  title: Text(employe["name"]),
                                  trailing: IconButton(
                                    onPressed: () => {
                                      openDialog(
                                          context,
                                          employe["IdEmp"],
                                          "Êtes-vous sûr de vouloir supprimer cet employé",
                                          "employé")
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
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
    final suggestions = userProfilesList.where((employe) {
      final namemploye = employe['name'].toLowerCase();
      final input = query.toLowerCase();
      return namemploye.contains(input);
    }).toList();
    setState(() {
      userProfilesList = suggestions;
    });
  }
}
