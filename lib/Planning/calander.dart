import 'package:chama_projet/Planning/plan_screen.dart';
import 'package:chama_projet/widget/plan_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';

import '../pages/utils.dart';
import '../widget/NavBottom.dart';
import 'alertdialog_create_plan.dart';

var data = FirebaseFirestore.instance;

class Calander extends StatefulWidget {
  final String role;
  final String techName;
  final String username;
  final String emailus, nameus, url, roleus, adrus, telus, idus;

  final List accesus;
  Calander({
    Key? key,
    required this.techName,
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

  @override
  _CalanderState createState() => _CalanderState();
}

class _CalanderState extends State<Calander> {
  int numberEvents = 0;
  bool _isLoading = true;
  List? appointements = [];
  List plans = [];
  Widget _lowerHalf = const SizedBox();
  final CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('plan');

  EventList<Event> _markedDateMap = EventList<Event>(events: {
    DateTime(2022, 4, 10): [],
  });
  DateTime ts = DateTime(2022);
  Future<List> getData() async {
    QuerySnapshot querySnapshot = await _collectionRef.where('owners',
        arrayContainsAny: [widget.techName, widget.username]).get();
    return querySnapshot.docs.map((doc) {
      return doc;
    }).toList();
  }

  prepareData() {
    _markedDateMap = EventList<Event>(events: {
      DateTime(2022, 4, 10): [],
    });
    getData().then((value) {
      for (int i = 0; i < value.length; i++) {
        //print(value[i]['id']);
        var data = value[i].data();
        plans.add(data);
        ts = DateTime.parse(data['startTime'].toDate().toString());
        //print("${value}");
        _markedDateMap.add(
            DateTime(ts.year, ts.month, ts.day),
            Event(
                date: DateTime(ts.year, ts.month, ts.day),
                title: data['subject'],
                dot: Container(
                  height: 40,
                  width: 40,
                  color: Colors.red,
                ),
                description: value[i].id));
      }

      _isLoading = false;
      setState(() {});
    }).onError((error, stackTrace) {
      Utils.snack(context, Icons.warning,
          "Veuillez ressayer quelque choose n'a pas passer correctement");
      print("$error ---------- $stackTrace");
    });
  }

  callBack() async {
    print("i've been called from the child yay ");
    prepareData();
  }

  @override
  initState() {
    prepareData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          centerTitle: true,
          title: const Text("Plan"),
          actions: [
            if (widget.role == "Admin")
              TextButton(
                  onPressed: () async {
                    await showDialog(
                        context: context,
                        builder: (context) => AlertDialogPlan(
                              username: widget.username,
                              role: widget.role,
                              allPlans: _markedDateMap,
                              techName: widget.techName,
                              callback: callBack,
                              idus: widget.idus,
                              url: widget.url,
                              telus: widget.telus,
                              adrus: widget.adrus,
                              accesus: widget.accesus,
                              nameus: widget.nameus,
                              emailus: widget.emailus,
                              roleus: widget.roleus,
                            ));
                  },
                  child: const Text(
                    "Créer",
                    style: TextStyle(letterSpacing: 4, color: Colors.white),
                  )),
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
                    radius: 20,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text("Chargement..", style: TextStyle(fontSize: 20)),
                ],
              ))
            : SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const SizedBox(
                          width: 2,
                        ),
                        _container("Planifier", Colors.blue),
                        _container("Démarrer", Colors.orange),
                        _container("Terminer", Colors.green),
                        _container("Annuler", Colors.red),
                        const SizedBox(
                          width: 2,
                        )
                      ],
                    ),
                    _calendar(),
                    _lowerHalf,
                  ],
                ),
              ),
      ),
    );
  }

  Widget _calendar() {
    return CalendarCarousel<Event>(
      onDayPressed: (DateTime date, List<Event> events) {
        if (events.isNotEmpty) {
          print("from on pressed in calendar = > ${events[0].description}");
          var _date = events[0]
              .getDate()
              .toString()
              .substring(0, events[0].getDate().toString().indexOf(" "));
          //var _altDate = DateTime.parse(_date);
          var plan = plans.where((e) {
            var _dt = DateTime.parse(e['startTime'].toDate().toString());
            return DateTime(_dt.year, _dt.month, _dt.day) ==
                events[0].getDate();
          }).toList();
          //print(" ++> a single event ,,,${plan[0].description}");
          setState(() {
            _lowerHalf = Stack(children: [
              PlanCard(
                  client: plan[0]['client'],
                  subject: plan[0]['subject'],
                  startTime: _date,
                  status: plan[0]['state'].toString()),
              Positioned(
                  top: 0,
                  right: 0,
                  child: FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PlanScreen(
                                    event: plan[0],
                                    planID: events[0].description!,
                                    role: widget.role,
                                    callBack: callBack,
                                    idus: widget.idus,
                                    url: widget.url,
                                    telus: widget.telus,
                                    adrus: widget.adrus,
                                    accesus: widget.accesus,
                                    nameus: widget.nameus,
                                    emailus: widget.emailus,
                                    roleus: widget.roleus,
                                    techName: widget.techName,
                                    username: widget.username,
                                  )));
                    },
                    child: const Icon(Icons.edit),
                  )),
            ]);
          });
        }
      },
      markedDatesMap: _markedDateMap,
      // selectedDateTime: DateTime.now(),
      height: 420,
      daysHaveCircularBorder: null,
      markedDateIconBuilder: (Event event) {
        MaterialColor statusColor = Colors.blue;
        for (var e in plans) {
          var date = DateTime.parse(e['startTime'].toDate().toString());
          var _date = DateTime(date.year, date.month, date.day);
          if (_date.compareTo(event.getDate()) == 0) {
            switch (e['state']) {
              case "Planifier":
                {
                  statusColor = Colors.blue;
                }
                break;
              case "Demarrer":
                {
                  statusColor = Colors.orange;
                }
                break;
              case "Terminer":
                {
                  statusColor = Colors.green;
                }
                break;
              case "Annuler":
                {
                  statusColor = Colors.red;
                }
                break;
            }
          }
        }

        return Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40), color: statusColor),
          height: 40,
          width: 40,
          child: Center(
              child: Text(
            event.getDate().day.toString(),
            style: const TextStyle(color: Colors.white),
          )),
        );
      },
      todayButtonColor: Colors.deepPurpleAccent,
    );
  }

  Widget _container(String t, MaterialColor c) {
    return Container(
      decoration:
          BoxDecoration(color: c, borderRadius: BorderRadius.circular(5)),
      child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 10),
          child: Text(t, style: const TextStyle(color: Colors.white))),
    );
  }
}
