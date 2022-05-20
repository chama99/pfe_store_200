import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'calander.dart';

var data = FirebaseFirestore.instance;

class MultiSelection extends StatefulWidget {
  final String role;
  const MultiSelection({Key? key, required this.role}) : super(key: key);

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

// Future getData() async {
//     QuerySnapshot querySnapshot = await _collectionRef
//         //.where('owners', arrayContainsAny: [widget.techName])
//         .get();
//     return querySnapshot.docs.map((doc) => doc.data()).toList();
//   }
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
        title: const Text("Planing des Technicien"),
      ),
      body: _isLoading
          ? Center(
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CupertinoActivityIndicator(
                  radius: 20,
                ),
                SizedBox(
                  height: 8,
                ),
                Text("Chargement..", style: TextStyle(fontSize: 20)),
              ],
            ))
          : Column(
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
                Visibility(
                  visible: isMultiSelectionEnabled,
                  child: SizedBox(
                    height: 70,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                if (isMultiSelectionEnabled) {
                                  doMultiSelection(listTechs[index][0]);
                                } else {
                                  Get.to(Calander(
                                      username: listTechs[index]['email'],
                                      techName: listTechs[index]['name'],
                                      role: widget.role));
                                }
                              },
                              onLongPress: () {
                                isMultiSelectionEnabled = true;
                                doMultiSelection(listTechs[index][0]);
                              },
                              child: Stack(
                                alignment: Alignment.centerRight,
                                children: [
                                  Container(
                                      height: 100,
                                      decoration: BoxDecoration(
                                          color: Colors.green.withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  "${listTechs[index]['image']}"),
                                              radius: 40,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              listTechs[index]["email"],
                                            ),
                                          ],
                                        ),
                                      )),
                                  Visibility(
                                      visible: isMultiSelectionEnabled,
                                      child: Icon(
                                        selectedItems
                                                .contains(listTechs[index][0])
                                            ? Icons.check_circle
                                            : Icons.radio_button_unchecked,
                                        size: 30,
                                        color: Colors.green,
                                      ))
                                ],
                              ),
                            ),
                          );
                        }))
              ],
            ),
    ));
  }

  // void filterSearchResults(String query) {
  //   if (editingController.text == "") {
  //     setState(() => listTechs = backUpListTechs);
  //   } else {
  //     backUpListTechs = listTechs;
  //     final suggestions = listTechs.where((employe) {
  //       final String namemploye = employe['name'].toLowerCase();
  //       final String input = query.toLowerCase();
  //       return namemploye.startsWith(input);
  //     }).toList();
  //     setState(() {
  //       listTechs = suggestions;
  //     });
  //   }
  // }

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
