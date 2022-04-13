import 'package:chama_projet/inventaire/reception.dart/listReception.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListInventaire extends StatefulWidget {
  const ListInventaire({Key? key}) : super(key: key);

  @override
  State<ListInventaire> createState() => _ListInventaireState();
}

class _ListInventaireState extends State<ListInventaire> {
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
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Réceptions",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                  color: Colors.indigo)),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Atelier",
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.indigo),
                            child: const Text("Traiter"),
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
                    onTap: () {},
                    splashColor: const Color.fromARGB(255, 3, 56, 109),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Transfert interne",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                  color: Colors.indigo)),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Atelier",
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.indigo),
                            child: const Text("Traiter"),
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
                    onTap: () {},
                    splashColor: const Color.fromARGB(255, 3, 56, 109),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Livraisons",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                  color: Colors.indigo)),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Atelier",
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.indigo),
                            child: const Text("Traiter"),
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
