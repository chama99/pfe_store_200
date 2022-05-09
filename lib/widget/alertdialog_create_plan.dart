import 'package:chama_projet/widget/InputDeco_design.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import 'drop_down.dart';

class AlertDialogPlan extends StatefulWidget {
  const AlertDialogPlan({Key? key}) : super(key: key);

  @override
  State<AlertDialogPlan> createState() => _AlertDialogPlanState();
}

class _AlertDialogPlanState extends State<AlertDialogPlan> {
  Widget _buttonWidget = Text("Sauvgarder");
  bool _loading = true;
  final CollectionReference _contactsCollection =
      FirebaseFirestore.instance.collection('contacts');

  final CollectionReference _planCollection =
      FirebaseFirestore.instance.collection('plan');

  final DocumentReference _planRefrence =
      FirebaseFirestore.instance.collection("plan").doc();
  List<String> clients = ["Choissiez un client"];
  List<dynamic> users = [];
  Future getData() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot =
        await _contactsCollection.where('type', isEqualTo: "client").get();

    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  final List<String> timeList = const [
    "09:00 - 16:00",
    "09:00 - 19:00",
    "08:00 - 17:00",
    "07:00 - 15:00",
  ];

  TextEditingController sujet = TextEditingController();
  String telephone = "";
  String addresse = "";

  DateTime _beginDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 1));

  String heure = "09:00 - 16:00";
  String clientDropDown = "Choissiez un client";

  //String formattedDate = DateFormat('yyyy - MM - dd').format();

  void sauvgardePlan() {
    setState(() {
      _buttonWidget = const CupertinoActivityIndicator(
        color: Colors.white,
      );
    });
    if (_beginDate.isBefore(_endDate) && telephone != "" && addresse != "") {
      _planCollection.add({
        "client": clientDropDown,
        "endTime": _endDate,
        "startTime": _beginDate,
        "state": "Planifiée",
        "subject": sujet.text
      }).then((_) {
        showDialog(
            context: context,
            builder: (_) => CupertinoAlertDialog(
                  title: const Text("Succès"),
                  content: Column(
                    children: [
                      Lottie.asset("asset/success.json",
                          height: MediaQuery.of(context).size.height * 0.08,
                          repeat: false),
                      const Text("données sauvegardées avec succès"),
                    ],
                  ),
                  actions: <Widget>[
                    CupertinoDialogAction(
                      onPressed: () => Navigator.of(context).pop(),
                      isDefaultAction: true,
                      child: const Text("D'accord"),
                    ),
                  ],
                ));
        setState(() {
          _buttonWidget = const Text("Sauvgarder");
        });
      });
    }
  }

  @override
  void initState() {
    getData().then((client) {
      for (int i = 0; i < client.length; i++) {
        clients.add(client[i]["name"]);
        users.add(client[i]);
      }
      setState(() {
        _loading = false;
      });
      heure = timeList[0];
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        insetPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        contentPadding: const EdgeInsets.all(10),
        scrollable: true,
        content: Builder(builder: (context) {
          if (_loading) {
            return const CupertinoActivityIndicator();
          }
          return SizedBox(
            width: MediaQuery.of(context).size.width - 50,
            height: MediaQuery.of(context).size.height - 160,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.add),
                    Text("Créer un plan", textAlign: TextAlign.center),
                  ],
                ),
                const Divider(),
                Row(children: [
                  const Text(
                    "Sujet du plan : ",
                  ),
                  const Spacer(),
                  Expanded(flex: 3, child: cTextFeild("Sujet ", sujet)),
                ]),
                const SizedBox(
                  height: 10,
                ),
                Row(children: [
                  const Text(
                    "Heure : ",
                  ),
                  const Spacer(),
                  Expanded(
                      flex: 2,
                      child: dropDown(timeList, oneItem: heure, b: true)),
                ]),
                Row(children: [
                  const Text("Date de début : "),
                  const Spacer(),
                  ElevatedButton(
                    // style: ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith(),
                    style: ElevatedButton.styleFrom(primary: Colors.orange),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_month,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(DateFormat("yyyy - MM - dd").format(_beginDate),
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white)),
                      ],
                    ),
                    onPressed: () {
                      _selectDate(context, true);
                    },
                  ),
                ]),
                Row(children: [
                  const Text("Date du fin: "),
                  const Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.orange),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_month,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(DateFormat("yyyy - MM - dd").format(_endDate),
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white)),
                      ],
                    ),
                    onPressed: () {
                      _selectDate(context, false);
                    },
                  ),
                ]),
                Row(children: [
                  const Text(
                    "Client : ",
                  ),
                  const Spacer(),
                  Expanded(
                      flex: 2,
                      child:
                          dropDown(clients, oneItem: clientDropDown, b: false)),
                ]),
                const SizedBox(
                  height: 16,
                ),
                Row(children: [
                  const Text(
                    "Telephone : ",
                  ),
                  Expanded(flex: 2, child: Text(telephone)),
                ]),
                const SizedBox(
                  height: 20,
                ),
                Row(children: [
                  const Text(
                    "Addresse : ",
                  ),
                  Expanded(flex: 2, child: Text(addresse)),
                ]),
                const Spacer(),
                const Divider(
                  thickness: 4,
                ),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.green),
                    onPressed: sauvgardePlan,
                    child: _buttonWidget,
                  ),
                )
              ],
            ),
          );
        }));
  }

  Widget dropDown(List<String> items,
      {String oneItem = "Choissiez un client", bool? b}) {
    return AppDropdownInput<String>(
      options: items,
      value: oneItem,
      onChanged: (String? value) {
        if (b!) {
          setState(() {
            heure = value!;
          });
        } else {
          var user = users.where(((e) => e["name"] == value)).toList();
          if (user.isNotEmpty) {
            setState(() {
              clientDropDown = value!;
              telephone = user[0]["portable professionnel"];
              addresse = user[0]["Adresse professionnelle"];
            });
          }
        }
      },
      getLabel: (String value) => value,
    );
  }

  Future<void> _selectDate(BuildContext context, bool b) async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _beginDate,
        firstDate: DateTime(2022, 1),
        lastDate: DateTime(2023));
    print(picked);

    setState(() {
      if (b) {
        _beginDate = picked!;
      } else {
        _endDate = picked!;
      }
    });
    print(_endDate);
    print(_beginDate);
  }

  Widget cTextFeild(String text, TextEditingController ctrl) {
    return TextField(
      // readOnly: t,
      controller: ctrl,
      decoration: InputDecoration(hintText: text),
    );
  }
}
