import 'package:chama_projet/inventaire/Transfert/listTransfert.dart';
import 'package:chama_projet/inventaire/livraison/listLivraison.dart';
import 'package:chama_projet/inventaire/reception/listReception.dart';
import 'package:chama_projet/services/livraison.dart';
import 'package:chama_projet/services/transfert.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/reception.dart';
import 'dart:ui' as ui;

class ListInventaire extends StatefulWidget {
  const ListInventaire({Key? key}) : super(key: key);

  @override
  State<ListInventaire> createState() => _ListInventaireState();
}

class _ListInventaireState extends State<ListInventaire> {
  // ignore: non_constant_identifier_names
  List Listreception = [];
  // ignore: non_constant_identifier_names
  List Listlivraison = [];
  List listTransfert = [];
  @override
  void initState() {
    super.initState();
    fetchDatabaseList();
  }

  fetchDatabaseList() async {
    dynamic resultant = await Reception().getReceptionList();
    dynamic resultant2 = await Livraison().getLivraisonList();
    dynamic resultant3 = await Transfert().getTransfert();

    if (resultant == null) {
      // ignore: avoid_print
      print('Unable to retrieve');
    } else {
      setState(() {
        Listreception = resultant;
        Listlivraison = resultant2;
        listTransfert = resultant3;
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
                    pageBuilder: (a, b, c) => const ListInventaire(),
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
                      Get.to(() => const ListReception());
                    },
                    splashColor: const Color.fromARGB(255, 3, 56, 109),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Réceptions",
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
                            child: Text("${Listreception.length} A traiter"),
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
                      Get.to(() => const ListTransfert());
                    },
                    splashColor: const Color.fromARGB(255, 3, 56, 109),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Transfert interne",
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
                            child: Text("${listTransfert.length} A Traiter"),
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
                      Get.to(() => const ListLivraison());
                    },
                    splashColor: const Color.fromARGB(255, 3, 56, 109),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Livraisons",
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
                            child: Text("${Listlivraison.length} A Traiter"),
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
