import 'package:chama_projet/pages/ajoutRole.dart';
import 'package:flutter/material.dart';

import '../services/user.dart';

class Roles extends StatefulWidget {
  const Roles({Key? key}) : super(key: key);

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
      body: RefreshIndicator(
        onRefresh: () {
          Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                  pageBuilder: (a, b, c) => const Roles(),
                  transitionDuration: const Duration(seconds: 0)));
          // ignore: void_checks
          return Future.value(false);
        },
        child: SingleChildScrollView(
          child: Column(children: [
            Padding(
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
                                      style: const TextStyle(fontSize: 18.0))),
                            ),
                            TableCell(
                                child: Column(
                              children: [
                                for (var j = 0;
                                    j < userTechList[i]['acces'].length;
                                    j++) ...[
                                  Card(
                                    child: ListTile(
                                      title: Text(userTechList[i]['acces'][j]),
                                      trailing: IconButton(
                                        onPressed: () {
                                          List listest =
                                              userTechList[i]['acces'];
                                          listest.removeAt(j);
                                          User().updateRoleUser(
                                              userTechList[i]['email'],
                                              userTechList[i]['mot de passe'],
                                              userTechList[i]['role'],
                                              userTechList[i]['image'],
                                              listest,
                                              userTechList[i]['name']);
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
                                  margin: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color.fromARGB(
                                            255, 221, 196, 158),
                                        width: 3),
                                    borderRadius: BorderRadius.circular(18),
                                    color: Colors.indigo,
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => AjoutRole(
                                                    name: userTechList[i]
                                                        ['name'],
                                                    email: userTechList[i]
                                                        ['email'],
                                                    image: userTechList[i]
                                                        ['image'],
                                                    role: userTechList[i]
                                                        ['role'],
                                                    mp: userTechList[i]
                                                        ['mot de passe'],
                                                    acces: userTechList[i]
                                                        ['acces'],
                                                  )));
                                    },
                                    child: const Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
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
                                      style: const TextStyle(fontSize: 18.0))),
                            ),
                            TableCell(
                                child: Column(
                              children: [
                                for (var j = 0;
                                    j < userCompList[i]['acces'].length;
                                    j++) ...[
                                  Card(
                                    child: ListTile(
                                      title: Text(userCompList[i]['acces'][j]),
                                      trailing: IconButton(
                                        onPressed: () {
                                          List listest =
                                              userCompList[i]['acces'];
                                          listest.removeAt(j);
                                          User().updateRoleUser(
                                              userCompList[i]['email'],
                                              userCompList[i]['mot de passe'],
                                              userCompList[i]['role'],
                                              userCompList[i]['image'],
                                              listest,
                                              userCompList[i]['name']);
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
                                  margin: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color.fromARGB(
                                            255, 221, 196, 158),
                                        width: 3),
                                    borderRadius: BorderRadius.circular(18),
                                    color: Colors.indigo,
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => AjoutRole(
                                                    name: userCompList[i]
                                                        ['name'],
                                                    email: userCompList[i]
                                                        ['email'],
                                                    image: userCompList[i]
                                                        ['image'],
                                                    role: userCompList[i]
                                                        ['role'],
                                                    mp: userCompList[i]
                                                        ['mot de passe'],
                                                    acces: userCompList[i]
                                                        ['acces'],
                                                  )));
                                    },
                                    child: const Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
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
                                      style: const TextStyle(fontSize: 18.0))),
                            ),
                            TableCell(
                                child: Column(
                              children: [
                                for (var j = 0;
                                    j < userProfilesList[i]['acces'].length;
                                    j++) ...[
                                  Card(
                                    child: ListTile(
                                      title:
                                          Text(userProfilesList[i]['acces'][j]),
                                      trailing: IconButton(
                                        onPressed: () {
                                          List listest =
                                              userProfilesList[i]['acces'];
                                          listest.removeAt(j);
                                          User().updateRoleUser(
                                              userProfilesList[i]['email'],
                                              userProfilesList[i]
                                                  ['mot de passe'],
                                              userProfilesList[i]['role'],
                                              userProfilesList[i]['image'],
                                              listest,
                                              userProfilesList[i]['name']);
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
                                  margin: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color.fromARGB(
                                            255, 221, 196, 158),
                                        width: 3),
                                    borderRadius: BorderRadius.circular(18),
                                    color: Colors.indigo,
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => AjoutRole(
                                                    name: userProfilesList[i]
                                                        ['name'],
                                                    email: userProfilesList[i]
                                                        ['email'],
                                                    image: userProfilesList[i]
                                                        ['image'],
                                                    role: userProfilesList[i]
                                                        ['role'],
                                                    mp: userProfilesList[i]
                                                        ['mot de passe'],
                                                    acces: userProfilesList[i]
                                                        ['acces'],
                                                  )));
                                    },
                                    child: const Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
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
    );
  }
}
