import 'package:chama_projet/Planning/calander.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../widget/drop_down.dart';

class AlertDialogPlan extends StatefulWidget {
  final EventList<Event> allPlans;
  final String techName, username, role;
  const AlertDialogPlan(
      {Key? key,
      required this.allPlans,
      required this.techName,
      required this.callback,
      required this.username,
      required this.role})
      : super(key: key);
  final VoidCallback callback;
  @override
  State<AlertDialogPlan> createState() => _AlertDialogPlanState();
}

class _AlertDialogPlanState extends State<AlertDialogPlan> {
  Widget _buttonWidget = const Text("Sauvgarder");
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

  void sauvgardePlan() {
    var doesExit = widget.allPlans.getEvents(_beginDate);
    if (!_beginDate.isBefore(_endDate)) {
      modalShow("Date de début doit étre inferieur au date de fin du plan",
          success: false);
      return;
    }
    if (telephone == "") {
      modalShow("Veuillez selectionnez un client ", success: false);
      return;
    }
    if (addresse == "") {
      modalShow("Veuillez selectionnez un client ", success: false);
      return;
    }
    if (sujet.text == "") {
      modalShow("Veuillez entrer le sujet du plan", success: false);
      return;
    }
    if (doesExit.isNotEmpty) {
      modalShow("Date de début selectionner est déja prise par un autre plan",
          success: false);
      return;
    }
    setState(() {
      _buttonWidget = const SizedBox(
          width: 40,
          child: CupertinoActivityIndicator(
            color: Colors.white,
          ));
    });
    //&& &&  &&
    _planCollection.add({
      "client": clientDropDown,
      "endTime": _endDate,
      "startTime": _beginDate,
      "state": "Planifier",
      "subject": sujet.text,
      "owners": [widget.techName],
      "time": heure
    }).then((_) {
      widget.callback();
      setState(() {
        _buttonWidget = const Text("Sauvgarder");
        modalShow("Plan ajouter avec succès");
      });
    });
    Get.to(() => Calander(
        techName: widget.techName,
        username: widget.username,
        role: widget.role));
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
    if (_loading) {
      return const CupertinoActivityIndicator();
    }
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          centerTitle: true,
          title: const Text(
            "Créer un plan",
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                  style: ElevatedButton.styleFrom(
                      primary: const Color.fromARGB(255, 62, 75, 146)),
                  onPressed: sauvgardePlan,
                  child: _buttonWidget,
                ),
              )
            ],
          ),
        ));
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

    setState(() {
      if (b) {
        _beginDate = picked!;
      } else {
        _endDate = picked!;
      }
    });
  }

  modalShow(String text, {bool success = true}) async {
    return await showDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
              title: success
                  ? Lottie.asset("asset/success.json",
                      height: MediaQuery.of(context).size.height * 0.08,
                      repeat: false)
                  : const Icon(Icons.close,
                      color: Colors.red), //const Text("Succès"),
              content: Column(
                children: [
                  Text(text),
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
  }

  Widget cTextFeild(String text, TextEditingController ctrl) {
    return TextField(
      // readOnly: t,
      controller: ctrl,
      decoration: InputDecoration(hintText: text),
    );
  }
}
