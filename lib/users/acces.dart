import 'package:chama_projet/users/ajoutAcces.dart';
import 'package:flutter/material.dart';

import '../services/user.dart';
import '../widget/NavBottom.dart';

class Roles extends StatefulWidget {
  String emailus, nameus, url, roleus, adrus, telus, idus;

  List accesus;
  Roles({
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
  State<Roles> createState() => _RolesState();
}

class _RolesState extends State<Roles> {
  List listItem = ["Technicien", "Comptable", "Tous Les Utilisateurs"];
  List userProfilesList = [];
  List userTechList = [];
  List userCompList = [];
  List roleList = [];

  // ignore: prefer_typing_uninitialized_variables
  var ch;

  @override
  void initState() {
    super.initState();

    fetchDatabaseList();
  }

  fetchDatabaseList() async {
    dynamic resultant = await User().getUsersList();
    dynamic resultech = await User().getListUserTech();
    dynamic resultcomp = await User().getListUserCompt();

    if (resultant == null) {
      // ignore: avoid_print
      print('Unable to retrieve');
    } else {
      setState(() {
        userProfilesList = resultant;
        userTechList = resultech;
        userCompList = resultcomp;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                ),
                child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                  hint: const Text("Regrouper par "),
                  dropdownColor: Colors.white,
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.orange,
                  ),
                  style: const TextStyle(fontSize: 18, color: Colors.black),
                  iconSize: 25,
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
                )),
              ),
            ],
          )
        ],
        title: const Text("Rôle"),
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
      body: RefreshIndicator(
        onRefresh: () {
          Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                  pageBuilder: (a, b, c) => Roles(
                      idus: widget.idus,
                      url: widget.url,
                      telus: widget.telus,
                      adrus: widget.adrus,
                      accesus: widget.accesus,
                      nameus: widget.nameus,
                      emailus: widget.emailus,
                      roleus: widget.roleus),
                  transitionDuration: const Duration(seconds: 0)));
          // ignore: void_checks
          return Future.value(false);
        },
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(10),
            child: Column(children: [
              Container(
                padding: const EdgeInsets.only(top: 8, left: 5, right: 5),
                child: Table(
                    border: TableBorder.all(
                      color: Colors.grey,
                    ),
                    columnWidths: const <int, TableColumnWidth>{
                      1: FixedColumnWidth(220),
                    },
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      const TableRow(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: TableCell(
                              child: Center(
                                child: Text(
                                  'Utilisateur',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: TableCell(
                              child: Center(
                                child: Text(
                                  "Accès à l'application ",
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (ch == "Technicien") ...[
                        for (var i = 0; i < userTechList.length; i++) ...[
                          TableRow(
                            children: [
                              TableCell(
                                child: Center(
                                    child: Text(userTechList[i]['name'],
                                        style:
                                            const TextStyle(fontSize: 18.0))),
                              ),
                              TableCell(
                                  child: Column(
                                children: [
                                  for (var j = 0;
                                      j < userTechList[i]['acces'].length;
                                      j++) ...[
                                    Card(
                                      child: ListTile(
                                        title:
                                            Text(userTechList[i]['acces'][j]),
                                        trailing: IconButton(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: const Text(
                                                    "Êtes-vous sûr de vouloir supprimer ce Application"),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: const Text(
                                                          'Annuler')),
                                                  TextButton(
                                                      onPressed: () {
                                                        List listest =
                                                            userTechList[i]
                                                                ['acces'];
                                                        listest.removeAt(j);
                                                        User().updateRoleUser(
                                                          userTechList[i]
                                                              ['IdUser'],
                                                          listest,
                                                        );
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text(
                                                          'Confirmer')),
                                                ],
                                              ),
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                  Container(
                                    margin: const EdgeInsets.all(30),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.orange,
                                    ),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8.0, bottom: 8, left: 30),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AjoutAcces(
                                                              id: userTechList[
                                                                  i]['IdUser'],
                                                              acces:
                                                                  userTechList[
                                                                          i]
                                                                      ['acces'],
                                                              name:
                                                                  userTechList[i]
                                                                      ['name'],
                                                              idus: widget.idus,
                                                              url: widget.url,
                                                              telus:
                                                                  widget.telus,
                                                              adrus:
                                                                  widget.adrus,
                                                              accesus: widget
                                                                  .accesus,
                                                              nameus:
                                                                  widget.nameus,
                                                              emailus: widget
                                                                  .emailus,
                                                              roleus: widget
                                                                  .roleus)));
                                            },
                                            child: const Icon(
                                              Icons.add,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            "Ajouter",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              )),
                            ],
                          ),
                        ],
                      ] else if (ch == "Comptable") ...[
                        for (var i = 0; i < userCompList.length; i++) ...[
                          TableRow(
                            children: [
                              TableCell(
                                child: Center(
                                    child: Text(userCompList[i]['name'],
                                        style:
                                            const TextStyle(fontSize: 18.0))),
                              ),
                              TableCell(
                                  child: Column(
                                children: [
                                  for (var j = 0;
                                      j < userCompList[i]['acces'].length;
                                      j++) ...[
                                    Card(
                                      child: ListTile(
                                        title:
                                            Text(userCompList[i]['acces'][j]),
                                        trailing: IconButton(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: const Text(
                                                    "Êtes-vous sûr de vouloir supprimer ce Application"),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: const Text(
                                                          'Annuler')),
                                                  TextButton(
                                                      onPressed: () {
                                                        List listest =
                                                            userCompList[i]
                                                                ['acces'];
                                                        listest.removeAt(j);
                                                        User().updateRoleUser(
                                                          userCompList[i]
                                                              ['IdUser'],
                                                          listest,
                                                        );
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text(
                                                          'Confirmer')),
                                                ],
                                              ),
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                  Container(
                                    margin: const EdgeInsets.all(30),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.orange,
                                    ),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8.0, bottom: 8, left: 30),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AjoutAcces(
                                                              id: userCompList[
                                                                  i]['IdUser'],
                                                              acces:
                                                                  userCompList[
                                                                          i]
                                                                      ['acces'],
                                                              name:
                                                                  userCompList[i]
                                                                      ['name'],
                                                              idus: widget.idus,
                                                              url: widget.url,
                                                              telus:
                                                                  widget.telus,
                                                              adrus:
                                                                  widget.adrus,
                                                              accesus: widget
                                                                  .accesus,
                                                              nameus:
                                                                  widget.nameus,
                                                              emailus: widget
                                                                  .emailus,
                                                              roleus: widget
                                                                  .roleus)));
                                            },
                                            child: const Icon(
                                              Icons.add,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            "Ajouter",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              )),
                            ],
                          ),
                        ],
                      ] else ...[
                        for (var i = 0; i < userProfilesList.length; i++) ...[
                          TableRow(
                            children: [
                              TableCell(
                                child: Center(
                                    child: Text(userProfilesList[i]['name'],
                                        style:
                                            const TextStyle(fontSize: 18.0))),
                              ),
                              TableCell(
                                  child: Column(
                                children: [
                                  for (var j = 0;
                                      j < userProfilesList[i]['acces'].length;
                                      j++) ...[
                                    Card(
                                      child: ListTile(
                                        title: Text(
                                            userProfilesList[i]['acces'][j]),
                                        trailing: IconButton(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: const Text(
                                                    "Êtes-vous sûr de vouloir supprimer ce Application"),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: const Text(
                                                          'Annuler')),
                                                  TextButton(
                                                      onPressed: () {
                                                        List listest =
                                                            userProfilesList[i]
                                                                ['acces'];
                                                        listest.removeAt(j);
                                                        User().updateRoleUser(
                                                            userProfilesList[i]
                                                                ['IdUser'],
                                                            listest);
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text(
                                                          'Confirmer')),
                                                ],
                                              ),
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                  Container(
                                    margin: const EdgeInsets.all(30),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.orange,
                                    ),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8.0, bottom: 8, left: 30),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => AjoutAcces(
                                                          id: userProfilesList[
                                                              i]['IdUser'],
                                                          acces:
                                                              userProfilesList[
                                                                  i]['acces'],
                                                          name:
                                                              userProfilesList[
                                                                  i]['name'],
                                                          idus: widget.idus,
                                                          url: widget.url,
                                                          telus: widget.telus,
                                                          adrus: widget.adrus,
                                                          accesus:
                                                              widget.accesus,
                                                          nameus: widget.nameus,
                                                          emailus:
                                                              widget.emailus,
                                                          roleus:
                                                              widget.roleus)));
                                            },
                                            child: const Icon(
                                              Icons.add,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            "Ajouter",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              )),
                            ],
                          ),
                        ],
                      ]
                    ]),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
