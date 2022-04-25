// ignore_for_file: file_names, must_be_immutable, unused_local_variable

import 'package:chama_projet/employes.dart/update_employe.dart';
import 'package:flutter/material.dart';

class EmployeDetail extends StatefulWidget {
  String nom, tel, adresse, id;
  EmployeDetail({
    Key? key,
    required this.id,
    required this.nom,
    required this.tel,
    required this.adresse,
  }) : super(key: key);

  @override
  State<EmployeDetail> createState() => _EmployeDetailState();
}

class _EmployeDetailState extends State<EmployeDetail> {
  Widget textfield({@required hintText}) {
    return Material(
      elevation: 2,
      shadowColor: Colors.indigo,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              letterSpacing: 2,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            fillColor: Colors.white30,
            filled: true,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.orange,
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 20, right: 30),
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UpdateEmployePage(
                              nom: widget.nom,
                              id: widget.id,
                            )));
              },
              child: Text(
                "Modifier".toUpperCase(),
                style: const TextStyle(
                    fontSize: 15, color: Colors.white, letterSpacing: 3),
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        widget.nom,
                        style: const TextStyle(
                          fontSize: 35,
                          letterSpacing: 1.5,
                          color: Colors.orange,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: textfield(
                        hintText: widget.adresse,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: textfield(
                        hintText: widget.tel,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
