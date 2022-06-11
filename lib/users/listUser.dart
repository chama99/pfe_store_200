// ignore_for_file: file_names, unused_local_variable

import 'package:chama_projet/users/utilisateur_detaille.dart';
import 'package:chama_projet/services/user.dart';

import 'package:flutter/material.dart';

import '../widget/NavBottom.dart';
import '../widget/boitedialogue.dart';
import 'creer_user_page.dart';

// ignore: must_be_immutable
class ListUser extends StatefulWidget {
  String role, idus;
  String name, email, url, tel, adr;
  List acces;
  ListUser(
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
  _ListUserState createState() => _ListUserState();
}

class _ListUserState extends State<ListUser> {
  TextEditingController searchcontroller = TextEditingController();
  TextEditingController editingController = TextEditingController();
  List userProfilesList = [];
  @override
  void initState() {
    super.initState();

    fetchDatabaseList();
  }

  fetchDatabaseList() async {
    dynamic resultant = await User().getUsersList();

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
  Widget appBarTitle = const Text("Utilisateurs");
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
                          builder: (context) => AddUserPage(
                              idus: widget.idus,
                              role: widget.role,
                              email: widget.email,
                              name: widget.name,
                              acces: widget.acces,
                              url: widget.url,
                              adr: widget.adr,
                              tel: widget.tel)));
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
                child: userProfilesList.isEmpty
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.orange),
                      )
                    : RefreshIndicator(
                        color: Colors.orange,
                        onRefresh: () {
                          Navigator.pushReplacement(
                              context,
                              PageRouteBuilder(
                                  pageBuilder: (a, b, c) => ListUser(
                                      idus: widget.idus,
                                      role: widget.role,
                                      email: widget.email,
                                      name: widget.name,
                                      acces: widget.acces,
                                      url: widget.url,
                                      adr: widget.adr,
                                      tel: widget.tel),
                                  transitionDuration:
                                      const Duration(seconds: 0)));
                          // ignore: void_checks
                          return Future.value(false);
                        },
                        child: ListView.builder(
                            itemCount: userProfilesList.length,
                            itemBuilder: (context, index) {
                              final user = userProfilesList[index];
                              return Card(
                                  child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              UtilisateurDetail(
                                                  id: user['IdUser'],
                                                  idus: widget.idus,
                                                  image: user['image'],
                                                  email: user['email'],
                                                  nom: user['name'],
                                                  mdp: user['mot de passe'],
                                                  role: user['role'],
                                                  acces: user['acces'],
                                                  tel: user['telephone'],
                                                  adr: user['adresse'],
                                                  url: widget.url,
                                                  telus: widget.tel,
                                                  adrus: widget.adr,
                                                  accesus: widget.acces,
                                                  nameus: widget.name,
                                                  emailus: widget.email,
                                                  roleus: widget.role)));
                                },
                                splashColor:
                                    const Color.fromARGB(255, 3, 56, 109),
                                child: ListTile(
                                  title: Text(user["name"]),
                                  subtitle: Text(user["email"]),
                                  trailing: IconButton(
                                    onPressed: () => {
                                      openDialog(
                                          context,
                                          user["IdUser"],
                                          "Êtes-vous sûr de vouloir supprimer cet utilisateur",
                                          "utilisateur")
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ),
                                  leading: CircleAvatar(
                                    radius: 20.0,
                                    backgroundImage:
                                        NetworkImage(user['image']),
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
    final suggestions = userProfilesList.where((user) {
      final namemploye = user['name'].toLowerCase();
      final input = query.toLowerCase();
      return namemploye.contains(input);
    }).toList();
    setState(() {
      userProfilesList = suggestions;
    });
  }
}
