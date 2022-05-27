import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';

import '../congescreens/demande_conge_screen.dart';

class CongeScreen extends StatefulWidget {
  final String userID;
  const CongeScreen({Key? key, required this.userID}) : super(key: key);

  @override
  State<CongeScreen> createState() => _CongeScreenState();
}

class _CongeScreenState extends State<CongeScreen> {
  final holidayDays = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          //centerTitle: true,
          title: const Text("Congé"),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 20, right: 30),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              DemandeCongeScreen(userID: widget.userID)));
                },
                child: const Text(
                  "Demander",
                  style: TextStyle(
                      fontSize: 15, color: Colors.white, letterSpacing: 3),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          ],
        ),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(mainAxisSize: MainAxisSize.max, children: [
                  const Text("Nombre de jour expirée : ",
                      style: TextStyle(fontSize: 20)),
                  const Spacer(),
                  Text(
                    '$holidayDays',
                    style:
                        const TextStyle(color: Colors.blueGrey, fontSize: 20),
                  )
                ]),
                Row(mainAxisSize: MainAxisSize.max, children: [
                  const Text("Nombre de jour Restant : ",
                      style: TextStyle(fontSize: 20)),
                  const Spacer(),
                  Text(
                    '$holidayDays',
                    style:
                        const TextStyle(color: Colors.blueGrey, fontSize: 20),
                  )
                ]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _container("Payé", Colors.orange),
                    _container("Non payé", Colors.green)
                  ],
                ),
                _calendar()
              ]),
        ));
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

  Widget _calendar() {
    return CalendarCarousel<Event>(
      onDayPressed: (DateTime date, List<Event> events) {},
      //markedDatesMap: _markedDateMap,
      selectedDateTime: DateTime.now(),
      height: 420,
      daysHaveCircularBorder: null,
      markedDateIconBuilder: null,

      todayButtonColor: Colors.deepPurpleAccent,
      todayBorderColor: Colors.deepPurpleAccent,
    );
  }
}
