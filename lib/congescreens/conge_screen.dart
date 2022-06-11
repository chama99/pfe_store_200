// ignore_for_file: must_be_immutable

import 'package:chama_projet/services/firebase_api.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../pages/utils.dart';
import '../widget/NavBottom.dart';
import 'conges_screen.dart';

class CongeScreen extends StatefulWidget {
  final dynamic singleConge;
  String emailus, nameus, url, roleus, adrus, telus, idus;
  final String role;
  final String userID;
  List accesus;
  CongeScreen(
      {required this.singleConge,
      required this.idus,
      required this.url,
      required this.emailus,
      required this.nameus,
      required this.roleus,
      required this.accesus,
      required this.telus,
      required this.adrus,
      required this.role,
      required this.userID,
      Key? key})
      : super(key: key);

  @override
  State<CongeScreen> createState() => _CongeScreenState();
}

class _CongeScreenState extends State<CongeScreen> {
  String status = "";
  DateTime _endDate = DateTime.now();
  //bool _isLoading = true;
  final TextStyle _leftTextStyle =
      const TextStyle(fontWeight: FontWeight.w500, fontSize: 18);
  final TextStyle _rightTextStyle = const TextStyle(
      color: Colors.blueGrey, fontWeight: FontWeight.w500, fontSize: 16);
  List<bool> buttonsState = [true, true];

  @override
  void initState() {
    status = widget.singleConge['status'];
    if (status != "waiting") {
      buttonsState = [false, false];
    }
    super.initState();
    _endDate = DateTime.parse(
            widget.singleConge["beginDateOfTheHoliday"].toDate().toString())
        .add(Duration(days: int.parse(widget.singleConge["duration"])));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          //centerTitle: true,
          title: const Text("Congé"),
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
          height: MediaQuery.of(context).size.height * .7,
          padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(children: [
                  const Text("description du congé: ",
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
                  const Spacer(),
                  Text(widget.singleConge["description"],
                      style: _rightTextStyle),
                ]),
                Row(children: [
                  const Text("Durée : ",
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
                  const Spacer(),
                  Text("${widget.singleConge["duration"]} jours",
                      style: _rightTextStyle),
                ]),
                Row(children: [
                  Text("Statue : ", style: _leftTextStyle),
                  const Spacer(),
                  Icon(
                      widget.singleConge["status"] == "waiting"
                          ? Icons.hourglass_full_rounded
                          : widget.singleConge["status"] == "refused"
                              ? Icons.close
                              : Icons.check,
                      color: widget.singleConge["status"] == "waiting"
                          ? Colors.orangeAccent
                          : widget.singleConge["status"] == "refused"
                              ? Colors.redAccent
                              : Colors.greenAccent),
                ]),
                Row(children: [
                  const Text("Proposer par l'utilisateur: ",
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
                  const Spacer(),
                  Flexible(
                    flex: 2,
                    child: Text(
                        Utils.capitalizeFirstLetter(
                            widget.singleConge["username"]),
                        style: _rightTextStyle),
                  )
                ]),
                Row(children: [
                  Text("Date de début : ", style: _leftTextStyle),
                  const Spacer(),
                  Text(
                      Utils.toReadableDate(widget
                          .singleConge["beginDateOfTheHoliday"]
                          .toDate()
                          .toString()),
                      style: _rightTextStyle),
                ]),
                Row(children: [
                  Text("Date de fin : ", style: _leftTextStyle),
                  const Spacer(),
                  Text(Utils.toReadableDate(_endDate), style: _rightTextStyle),
                ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: buttonsState[0] ? Colors.green : Colors.grey,
                        ),
                        onPressed: () {
                          if (!buttonsState.contains(false)) {
                            FirebaseApi.updateLeave(
                                    widget.singleConge["leaveID"],
                                    "accepted",
                                    widget.singleConge["leaveType"],
                                    duration: widget.singleConge['duration'],
                                    userID: widget.singleConge['userID'])
                                .then((value) {
                              print(value);
                              if (value) {
                                setState(() {
                                  buttonsState = [false, false];
                                  status = "accepted";
                                });
                              }
                            });
                          }
                          Get.to(() => CongesScreen(
                                idus: widget.idus,
                                url: widget.url,
                                emailus: widget.emailus,
                                nameus: widget.nameus,
                                roleus: widget.roleus,
                                accesus: widget.accesus,
                                telus: widget.telus,
                                adrus: widget.adrus,
                                role: '',
                                userID: '',
                              ));
                        },
                        child: Row(children: const [
                          Icon(Icons.check),
                          Text("Accepter")
                        ]),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary:
                                buttonsState[1] ? Colors.red : Colors.grey),
                        onPressed: () {
                          if (!buttonsState.contains(false)) {
                            FirebaseApi.updateLeave(
                                    widget.singleConge["leaveID"],
                                    "refused",
                                    widget.singleConge["leaveType"])
                                .then((value) {
                              setState(() {
                                buttonsState = [false, false];
                                status = "refused";
                              });
                            });
                          }
                          Get.to(() => CongesScreen(
                                idus: widget.idus,
                                url: widget.url,
                                emailus: widget.emailus,
                                nameus: widget.nameus,
                                roleus: widget.roleus,
                                accesus: widget.accesus,
                                telus: widget.telus,
                                adrus: widget.adrus,
                                role: '',
                                userID: '',
                              ));
                        },
                        child: Row(children: const [
                          Icon(Icons.close),
                          Text("Refuser")
                        ]),
                      )
                    ]),
              ]),
        ));
  }
}
