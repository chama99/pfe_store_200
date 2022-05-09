import 'package:chama_projet/widget/alertdialog_create_plan.dart';
import 'package:chama_projet/widget/plan_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:intl/intl.dart';

import 'bottomsheet.dart';

var data = FirebaseFirestore.instance;

class Calander extends StatefulWidget {
  final String techName;
  const Calander({Key? key, required this.techName}) : super(key: key);

  @override
  _CalanderState createState() => _CalanderState();
}

class _CalanderState extends State<Calander> {
  //late final CalendarController _controller = CalendarController();
  int numberEvents = 0;
  List? appointements = [];
  List plans = [];
  Widget _lowerHalf = const SizedBox();
  final CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('plan');
  static final Widget _eventIcon = Container(
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(1000)),
        border: Border.all(color: Colors.blue, width: 2.0)),
    child: const Icon(
      Icons.person,
      color: Colors.amber,
    ),
  );
  final EventList<Event> _markedDateMap = EventList<Event>(events: {
    DateTime(2022, 4, 10): [],
  });
  DateTime ts = DateTime(2022);
  Future getData() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _collectionRef
        //.where('owners', arrayContainsAny: [widget.techName])
        .get();

    // Get data from docs and convert map to List

    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  @override
  initState() {
    getData().then((value) {
      for (int i = 0; i < value.length; i++) {
        plans.add(value[i]);
        ts = DateTime.parse(value[i]['startTime'].toDate().toString());
        print("${plans[i]}");
        _markedDateMap.add(
            DateTime(ts.year, ts.month, ts.day),
            Event(
                date: DateTime(ts.year, ts.month, ts.day),
                title: value[i]['subject'],
                dot: Container(
                  height: 40,
                  width: 40,
                  color: Colors.red,
                ),
                description: value[i]['id']));
      }
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Plan"),
          actions: [
            TextButton(
                onPressed: () async {
                  await showDialog(
                      context: context,
                      builder: (context) => const AlertDialogPlan());
                },
                child: const Text(
                  "Créer",
                  style: TextStyle(letterSpacing: 4, color: Colors.white),
                )),
            // PopupMenuButton(
            //   itemBuilder: (context) => [
            //     PopupMenuItem(
            //       onTap: () {},
            //       child: Padding(
            //         padding: const EdgeInsets.all(8.0),
            //         child: Container(
            //             alignment: Alignment.center,
            //             height: 60,
            //             width: 170,
            //             decoration: BoxDecoration(
            //                 borderRadius: BorderRadius.circular(15)),
            //             child: const Padding(
            //               padding: EdgeInsets.all(8.0),
            //               child: Text("afficher par semaine "),
            //             )),
            //       ),
            //     ),
            //     PopupMenuItem(
            //       onTap: () {},
            //       child: Padding(
            //         padding: const EdgeInsets.all(8.0),
            //         child: Container(
            //             alignment: Alignment.center,
            //             height: 60,
            //             width: 170,
            //             decoration: BoxDecoration(
            //                 borderRadius: BorderRadius.circular(15)),
            //             child: const Text("afficher par mois ")),
            //       ),
            //     ),
            //   ],
            // )
          ],
        ),
        body: Column(
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
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     setState(() {
        //       numberEvents = 0;
        //     });
        //     bottomSheet(context, [widget.techName]);
        //   },
        //   child: const Icon(Icons.add),
        // ),
      ),
    );
  }

  Widget _calendar() {
    return CalendarCarousel<Event>(
      onDayPressed: (DateTime date, List<Event> events) {
        if (events.isNotEmpty) {
          var _date = events[0]
              .getDate()
              .toString()
              .substring(0, events[0].getDate().toString().indexOf(" "));
          var _altDate = DateTime.parse(_date);
          var event = plans.where((e) {
            var _dt = DateTime.parse(e['startTime'].toDate().toString());
            return DateTime(_dt.year, _dt.month, _dt.day) ==
                events[0].getDate();
          }).toList();
          setState(() {
            _lowerHalf = Stack(children: [
              PlanCard(
                  client: event[0]['client'],
                  subject: event[0]['subject'],
                  startTime: _date,
                  status: event[0]['state'].toString()),
              Positioned(
                  top: 0,
                  right: 0,
                  child: FloatingActionButton(
                    onPressed: () {
                      bottomSheet(context, [event[0], _date, _altDate.toString()]);
                    },
                    child: Icon(Icons.edit),
                  )),
            ]);
          });
        }
      },
      markedDatesMap: _markedDateMap,
      selectedDateTime: DateTime.now(),
      height: 420,
      daysHaveCircularBorder: null,
      markedDateIconBuilder: (Event event) {
        MaterialColor statusColor = Colors.blue;
        for (var e in plans) {
          var date = DateTime.parse(e['startTime'].toDate().toString());
          var _date = DateTime(date.year, date.month, date.day);
          if (_date.compareTo(event.getDate()) == 0) {
            // print("$_date => ?? => ${event.getDate()} => ? ${date.compareTo(event.getDate())} status => ${e['state']}");

            switch (e['state']) {
              case "Planifiée":
                {
                  statusColor = Colors.blue;
                }
                break;
              case "Démarrée":
                {
                  statusColor = Colors.orange;
                }
                break;
              case "Termineé":
                {
                  statusColor = Colors.green;
                }
                break;
              case "Annuleé":
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
      todayButtonColor: Colors.teal,
    );
  }

  // Widget claendar() {
  //   return CalendarCarousel<Event>(
  //     markedDateIconBuilder: (event) {
  //       return Container(
  //         color: Colors.red,
  //         child: Center(
  //             child: Text(
  //           event.getDate().day.toString(),
  //           style: const TextStyle(color: Colors.white),
  //         )),
  //       );
  //     },
  //     markedDateShowIcon: true,
  //     onDayPressed: (DateTime date, List<Event> events) {
  //       //setState(() => _currentDate = date);
  //     },

  //     thisMonthDayBorderColor: Colors.grey,

  //     //weekFormat: ,
  //     markedDatesMap: _markedDateMap,
  //     //height: 420.0,
  //     selectedDateTime: DateTime.now(),
  //     daysHaveCircularBorder: true,

  //     /// null for not rendering any border, true for circular border, false for rectangular border
  //   );
  // }

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

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_calendar_carousel/classes/event.dart';
// import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:intl/intl.dart';
// import 'package:syncfusion_flutter_calendar/calendar.dart';

// import 'bottomsheet.dart';
// import 'details.dart';
// import 'plan.dart';

// var data = FirebaseFirestore.instance;

// class Calander extends StatefulWidget {
//   final String techName;
//   const Calander({Key? key, required this.techName}) : super(key: key);

//   @override
//   _CalanderState createState() => _CalanderState();
// }

// class _CalanderState extends State<Calander> {
//   late final CalendarController _controller = CalendarController();
//   int numberEvents = 0;
//   List? appointements = [];
//   Widget _lowerHalf = SizedBox();
//   dynamic _data = data.collection('plan').snapshots();
//   @override
//   initState(){
//     super.initState();
//     _data.get()
//   }
//   Widget ca() {
//     return CalendarCarousel<Event>(
//       onDayPressed: (DateTime date, List<Event> events) {
//         if()
//       },

//       thisMonthDayBorderColor: const Color.fromARGB(255, 142, 103, 103),
// //      weekDays: null, /// for pass null when you do not want to render weekDays
// //      headerText: Container( /// Example for rendering custom header
// //        child: Text('Custom Header'),
// //      ),
//       // customDayBuilder: (   /// you can provide your own build function to make custom day containers
//       //   bool isSelectable,
//       //   int index,
//       //   bool isSelectedDay,
//       //   bool isToday,
//       //   bool isPrevMonthDay,
//       //   TextStyle textStyle,
//       //   bool isNextMonthDay,
//       //   bool isThisMonthDay,
//       //   DateTime day,
//       // ) {
//       //     /// If you return null, [CalendarCarousel] will build container for current [day] with default function.
//       //     /// This way you can build custom containers for specific days only, leaving rest as default.

//       //     // Example: every 15th of month, we have a flight, we can place an icon in the container like that:
//       //     if (day.day == 15) {
//       //       return Center(
//       //         child: Icon(Icons.ad_units),
//       //       );
//       //     } else {
//       //       return null;
//       //     }
//       // },

//       markedDatesMap: _markedDateMap,
//       //height: 420.0,
//       selectedDateTime: DateTime.now(),
//       showIconBehindDayText: false,
//       weekFormat: false,
//       height: 420.0,
//       //selectedDateTime: _currentDate,
//       daysHaveCircularBorder: null,
//       markedDateIconBuilder: (event) {
//         return Container(
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(50), color: Colors.amber),
//           height: 40,
//           width: 40,
//           child: Center(
//               child: Text(
//             event.getDate().day.toString(),
//             style: TextStyle(color: Colors.white),
//           )),
//         );
//       },
//       todayButtonColor: Colors.teal,

//       /// null for not rendering any border, true for circular border, false for rectangular border
//     );
//   }

//   Widget claendar() {
//     return CalendarCarousel<Event>(
//       markedDateIconBuilder: (event) {
//         return Container(
//           color: Colors.red,
//           child: Center(
//               child: Text(
//             event.getDate().day.toString(),
//             style: const TextStyle(color: Colors.white),
//           )),
//         );
//       },
//       markedDateShowIcon: true,
//       onDayPressed: (DateTime date, List<Event> events) {
//         //setState(() => _currentDate = date);
//       },

//       thisMonthDayBorderColor: Colors.grey,

//       //weekFormat: ,
//       markedDatesMap: _markedDateMap,
//       //height: 420.0,
//       selectedDateTime: DateTime.now(),
//       daysHaveCircularBorder: true,

//       /// null for not rendering any border, true for circular border, false for rectangular border
//     );
//   }

//   static final Widget _eventIcon = Container(
//     decoration: BoxDecoration(
//         color: Colors.white,
//         // borderRadius: const BorderRadius.all(Radius.circular(1000)),
//         border: Border.all(
//           color: Colors.blue,
//         )),
//     child: const Icon(
//       Icons.person,
//       color: Colors.amber,
//     ),
//   );
//   final EventList<Event> _markedDateMap = EventList<Event>(
//     events: {
//       DateTime(2022, 4, 21): [
//         Event(
//             date: DateTime(2022, 4, 21),
//             title: 'Event 1',
//             icon: _eventIcon,
//             dot: Container(
//               color: Colors.red,
//             ),
//             description: "qsdqsdqdqdqsdds"),
//       ],
//     },
//   );

//   void tap(CalendarTapDetails calendarTapDetails) {
//     /* final Appointment appointmentDetails = calendarTapDetails.appointments![0];
//     if (appointmentDetails != []) {
//       Get.to(Details(
//         docId: appointmentDetails.subject,
//       ));
//     } else
//       print("empty");*/
//     /*   print(calendarTapDetails.appointments);*/
//     if (_controller.view == CalendarView.week ||
//         _controller.view == CalendarView.day) {
//       if (!calendarTapDetails.appointments.isNull) {
//         final Appointment appointmentDetails =
//             calendarTapDetails.appointments![0];

//         Get.to(Details(
//           docId: appointmentDetails.subject,
//         ));
//       } else
//         print("empty");
//     } else {
//       if (!calendarTapDetails.appointments!.isEmpty) {
//         setState(() {
//           numberEvents = calendarTapDetails.appointments!.length;
//           appointements = calendarTapDetails.appointments;
//         });
//       } else
//         print("empty");
//       setState(() {
//         numberEvents = calendarTapDetails.appointments!.length;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           centerTitle: true,
//           title: const Text("plan"),
//           actions: [
//             PopupMenuButton(
//               itemBuilder: (context) => [
//                 PopupMenuItem(
//                   onTap: () {
//                     _controller.view = CalendarView.day;
//                     setState(() {
//                       numberEvents = 0;
//                     });
//                   },
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Container(
//                         alignment: Alignment.center,
//                         height: 60,
//                         width: 170,
//                         decoration: BoxDecoration(
//                             color: _controller.view == CalendarView.day
//                                 ? Colors.green.withOpacity(0.5)
//                                 : Colors.transparent,
//                             borderRadius: BorderRadius.circular(15)),
//                         child: const Padding(
//                           padding: EdgeInsets.all(8.0),
//                           child: Text("afficher par jour "),
//                         )),
//                   ),
//                 ),
//                 PopupMenuItem(
//                   onTap: () {
//                     _controller.view = CalendarView.week;
//                     setState(() {
//                       numberEvents = 0;
//                     });
//                   },
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Container(
//                         alignment: Alignment.center,
//                         height: 60,
//                         width: 170,
//                         decoration: BoxDecoration(
//                             color: _controller.view == CalendarView.week
//                                 ? Colors.green.withOpacity(0.5)
//                                 : Colors.transparent,
//                             borderRadius: BorderRadius.circular(15)),
//                         child: const Padding(
//                           padding: EdgeInsets.all(8.0),
//                           child: Text("afficher par semaine "),
//                         )),
//                   ),
//                 ),
//                 PopupMenuItem(
//                   onTap: () {
//                     _controller.view = CalendarView.month;
//                   },
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Container(
//                         alignment: Alignment.center,
//                         height: 60,
//                         width: 170,
//                         decoration: BoxDecoration(
//                             color: _controller.view == CalendarView.month
//                                 ? Colors.green.withOpacity(0.5)
//                                 : Colors.transparent,
//                             borderRadius: BorderRadius.circular(15)),
//                         child: const Text("afficher par mois ")),
//                   ),
//                 ),
//               ],
//             )
//           ],
//         ),
//         body: Column(
//           children: [
//             const SizedBox(height: 10,),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 _container("Planifier", Colors.blue),
//                 _container("Démarrer", Colors.orange),
//                 _container("Terminer", Colors.green),
//                 _container("Annuler", Colors.red),
//               ],
//             ),
//             //  StreamBuilder<QuerySnapshot>(
//             //       stream: data.collection('plan').snapshots(),
//             //       builder: (context, snapshot) {
//             //         if (snapshot.hasData) {
//             //           var test = snapshot.data!.docs.toList();
//             //           List<Appointment> meetings = <Appointment>[];
//             //           Color stateColor = Colors.transparent;

//             //           for (var test1 in test) {
//             //             switch (test1.get("state")) {
//             //               case "Planifié":
//             //                 {
//             //                   stateColor = Colors.blue;
//             //                 }
//             //                 break;
//             //               case "Demarreé":
//             //                 {
//             //                   stateColor = Colors.orange;
//             //                 }
//             //                 break;
//             //               case "Termineé":
//             //                 {
//             //                   stateColor = Colors.green;
//             //                 }
//             //                 break;
//             //               case "Annuleé":
//             //                 {
//             //                   stateColor = Colors.red;
//             //                 }
//             //                 break;
//             //             }
//             //             if (test1.get("owners").contains(widget.techName)) {
//             //               meetings.add(Appointment(
//             //                   startTime: test1.get("startTime").toDate(),
//             //                   endTime: test1.get("endTime").toDate(),
//             //                   subject: test1.reference.id,
//             //                   color: stateColor));
//             //             }
//             //           }
//             ca(),
//             _lowerHalf,
//             //return claendar();
//             // return SfCalendar(
//             //   // monthViewSettings: MonthViewSettings(
//             //   //     appointmentDisplayMode:
//             //   //         MonthAppointmentDisplayMode.appointment),
//             //   allowAppointmentResize: true,
//             //   dataSource: Plan(meetings),
//             //   controller: _controller,
//             //   view: CalendarView.month,
//             //   onTap: tap,
//             // );
//             //   }
//             //   return const Center(
//             //       child: const CircularProgressIndicator());
//             // }),

//             // AnimatedContainer(
//             //   duration: const Duration(milliseconds: 400),
//             //   height: numberEvents == 0 ? 0 : 300,
//             //   child: ListView.builder(
//             //       itemCount: appointements!.length,
//             //       itemBuilder: (context, index) {
//             //         return Padding(
//             //           padding: const EdgeInsets.all(8.0),
//             //           child: Container(
//             //             height: 90,
//             //             decoration: BoxDecoration(
//             //                 color: appointements![index].color.withOpacity(0.6),
//             //                 borderRadius: BorderRadius.circular(12)),
//             //             child: ListTile(
//             //               onTap: () {
//             //                 setState(() {
//             //                   numberEvents = 0;
//             //                 });
//             //                 Get.to(Details(
//             //                   docId: appointements![index].subject,
//             //                 ));
//             //               },
//             //               title: Text("${appointements![index].subject}"),
//             //               subtitle: Column(
//             //                 crossAxisAlignment: CrossAxisAlignment.start,
//             //                 children: [
//             //                   const SizedBox(
//             //                     height: 10,
//             //                   ),
//             //                   Row(
//             //                     children: [
//             //                       const Text("Date de debut : "),
//             //                       Text(DateFormat('yyyy-MM-dd hh:mm')
//             //                           .format(appointements![index].startTime)),
//             //                     ],
//             //                   ),
//             //                   const SizedBox(
//             //                     height: 10,
//             //                   ),
//             //                   Row(
//             //                     children: [
//             //                       const Text("Date de fin : "),
//             //                       Text(DateFormat('yyyy-MM-dd hh:mm')
//             //                           .format(appointements![index].endTime)),
//             //                     ],
//             //                   ),
//             //                 ],
//             //               ),
//             //             ),
//             //           ),
//             //         );
//             //       }),
//             // )
//           ],
//         ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: () {
//             setState(() {
//               numberEvents = 0;
//             });
//             bottomSheet(context, [widget.techName]);
//           },
//           child: const Icon(Icons.add),
//         ),
//       ),
//     );
//   }

//   Widget _container(String t, MaterialColor c) {
//     return Container(
//       decoration:
//           BoxDecoration(color: c, borderRadius: BorderRadius.circular(5)),
//       child:  Padding(
//           padding: const EdgeInsets.fromLTRB(20,10,20,10),
//           child: Text(t,
//            style: const TextStyle(color: Colors.white))),
//     );
//   }
// }
