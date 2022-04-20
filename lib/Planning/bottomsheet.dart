// ignore_for_file: sized_box_for_whitespace, unnecessary_brace_in_string_interps

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

bottomSheet(BuildContext context, List selectedItems) {
  DateTime dateTimeStart = DateTime.now();
  TextEditingController subjectController = TextEditingController();
  DateTime dateTimeEnd = DateTime.now();
  bool dateTimeStartSelected = false;
  bool dateTimeEndSelected = false;
  bool isLoading = false;
  bool isDone = false;
  String hint = "Client";
  Size size = MediaQuery.of(context).size;
  showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20), topLeft: Radius.circular(20)),
      ),
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return Container(
            color: Colors.transparent,
            child: Container(
              height: size.height * 0.85,
              decoration: BoxDecoration(
                  color: const Color(0xffe3eaef),
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.07, vertical: 50),
                child: isDone
                    ? doneAddPlanning(size)
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Text("Ajouter un plan de travaille  "),
                          TextFormField(
                            controller: subjectController,
                            decoration: InputDecoration(
                                label: const Text("Sujet de plan"),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20))),
                          ),
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('contacts')
                                .where("type", isEqualTo: "client")
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                List contacts = snapshot.data!.docs.toList();
                                List<String> items = [];
                                for (var contact in contacts) {
                                  items.add(contact.get("name"));
                                }
                                return Container(
                                  height: 60,
                                  width: 188,
                                  child: InputDecorator(
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor:
                                            Colors.blueAccent.withOpacity(0.3),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                      ),
                                      child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                        hint: Text(hint),
                                        onChanged: (value) {
                                          setState(() {
                                            hint = value!;
                                          });
                                        },
                                        items: items.map((String conetnt) {
                                          return DropdownMenuItem(
                                              value: conetnt,
                                              child: Text(" ${conetnt}"));
                                        }).toList(),
                                      ))),
                                );
                              } else {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Date de debut de plan"),
                              SizedBox(
                                width: size.width * 0.03,
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(2022),
                                            lastDate: DateTime(2023))
                                        .then((value) {
                                      setState(() {
                                        dateTimeStart = value!;
                                        dateTimeStartSelected = true;
                                      });
                                    });
                                  },
                                  child: Text(DateFormat('yyyy-MM-dd')
                                      .format(dateTimeStart))),
                              SizedBox(
                                width: size.width * 0.01,
                              ),
                              if (dateTimeStartSelected) ...[
                                ElevatedButton(
                                    onPressed: () {
                                      showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                      ).then((value) {
                                        setState(() {
                                          dateTimeStart = dateTimeStart.add(
                                              Duration(
                                                  hours: value!.hour,
                                                  minutes: value.minute));
                                        });
                                      });
                                    },
                                    child: Text(DateFormat('HH:mm')
                                        .format(dateTimeStart))),
                              ]
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Date de fin de plan"),
                              SizedBox(
                                width: size.width * 0.08,
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(2022),
                                            lastDate: DateTime(2023))
                                        .then((value) {
                                      setState(() {
                                        dateTimeEnd = value!;
                                        dateTimeEndSelected = true;
                                      });
                                    });
                                  },
                                  child: Text(DateFormat('yyyy-MM-dd')
                                      .format(dateTimeEnd))),
                              SizedBox(
                                width: size.width * 0.01,
                              ),
                              if (dateTimeEndSelected) ...[
                                ElevatedButton(
                                    onPressed: () {
                                      showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                      ).then((value) {
                                        setState(() {
                                          dateTimeEnd = dateTimeEnd.add(
                                              Duration(
                                                  hours: value!.hour,
                                                  minutes: value.minute));
                                        });
                                      });
                                    },
                                    child: Text(DateFormat('HH:mm')
                                        .format(dateTimeEnd))),
                              ]
                            ],
                          ),
                          isLoading
                              ? const CircularProgressIndicator()
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.red,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          padding: const EdgeInsets.all(15),
                                        ),
                                        onPressed: () {
                                          Get.back();
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15),
                                          child: Text("Annuler"),
                                        )),
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.green,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          padding: const EdgeInsets.all(15),
                                        ),
                                        onPressed: () async {
                                          setState(() {
                                            isLoading = true;
                                          });
                                          await FirebaseFirestore.instance
                                              .collection("plan")
                                              .doc(subjectController.text)
                                              .set({
                                            'startTime': dateTimeStart,
                                            'endTime': dateTimeEnd,
                                            'subject': subjectController.text,
                                            'state': "Planifié",
                                            "owners": selectedItems,
                                            "client": hint
                                          });
                                          setState(() {
                                            isLoading = false;
                                            isDone = true;
                                          });
                                        },
                                        child: const Text("Confirmer")),
                                  ],
                                ),
                        ],
                      ),
              ),
            ),
          );
        });
      });
}

Column doneAddPlanning(Size size) {
  return Column(
    children: [
      Lottie.asset("asset/success.json",
          height: size.height * 0.2, repeat: false),
      Text(
        "Votre plan à été ajouté avec succès",
        style: TextStyle(fontSize: size.height * 0.02),
      ),
      SizedBox(
        height: size.height * 0.1,
      ),
      ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.blueAccent,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            padding: const EdgeInsets.all(15),
          ),
          onPressed: () {
            Get.back();
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Text("Sortir"),
          ))
    ],
  );
}
