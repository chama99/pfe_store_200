import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';

import 'package:intl/intl.dart';

import '../pages/utils.dart';
import '../widget/NavBottom.dart';
import '../widget/drop_down.dart';

class AlertDialogPlan extends StatefulWidget {
  final EventList<Event> allPlans;
  final String techName, username, role;
  final String emailus, nameus, url, roleus, adrus, telus, idus;

  final List accesus;
  const AlertDialogPlan({
    Key? key,
    required this.allPlans,
    required this.techName,
    required this.callback,
    required this.username,
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
  final VoidCallback callback;
  @override
  State<AlertDialogPlan> createState() => _AlertDialogPlanState();
}

class _AlertDialogPlanState extends State<AlertDialogPlan> {
  Widget _buttonWidget = const Text("Sauvgarder");
  bool _loading = true;
  final CollectionReference _contactsCollection =
      FirebaseFirestore.instance.collection('clients');

  final CollectionReference _planCollection =
      FirebaseFirestore.instance.collection('plan');

  final DocumentReference _planRefrence =
      FirebaseFirestore.instance.collection("plan").doc();
  List<String> clients = ["Choissiez un client"];
  List<dynamic> users = [];
  Future getData() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _contactsCollection.get();

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

  DateTime _beginDate = Utils.formatDateToCalculate(DateTime.now());
  DateTime _endDate =
      Utils.formatDateToCalculate(DateTime.now().add(const Duration(days: 1)));

  String heure = "09:00 - 16:00";
  String clientDropDown = "Choissiez un client";

  @override
  void initState() {
    getData().then((client) {
      for (int i = 0; i < client.length; i++) {
        clients.add(client[i]["name"]);
        users.add(client[i]);
      }

      heure = timeList[0];
      setState(() {
        _loading = false;
      });
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

  Widget cTextFeild(String text, TextEditingController ctrl) {
    return TextField(
      // readOnly: t,
      controller: ctrl,
      decoration: InputDecoration(hintText: text),
    );
  }

  void sauvgardePlan() {
    var doesExit = widget.allPlans.getEvents(_beginDate);

    DateTime now = Utils.formatDateToCalculate(DateTime.now());
    bool isValidDate = _beginDate.isBefore(now) || _endDate.isBefore(now);

    if (isValidDate) {
      Utils.modalShow("Un congé ne peut pas etre au passé", context,
          success: false);
      return;
    }
    if ((_beginDate.isBefore(now) && _endDate.isAfter(now))) {
      Utils.modalShow("Veuillez remplir la description", context,
          success: false);
      return;
    }

    if (telephone == "") {
      Utils.modalShow("Veuillez selectionnez un client ", context,
          success: false);
      return;
    }

    if (addresse == "") {
      Utils.modalShow("Veuillez selectionnez un client ", context,
          success: false);
      return;
    }

    if (sujet.text == "") {
      Utils.modalShow("Veuillez entrer le sujet du plan", context,
          success: false);
      return;
    }

    if (doesExit.isNotEmpty) {
      Utils.modalShow(
          "Date de début selectionner est déja prise par un autre plan",
          context,
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
      setState(() {
        _buttonWidget = const Text("Sauvgarder");
      });
      Utils.modalShow("Plan ajouter avec succès", context);
      widget.callback();
      Navigator.pop(context);
    }).onError((error, stackTrace) {
      print("$error ---- $stackTrace");
    });
    // Get.to(() => Calander(
    //     techName: widget.techName,
    //     username: widget.username,
    //     role: widget.role));
  }
}
