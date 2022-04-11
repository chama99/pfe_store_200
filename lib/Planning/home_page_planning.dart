import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'add_planning.dart';
import 'calander.dart';

var data = FirebaseFirestore.instance;

class MultiSelection extends StatefulWidget {
  const MultiSelection({Key? key}) : super(key: key);

  @override
  _MultiSelectionState createState() => _MultiSelectionState();
}

class _MultiSelectionState extends State<MultiSelection> {
  List selectedItems = [];
  bool isMultiSelectionEnabled = false;
  String getSelectedItemCount() {
    return selectedItems.isNotEmpty
        ? selectedItems.length.toString() + " technecien selectionné"
        : "aucune technecien  ";
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
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Planing des Technicien"),
      ),
      body: Column(
        children: [
          Visibility(
            visible: isMultiSelectionEnabled,
            child: Container(
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
                      icon: Icon(Icons.close)),
                  Text(
                    "${getSelectedItemCount()}",
                    style: TextStyle(fontSize: 16),
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
            child: StreamBuilder<QuerySnapshot>(
                stream: data
                    .collection('employes')
                    .where("role", isEqualTo: "Technecien")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List list = [];
                    List employees = snapshot.data!.docs.toList();

                    for (var employee in employees) {
                      List object = [];
                      object.add(employee.reference.id);
                      object.add(employee.get("image"));
                      list.add(object);
                    }

                    return ListView.builder(
                        itemCount: employees.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                if (isMultiSelectionEnabled) {
                                  doMultiSelection(list[index][0]);
                                } else
                                  Get.to(Calander(
                                    techName: list[index][0],
                                  ));
                              },
                              onLongPress: () {
                                isMultiSelectionEnabled = true;
                                doMultiSelection(list[index][0]);
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
                                      child: Container(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    "${list[index][1]}"),
                                                radius: 40,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                list[index][0],
                                                style: TextStyle(fontSize: 25),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )),
                                  Visibility(
                                      visible: isMultiSelectionEnabled,
                                      child: Icon(
                                        selectedItems.contains(list[index][0])
                                            ? Icons.check_circle
                                            : Icons.radio_button_unchecked,
                                        size: 30,
                                        color: Colors.green,
                                      ))
                                ],
                              ),
                            ),
                          );
                        });
                  }
                  return Center(child: CircularProgressIndicator());
                }),
          ),
        ],
      ),
    ));
  }
}
