import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

var data = FirebaseFirestore.instance;

class Details extends StatelessWidget {
  final String docId;
  const Details({required this.docId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${docId}"),
      ),
      body: StreamBuilder(
        stream: data.collection("plan").doc(docId).snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasData) {
            Color stateColor = Colors.white;
            switch (snapshot.data!.get("state")) {
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
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: snapshot.data!.get("state") == "Planifié"
                          ? () {
                              snapshot.data!.reference
                                  .update({'state': "Demarreé"});
                            }
                          : null,
                      child: Text("Démarrer"),
                      style: ElevatedButton.styleFrom(primary: Colors.orange),
                    ),
                    ElevatedButton(
                      onPressed: snapshot.data!.get("state") == "Demarreé"
                          ? () {
                              snapshot.data!.reference
                                  .update({'state': "Termineé"});
                            }
                          : null,
                      child: Text("Terminé"),
                      style: ElevatedButton.styleFrom(primary: Colors.green),
                    ),
                    ElevatedButton(
                      onPressed: snapshot.data!.get("state") == "Planifié"
                          ? () {
                              snapshot.data!.reference
                                  .update({'state': "Annuleé"});
                            }
                          : null,
                      child: Text("Annuler"),
                      style: ElevatedButton.styleFrom(primary: Colors.red),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Sujet de planning  : ${snapshot.data!.get("subject")}",
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        "Etat de planning  :",
                        style: TextStyle(fontSize: 25),
                      ),
                      Expanded(
                        child: Text(
                          " ${snapshot.data!.get("state")}",
                          style: TextStyle(fontSize: 25, color: stateColor),
                        ),
                      ),
                    ],
                  ),
                ),
                StreamBuilder(
                  stream: data
                      .collection("contacts")
                      .doc(snapshot.data!.get('client'))
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text(
                                  "Client   :",
                                  style: TextStyle(fontSize: 25),
                                ),
                                Expanded(
                                  child: Text(
                                    " ${snapshot.data!.get("name")}",
                                    style: TextStyle(
                                      fontSize: 25,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text(
                                  "Adresse   :",
                                  style: TextStyle(fontSize: 25),
                                ),
                                Expanded(
                                  child: Text(
                                    " ${snapshot.data!.get("Adresse professionnelle")}",
                                    style: TextStyle(
                                      fontSize: 25,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text(
                                  "portable professionnel   :",
                                  style: TextStyle(fontSize: 25),
                                ),
                                Expanded(
                                  child: Text(
                                    " ${snapshot.data!.get("portable professionnel")}",
                                    style: TextStyle(
                                      fontSize: 25,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                )
              ],
            );
          } else
            return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}