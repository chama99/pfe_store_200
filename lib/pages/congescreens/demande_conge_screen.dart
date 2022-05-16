import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DemandeCongeScreen extends StatefulWidget {
  const DemandeCongeScreen({Key? key}) : super(key: key);

  @override
  State<DemandeCongeScreen> createState() => _DemandeCongeScreenState();
}

class _DemandeCongeScreenState extends State<DemandeCongeScreen> {
  var typeConge;
  DateTime _endDate = DateTime.now();
  DateTime _beginDate = DateTime.now().add(const Duration(days: 1));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        //centerTitle: true,
        title: const Text("Demande de Congé"),
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Type de congé :",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        const Text("Congé payés"),
                        Radio(
                            value: "Congé payés",
                            groupValue: typeConge,
                            onChanged: (v) {}),
                      ],
                    ),
                    Row(
                      children: [
                        const Text("Congé non payés"),
                        Radio(
                            value: "Congé non payés",
                            groupValue: typeConge,
                            onChanged: (v) {})
                      ],
                    ),
                  ],
                )
              ],
            ),
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
                    Text(DateFormat("yyyy - MM - dd").format(DateTime.now()),
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white)),
                  ],
                ),
                onPressed: () {
                  // _selectDate(context, true);
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
                  //_selectDate(context, false);
                },
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
