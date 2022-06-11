// ignore_for_file: file_names, unused_local_variable, camel_case_types, must_be_immutable

import 'package:chama_projet/services/contact.dart';
import 'package:chama_projet/widget/boitedialogue.dart';

import 'package:flutter/material.dart';

import '../widget/NavBottom.dart';
import 'ContactDetailler.dart';
import 'creer_contact.dart';

class listContact extends StatefulWidget {
  String emailus, nameus, url, roleus, adrus, telus, idus;

  List accesus;
  listContact({
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
  _listContactState createState() => _listContactState();
}

class _listContactState extends State<listContact> {
  TextEditingController searchcontroller = TextEditingController();
  TextEditingController editingController = TextEditingController();
  List userContactList = [];
  @override
  void initState() {
    super.initState();

    fetchDatabaseList();
  }

  fetchDatabaseList() async {
    dynamic resultant = await Client().getClientsList();

    if (resultant == null) {
      // ignore: avoid_print
      print('Unable to retrieve');
    } else {
      setState(() {
        userContactList = resultant;
      });
    }
  }

  // ignore: prefer_typing_uninitialized_variables
  var length;

  // ignore: unnecessary_new
  Widget appBarTitle = const Text("Clients");
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
                          builder: (context) => CreeContactPage(
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
                child: userContactList.isEmpty
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.orange,
                        ),
                      )
                    : RefreshIndicator(
                        color: Colors.orange,
                        onRefresh: () {
                          Navigator.pushReplacement(
                              context,
                              PageRouteBuilder(
                                  pageBuilder: (a, b, c) => listContact(
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
                            itemCount: userContactList.length,
                            itemBuilder: (context, index) {
                              final contact = userContactList[index];
                              return Card(
                                  child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ContactDetail(
                                              id: userContactList[index]['id'],
                                              image: userContactList[index]
                                                  ['image'],
                                              email: userContactList[index]
                                                  ['email'],
                                              nom: userContactList[index]
                                                  ['name'],
                                              tel: userContactList[index]
                                                  ['portable professionnel'],
                                              adresse: userContactList[index]
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
                                  title: Text(contact["name"]),
                                  subtitle: Text(contact["email"]),
                                  trailing: IconButton(
                                    onPressed: () => {
                                      openDialog(
                                          context,
                                          contact["id"],
                                          "Êtes-vous sûr de vouloir supprimer",
                                          "contact")
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ),
                                  leading: CircleAvatar(
                                    radius: 20.0,
                                    backgroundImage:
                                        NetworkImage(contact['image']),
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
    final suggestions = userContactList.where((employe) {
      final namemploye = employe['name'].toLowerCase();
      final input = query.toLowerCase();
      return namemploye.contains(input);
    }).toList();
    setState(() {
      userContactList = suggestions;
    });
  }
}
