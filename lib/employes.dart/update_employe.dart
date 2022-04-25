import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../services/employe.dart';
import '../widget/InputDeco_design.dart';
import 'listeEmployes.dart';

class UpdateEmployePage extends StatefulWidget {
  final String nom, id;
  // ignore: prefer_const_constructors_in_immutables
  UpdateEmployePage({Key? key, required this.nom, required this.id})
      : super(key: key);

  @override
  _UpdateEmployePageState createState() => _UpdateEmployePageState();
}

class _UpdateEmployePageState extends State<UpdateEmployePage> {
  final _formKey = GlobalKey<FormState>();

  // Updaing Student
  CollectionReference students =
      FirebaseFirestore.instance.collection('employes');
  List listItem = ["Technicien", "Comptable"];
  // ignore: prefer_typing_uninitialized_variables
  var role;
  // ignore: prefer_typing_uninitialized_variables
  var ch;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Employé / ${widget.nom}",
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.orange,
      ),
      body: Container(
        margin: const EdgeInsets.all(30),
        child: Form(
            key: _formKey,
            // Getting Specific Data by ID
            child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              future: FirebaseFirestore.instance
                  .collection('employes')
                  .doc(widget.id)
                  .get(),
              builder: (_, snapshot) {
                if (snapshot.hasError) {
                  // ignore: avoid_print
                  print('Something Went Wrong');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                var data = snapshot.data!.data();
                var tel = data!['portable professionnel'];
                var id = data['IdEmp'];
                var adresse = data['Adresse professionnelle'];
                role = data['role'];

                // ignore: unused_local_variable
                var nom = data['name'];

                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 30),
                    child: ListView(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10.0),
                          child: TextFormField(
                            initialValue: tel,
                            autofocus: false,
                            keyboardType: TextInputType.number,
                            onChanged: (value) => tel = value,
                            decoration: buildInputDecoration(
                              Icons.phone,
                              "Tel",
                              color: Colors.white,
                            ),
                          ),
                        ),

                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10.0),
                          child: TextFormField(
                            initialValue: adresse,
                            autofocus: false,
                            onChanged: (value) => adresse = value,
                            decoration: buildInputDecoration(
                              Icons.location_on,
                              "Adresse professionnelle",
                              color: Colors.white,
                            ),
                          ),
                        ),

                        // ignore: avoid_unnecessary_containers
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  // Validate returns true if the form is valid, otherwise false.
                                  if (_formKey.currentState!.validate()) {
                                    if (ch != null) {
                                      role = ch;
                                    }

                                    Employe().updateEmploye(id, tel, adresse);

                                    Get.to(() => const listEmploye());
                                  }
                                },
                                child: const Text(
                                  "Sauvegarder",
                                  style: TextStyle(fontSize: 18.0),
                                ),
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.orange),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            )),
      ),
    );
  }
}
