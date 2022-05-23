import 'package:chama_projet/services/devis.dart';
import 'package:chama_projet/services/facture.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'listfact.dart';
import 'listfactdevis.dart';
import 'dart:ui' as ui;

class ListFactt extends StatefulWidget {
  const ListFactt({Key? key}) : super(key: key);

  @override
  State<ListFactt> createState() => _ListFacttState();
}

class _ListFacttState extends State<ListFactt> {
  // ignore: non_constant_identifier_names
  List Listfact = [];
  // ignore: non_constant_identifier_names
  List Listdev = [];

  @override
  void initState() {
    super.initState();
    fetchDatabaseList();
  }

  fetchDatabaseList() async {
    dynamic resultant = await Facture().getFacturesList();
    dynamic resultant2 = await Devis().getDevisBonCommd();

    if (resultant == null) {
      // ignore: avoid_print
      print('Unable to retrieve');
    } else {
      setState(() {
        Listfact = resultant;
        Listdev = resultant2;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inventaire"),
        backgroundColor: Colors.orange,
      ),
      body: RefreshIndicator(
          onRefresh: () {
            Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                    pageBuilder: (a, b, c) => const ListFactt(),
                    transitionDuration: const Duration(seconds: 0)));
            // ignore: void_checks
            return Future.value(false);
          },
          child: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(20),
                  child: Card(
                      child: InkWell(
                    onTap: () {
                      Get.to(() => const ListFactureDev());
                    },
                    splashColor: const Color.fromARGB(255, 3, 56, 109),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Center(
                            child: Text("Devis en facture",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 30,
                                    foreground: Paint()
                                      ..shader = ui.Gradient.linear(
                                        const Offset(0, 20),
                                        const Offset(150, 20),
                                        <Color>[
                                          const Color.fromARGB(
                                              255, 232, 86, 18),
                                          const Color.fromARGB(
                                              255, 194, 178, 27),
                                        ],
                                      ))),
                          ),
                        ),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.indigo),
                            child: Text("${Listdev.length} A traiter"),
                            onPressed: null,
                          ),
                        )
                      ],
                    ),
                  )),
                ),
                Container(
                  margin: const EdgeInsets.all(20),
                  child: Card(
                      child: InkWell(
                    onTap: () {
                      Get.to(() => const ListFacture());
                    },
                    splashColor: const Color.fromARGB(255, 3, 56, 109),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(" Facture ",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 30,
                                  foreground: Paint()
                                    ..shader = ui.Gradient.linear(
                                      const Offset(0, 20),
                                      const Offset(150, 20),
                                      <Color>[
                                        const Color.fromARGB(255, 232, 86, 18),
                                        const Color.fromARGB(255, 194, 178, 27),
                                      ],
                                    ))),
                        ),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.indigo),
                            child: Text("${Listfact.length} A Traiter"),
                            onPressed: null,
                          ),
                        )
                      ],
                    ),
                  )),
                ),
              ],
            ),
          ))),
    );
  }
}
