// ignore_for_file: must_be_immutable, unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widget/NavBottom.dart';
import 'calander.dart';

var data = FirebaseFirestore.instance;

class MultiSelection extends StatefulWidget {
  final String role;
  String emailus, nameus, url, roleus, adrus, telus, idus;

  List accesus;
  MultiSelection({
    Key? key,
    required this.role,
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
  _MultiSelectionState createState() => _MultiSelectionState();
}

class _MultiSelectionState extends State<MultiSelection> {
  TextEditingController editingController = TextEditingController();
  List listTechs = [];
  List selectedItems = [];
  bool isMultiSelectionEnabled = false;
  List backUpListTechs = [];
  List employees = [];

  List object = [];
  bool _isLoading = true;
  String getSelectedItemCount() {
    return selectedItems.isNotEmpty
        ? selectedItems.length.toString() + " technecien selectionné"
        : "aucune technecien  ";
  }

  fetchDatabaseList() async {
    QuerySnapshot resultant = await data
        .collection('users')
        .where("role", isEqualTo: "Technicien")
        .get();
    var techs = resultant.docs.map((doc) => doc.data()).toList();
    //print(techs);

    if (techs == null) {
      // ignore: avoid_print
      setState(() {
        _isLoading = false;
      });
      print('Unable to retrieve');
    } else {
      setState(() {
        listTechs = techs;
        backUpListTechs = techs;
        _isLoading = false;
      });
    }
  }

  @override
  initState() {
    fetchDatabaseList();
    super.initState();
  }

  void doMultiSelection(String contactModel) {
    if (isMultiSelectionEnabled) {
      if (selectedItems.contains(contactModel)) {
        selectedItems.remove(contactModel);
      } else {
        selectedItems.add(contactModel);
      }
      setState(() {});
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.orange,
              centerTitle: true,
              title: const Text("Les  techniciens"),
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
            body: _isLoading
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
                            pageBuilder: (a, b, c) => MultiSelection(
                              accesus: widget.accesus,
                              emailus: widget.emailus,
                              url: widget.url,
                              roleus: widget.roleus,
                              telus: widget.telus,
                              nameus: widget.nameus,
                              idus: widget.idus,
                              role: widget.role,
                              adrus: widget.adrus,
                            ),
                            transitionDuration: const Duration(seconds: 0),
                          ));
                      // ignore: void_checks
                      return Future.value(false);
                    },
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextField(
                              onChanged: _runFilter,
                              controller: editingController,
                              decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide: const BorderSide(
                                        color: Colors.orange, width: 1.5),
                                  ),
                                  labelText: "recherche",
                                  labelStyle: const TextStyle(
                                      fontSize: 20.0,
                                      color:
                                          Color.fromARGB(255, 102, 102, 102)),
                                  prefixIcon: const Icon(
                                    Icons.search,
                                    color: Colors.orange,
                                  ),
                                  border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25.0)),
                                  )),
                            ),
                          ),
                          Visibility(
                            visible: isMultiSelectionEnabled,
                            child: SizedBox(
                              height: 70,
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        selectedItems.clear();
                                        isMultiSelectionEnabled = false;
                                        setState(() {});
                                      },
                                      icon: const Icon(Icons.close)),
                                  Text(
                                    getSelectedItemCount(),
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  ElevatedButton.icon(
                                      onPressed: () {
                                        Get.to(AddPlanning(
                                          selectedItems: selectedItems,
                                        ));

                                        setState(() {
                                          isMultiSelectionEnabled = false;
                                        });
                                      },
                                      label: Text("Plan"),
                                      icon: const Icon(
                                        Icons.add,
                                      )),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                              child: ListView.builder(
                                  itemCount: listTechs.length,
                                  itemBuilder: (context, index) {
                                    final user = listTechs[index];
                                    return Card(
                                        child: InkWell(
                                      onTap: () {
                                        if (isMultiSelectionEnabled) {
                                          doMultiSelection(listTechs[index][0]);
                                        } else {
                                          Get.to(Calander(
                                            username: listTechs[index]['email'],
                                            techName: listTechs[index]['name'],
                                            role: widget.role,
                                            idus: widget.idus,
                                            url: widget.url,
                                            telus: widget.telus,
                                            adrus: widget.adrus,
                                            accesus: widget.accesus,
                                            nameus: widget.nameus,
                                            emailus: widget.emailus,
                                            roleus: widget.roleus,
                                          ));
                                        }
                                      },
                                      splashColor:
                                          const Color.fromARGB(255, 3, 56, 109),
                                      child: ListTile(
                                        title: Text(user["name"]),
                                        subtitle: Text(user["email"]),
                                        leading: CircleAvatar(
                                          radius: 20.0,
                                          backgroundImage:
                                              NetworkImage(user['image']),
                                        ),
                                      ),
                                    ));
                                  }))
                        ],
                      ),
                    ),
                  )));
  }

  void _runFilter(String enteredKeyword) {
    List<Object?> results = [];
    if (enteredKeyword.isEmpty) {
      results = backUpListTechs;
    } else {
      results = listTechs.where((employe) {
        final String namemploye = employe['name'].toLowerCase();
        final String input = enteredKeyword.toLowerCase();
        return namemploye.startsWith(input);
      }).toList();
    }

    // Refresh the UI
    setState(() {
      listTechs = results;
    });
    print("=>>>>>>$listTechs");
  }
}

AddPlanning({required List selectedItems}) {}
