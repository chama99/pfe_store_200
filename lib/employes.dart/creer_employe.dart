// ignore_for_file: unused_import, deprecated_member_use

// ignore: avoid_web_libraries_in_flutter

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_azure_b2c/GUIDGenerator.dart';
import 'package:flutter_multiselect/flutter_multiselect.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import '../services/employe.dart';
import '../widget/InputDeco_design.dart';
import '../widget/toast.dart';
import 'listeEmployes.dart';

class CreeEmployePage extends StatefulWidget {
  const CreeEmployePage({Key? key}) : super(key: key);

  @override
  _CreeEmployePageState createState() => _CreeEmployePageState();
}

class _CreeEmployePageState extends State<CreeEmployePage> {
  final _formKey = GlobalKey<FormState>();
  var role = "";

  var nom = "";
  var tel = "";
  var adresse = "";
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final String uuid = GUIDGen.generate();

  final nomController = TextEditingController();
  final telp = TextEditingController();
  final adressee = TextEditingController();
  List listItem = ["Technicien", "Comptable"];
  bool isHiddenPassword = true;

  // ignore: non_constant_identifier_names
  List NomEmpl = [];
  @override
  void initState() {
    super.initState();

    fetchDatabaseList();
  }

  fetchDatabaseList() async {
    dynamic resultant = await Employe().getEmployesListByNom();

    if (resultant == null) {
      // ignore: avoid_print
      print('Unable to retrieve');
    } else {
      setState(() {
        NomEmpl = resultant;
      });
    }
  }

  // ignore: non_constant_identifier_names
  bool VerificationEmploye(String nom) {
    bool b = false;
    for (int i = 0; i < NomEmpl.length; i++) {
      if (nom == NomEmpl[i]) {
        b = true;
      }
    }
    return b;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    telp.dispose();

    nomController.dispose();
    adressee.dispose();

    super.dispose();
  }

  late String dropdown;

  clearText() {
    telp.clear();

    nomController.clear();
    adressee.clear();
  }

  // ignore: prefer_const_constructors

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Créer Un Employé"),
        backgroundColor: Colors.orange,
      ),
      body: RefreshIndicator(
          onRefresh: () {
            Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                    // ignore: prefer_const_constructors
                    pageBuilder: (a, b, c) => CreeEmployePage(),
                    // ignore: prefer_const_constructors
                    transitionDuration: Duration(seconds: 0)));
            // ignore: void_checks
            return Future.value(false);
          },
          child: Container(
            margin: const EdgeInsets.all(30),
            child: Column(children: [
              Expanded(
                child: Form(
                  key: _formKey,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 10),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 15, left: 10, right: 10),
                            child: TextFormField(
                              controller: nomController,
                              keyboardType: TextInputType.text,
                              decoration: buildInputDecoration(
                                Icons.person,
                                "Nom et prénom",
                                color: Colors.white,
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Veuillez entrer nom';
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 20, left: 5, right: 5, top: 10),
                            child: TextFormField(
                              controller: telp,
                              keyboardType: TextInputType.number,
                              decoration: buildInputDecoration(
                                Icons.phone,
                                "Tél. portable professionnel",
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 20, left: 5, right: 5, top: 10),
                            child: TextFormField(
                              controller: adressee,
                              keyboardType: TextInputType.text,
                              decoration: buildInputDecoration(
                                Icons.location_on,
                                "Adresse professionnelle",
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  // Validate returns true if the form is valid, otherwise false.
                                  if (_formKey.currentState!.validate()) {
                                    {
                                      setState(() {
                                        nom = nomController.text;
                                        tel = telp.text;
                                        adresse = adressee.text;

                                        Employe().addEmploye(
                                          uuid,
                                          nom,
                                          tel,
                                          adresse,
                                        );

                                        clearText();

                                        Get.to(() => const listEmploye());
                                      });
                                    }
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
                          )
                        ],
                      )),
                ),
              ),
            ]),
          )),
    );
  }
}
