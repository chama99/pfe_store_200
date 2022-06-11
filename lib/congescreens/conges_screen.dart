import 'package:chama_projet/services/firebase_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../widget/calendar_widget/calendar_view.dart';
import '../pages/utils.dart';
import '../widget/NavBottom.dart';
import 'conge_screen.dart';
import 'demande_conge_screen.dart';

class CongesScreen extends StatefulWidget {
  final String role;
  final String userID;
  final String emailus, nameus, url, roleus, adrus, telus, idus;

  final List accesus;
  const CongesScreen({
    Key? key,
    required this.role,
    required this.userID,
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
  State<CongesScreen> createState() => _CongesScreenState();
}

class _CongesScreenState extends State<CongesScreen> {
  bool _isLoading = true;
  List listOfDemandesWaitingForAction = [];
  List oldDemandes = [];
  dynamic conge;
  dynamic refusedConge;

  ///----Methods-----
  ///
  callBack() {
    _isLoading = true;
    setState(() {});
    getpaidLeaveDaysLeft();
    setState(() {});
  }

  getpaidLeaveDaysLeft() async {
    //var user = await FirebaseApi.getUser(widget.userID);
    //print(user);
    FirebaseApi.getLeaveDemandes()!.then((aux) {
      if (aux!.isNotEmpty) {
        listOfDemandesWaitingForAction = aux;
      }
      _isLoading = false;
      setState(() {});
    });
  }

  getAsyncTaskForTheRefusedConge() {
    FirebaseApi.getUserLeaveDemandedRefused(widget.userID).then((result) {
      refusedConge = result;
      return;
    });
    refusedConge = null;
  }

  getLeaveDemande(userID) {
    FirebaseApi.getLeaveDemandAccepted(userID).then((result) {
      if (result.isNotEmpty) {
        print("========$result");
        conge = result.first.data();
      } else {
        _isLoading = false;
        conge = null;
      }
      setState(() {});
      //print("--------------------------${result.first.data()}");
    });
  }

  @override
  void initState() {
    getAsyncTaskForTheRefusedConge();
    getpaidLeaveDaysLeft();
    getLeaveDemande(widget.userID);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          //centerTitle: true,
          title: const Text("Congé"),
          actions: <Widget>[
            widget.role.toLowerCase() == "technicien" ||
                    widget.role.toLowerCase() == "comptable"
                ? Padding(
                    padding: const EdgeInsets.only(top: 20, right: 30),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DemandeCongeScreen(
                                      userID: widget.userID,
                                      callBack: callBack,
                                      idus: widget.idus,
                                      url: widget.url,
                                      telus: widget.telus,
                                      adrus: widget.adrus,
                                      accesus: widget.accesus,
                                      nameus: widget.nameus,
                                      emailus: widget.emailus,
                                      roleus: widget.roleus,
                                      role: widget.role,
                                    )));
                      },
                      child: const Text(
                        "Demander",
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            letterSpacing: 3),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  )
                : const SizedBox(),
          ],
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
            ? Center(
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CupertinoActivityIndicator(
                    color: Colors.orange,
                  ),
                ],
              ))
            : SingleChildScrollView(
                child: widget.role.toLowerCase() == "technicien" ||
                        widget.role.toLowerCase() == "comptable"
                    ? _widgetForUser()
                    // ignore: todo
                    : _widgetForAdmin())); //TODO GET THIS BACK to Technicien
  }

  Widget _widgetForUser() => Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(children: [
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _container("Jours de congé", Color(0xff54D3C2)),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            conge != null
                ? SizedBox(
                    height: 400,
                    child: CalendarPopupView(
                      // color: conge["leaveType"] == "paid" ? const Color(0xff54D3C2) : Colors.orangeAccent ,

                      initialStartDate: conge["beginDateOfTheHoliday"].toDate(),
                      initialEndDate: conge["beginDateOfTheHoliday"]
                          .toDate()
                          .add(Duration(days: int.parse(conge["duration"]))),
                    ))
                : const SizedBox(height: 400, child: CalendarPopupView()),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: refusedConge.length,
                  itemBuilder: (context, position) {
                    if (refusedConge.isNotEmpty) {
                      return Card(
                          child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.close,
                                    color: Colors.redAccent,
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Flexible(
                                    child: Text(
                                      " Le congé demander pour le ${Utils.toReadableDate(refusedConge[position]['beginDateOfTheHoliday'])} a été refuser ",
                                      style: const TextStyle(fontSize: 22.0),
                                    ),
                                  )
                                ],
                              )));
                    } else {
                      return const SizedBox();
                    }
                  }),
            ),
          ]),
        ),
      );
  Widget _widgetForAdmin() => Container(
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Text(
            'Vous avez nouvelles ${listOfDemandesWaitingForAction.length} demande ',
            style: const TextStyle(color: Colors.blueGrey, fontSize: 20),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: listOfDemandesWaitingForAction.length,
              itemBuilder: (context, position) {
                final singleDemand = listOfDemandesWaitingForAction[position];
                print("===========${singleDemand}");
                return GestureDetector(
                    onTap: () => Get.to(() => CongeScreen(
                          singleConge: singleDemand,
                          idus: widget.idus,
                          url: widget.url,
                          telus: widget.telus,
                          adrus: widget.adrus,
                          accesus: widget.accesus,
                          nameus: widget.nameus,
                          emailus: widget.emailus,
                          roleus: widget.role,
                          role: widget.role,
                          userID: widget.userID,
                        )),
                    child: Card(
                      child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Text(
                                listOfDemandesWaitingForAction[position]
                                    ["username"],
                                style: const TextStyle(fontSize: 22.0),
                              ),
                              const Spacer(),
                              listOfDemandesWaitingForAction[position]
                                          ["status"] ==
                                      "waiting"
                                  ? const Icon(
                                      Icons.hourglass_bottom_rounded,
                                      color: Colors.blueAccent,
                                    )
                                  : listOfDemandesWaitingForAction[position]
                                              ["status"] ==
                                          "refused"
                                      ? const Icon(Icons.close,
                                          color: Colors.redAccent)
                                      : const Icon(
                                          Icons.check,
                                          color: Colors.greenAccent,
                                        )
                            ],
                          )),
                    ));
              },
            ),
          ),
        ],
      ));

  Widget _container(String t, Color c) {
    return Container(
      width: MediaQuery.of(context).size.width * .5,
      decoration:
          BoxDecoration(color: c, borderRadius: BorderRadius.circular(5)),
      child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 10),
          child: Center(
              child: Text(t,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)))),
    );
  }
}
