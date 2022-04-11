import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'bottomsheet.dart';
import 'details.dart';
import 'plan.dart';

var data = FirebaseFirestore.instance;

class Calander extends StatefulWidget {
  final String techName;
  const Calander({Key? key, required this.techName}) : super(key: key);

  @override
  _CalanderState createState() => _CalanderState();
}

class _CalanderState extends State<Calander> {
  late CalendarController _controller = CalendarController();
  int numberEvents = 0;
  List? appointements = [];
  @override
  void initState() {
    super.initState();
  }

  void tap(CalendarTapDetails calendarTapDetails) {
    /* final Appointment appointmentDetails = calendarTapDetails.appointments![0];
    if (appointmentDetails != []) {
      Get.to(Details(
        docId: appointmentDetails.subject,
      ));
    } else
      print("empty");*/
    /*   print(calendarTapDetails.appointments);*/
    if (_controller.view == CalendarView.week ||
        _controller.view == CalendarView.day) {
      if (!calendarTapDetails.appointments.isNull) {
        final Appointment appointmentDetails =
            calendarTapDetails.appointments![0];

        Get.to(Details(
          docId: appointmentDetails.subject,
        ));
      } else
        print("empty");
    } else {
      if (!calendarTapDetails.appointments!.isEmpty) {
        setState(() {
          numberEvents = calendarTapDetails.appointments!.length;
          appointements = calendarTapDetails.appointments;
        });
      } else
        print("empty");
      setState(() {
        numberEvents = calendarTapDetails.appointments!.length;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var view = CalendarView.week;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("plan"),
          actions: [
            PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  onTap: () {
                    _controller.view = CalendarView.day;
                    setState(() {
                      numberEvents = 0;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        alignment: Alignment.center,
                        height: 60,
                        width: 170,
                        decoration: BoxDecoration(
                            color: _controller.view == CalendarView.day
                                ? Colors.green.withOpacity(0.5)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("afficher par jour "),
                        )),
                  ),
                ),
                PopupMenuItem(
                  onTap: () {
                    _controller.view = CalendarView.week;
                    setState(() {
                      numberEvents = 0;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        alignment: Alignment.center,
                        height: 60,
                        width: 170,
                        decoration: BoxDecoration(
                            color: _controller.view == CalendarView.week
                                ? Colors.green.withOpacity(0.5)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("afficher par semaine "),
                        )),
                  ),
                ),
                PopupMenuItem(
                  onTap: () {
                    _controller.view = CalendarView.month;
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        alignment: Alignment.center,
                        height: 60,
                        width: 170,
                        decoration: BoxDecoration(
                            color: _controller.view == CalendarView.month
                                ? Colors.green.withOpacity(0.5)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(15)),
                        child: Text("afficher par mois ")),
                  ),
                ),
              ],
            )
          ],
        ),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(onPressed: () {}, child: Text("Planifié")),
                ElevatedButton(
                  onPressed: () {},
                  child: Text("Démarrer"),
                  style: ElevatedButton.styleFrom(primary: Colors.orange),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text("Terminé"),
                  style: ElevatedButton.styleFrom(primary: Colors.green),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text("Annuler"),
                  style: ElevatedButton.styleFrom(primary: Colors.red),
                ),
              ],
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: data.collection('plan').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var test = snapshot.data!.docs.toList();
                      List<Appointment> meetings = <Appointment>[];
                      Color stateColor = Colors.transparent;
                      for (var test1 in test) {
                        switch (test1.get("state")) {
                          case "Planifié":
                            {
                              stateColor = Colors.blue;
                            }
                            break;
                          case "Demarreé":
                            {
                              stateColor = Colors.orange;
                            }
                            break;
                          case "Termineé":
                            {
                              stateColor = Colors.green;
                            }
                            break;
                          case "Annuleé":
                            {
                              stateColor = Colors.red;
                            }
                            break;
                        }
                        if (test1.get("owners").contains(widget.techName)) {
                          meetings.add(Appointment(
                              startTime: test1.get("startTime").toDate(),
                              endTime: test1.get("endTime").toDate(),
                              subject: test1.reference.id,
                              color: stateColor));
                        }
                      }
                      return SfCalendar(
                        /*    monthViewSettings: MonthViewSettings(
                            appointmentDisplayMode:
                                MonthAppointmentDisplayMode.appointment),*/
                        allowAppointmentResize: true,
                        dataSource: Plan(meetings),
                        controller: _controller,
                        view: CalendarView.month,
                        onTap: tap,
                      );
                    }
                    return Center(child: CircularProgressIndicator());
                  }),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 400),
              height: numberEvents == 0 ? 0 : 300,
              child: ListView.builder(
                  itemCount: appointements!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 90,
                        decoration: BoxDecoration(
                            color: appointements![index].color.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          onTap: () {
                            setState(() {
                              numberEvents = 0;
                            });
                            Get.to(Details(
                              docId: appointements![index].subject,
                            ));
                          },
                          title: Text("${appointements![index].subject}"),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text("Date de debut : "),
                                  Text(DateFormat('yyyy-MM-dd hh:mm')
                                      .format(appointements![index].startTime)),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text("Date de fin : "),
                                  Text(DateFormat('yyyy-MM-dd hh:mm')
                                      .format(appointements![index].endTime)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              numberEvents = 0;
            });
            bottomSheet(context, [widget.techName]);
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
