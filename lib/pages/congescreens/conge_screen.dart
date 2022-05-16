import 'package:chama_projet/pages/congescreens/demande_conge_screen.dart';
import 'package:flutter/material.dart';

class CongeScreen extends StatefulWidget {
  const CongeScreen({Key? key}) : super(key: key);

  @override
  State<CongeScreen> createState() => _CongeScreenState();
}

class _CongeScreenState extends State<CongeScreen> {
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
                        builder: (context) => const DemandeCongeScreen()));
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
    );
  }
}
