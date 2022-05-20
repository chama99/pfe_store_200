// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/material.dart';

class Bouton extends StatefulWidget {
  const Bouton({
    Key? key,
  }) : super(key: key);

  @override
  State<Bouton> createState() => _BoutonState();
}

class _BoutonState extends State<Bouton> {
  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.indigo,
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                UserAccountsDrawerHeader(
                  accountName: Text("kfkfkf"),
                  accountEmail: Text("kfkfk"),
                  currentAccountPicture: CircleAvatar(
                    child: ClipOval(
                      child: Image.network(
                        "https://fr.wikipedia.org/wiki/Image#/media/Fichier:Image_created_with_a_mobile_phone.png",
                        fit: BoxFit.cover,
                        width: 90,
                      ),
                    ),
                  ),
                  decoration: const BoxDecoration(color: Colors.orange),
                ),
                ListTile(
                  leading: const Icon(Icons.exit_to_app),
                  title: const Text("Déconnexion"),
                  onTap: () {},
                ),
              ],
            ),
          ),
          backgroundColor: Colors.white,
          body: Container(
            margin: const EdgeInsets.all(30),
            child: GridView.count(crossAxisCount: 2, children: <Widget>[
              Card(
                color: Colors.purple[100],
                margin: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {},
                  splashColor: const Color.fromARGB(255, 3, 56, 109),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.article,
                          size: 70,
                          color: Colors.white,
                        ),
                        Text("jjjj")
                      ],
                    ),
                  ),
                ),
              ),
              Card(
                color: Colors.purple[100],
                margin: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {},
                  splashColor: const Color.fromARGB(255, 3, 56, 109),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.article,
                          size: 70,
                          color: Colors.white,
                        ),
                        Text("jijjj")
                      ],
                    ),
                  ),
                ),
              ),
              Card(
                color: Colors.purple[100],
                margin: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {},
                  splashColor: const Color.fromARGB(255, 3, 56, 109),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.article,
                          size: 70,
                          color: Colors.white,
                        ),
                        Text("jjfjfj")
                      ],
                    ),
                  ),
                ),
              ),
              Card(
                color: Colors.purple[100],
                margin: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {},
                  splashColor: const Color.fromARGB(255, 3, 56, 109),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.article,
                          size: 70,
                          color: Colors.white,
                        ),
                        Text("kfkfkfkfk")
                      ],
                    ),
                  ),
                ),
              )
            ]),
          ),
        ),
      );
}
