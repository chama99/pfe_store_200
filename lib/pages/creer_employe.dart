// ignore_for_file: unused_import, deprecated_member_use

// ignore: avoid_web_libraries_in_flutter

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multiselect/flutter_multiselect.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import '../services/employe.dart';
import '../widget/InputDeco_design.dart';

class CreeEmployePage extends StatefulWidget {
  const CreeEmployePage({Key? key}) : super(key: key);

  @override
  _CreeEmployePageState createState() => _CreeEmployePageState();
}

class _CreeEmployePageState extends State<CreeEmployePage> {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  XFile? imageFile;

  final ImagePicker picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  late String imageUrl;

  var role = "";
  var email = "";
  var nom = "";
  var tel = "";
  var adresse = "";
  // Create a text controller and use it to retrieve the current value
  // of the TextField.

  final emailController = TextEditingController();
  final nomController = TextEditingController();
  final telp = TextEditingController();
  final adressee = TextEditingController();
  List listItem = ["Technicien", "Comptable"];
  bool isHiddenPassword = true;
  // ignore: prefer_typing_uninitialized_variables
  var ch;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    telp.dispose();
    emailController.dispose();
    nomController.dispose();
    adressee.dispose();

    super.dispose();
  }

  late String dropdown;

  clearText() {
    telp.clear();
    emailController.clear();
    nomController.clear();
    adressee.clear();
  }

  // ignore: prefer_const_constructors
  ImageProvider<Object> networkImage = NetworkImage(
      "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png");
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
          child: Column(
            children: [
              Center(
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 60.0,
                        // ignore: unnecessary_null_comparison
                        backgroundImage: imageFile == null
                            ? networkImage
                            : FileImage(
                                File(imageFile!.path),
                              ),
                      ),
                    ),
                    Positioned(
                      bottom: 23.0,
                      right: 20.0,
                      child: InkWell(
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              builder: ((builder) => bottomSheet()));
                        },
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.orange,
                          size: 28.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: Form(
                key: _formKey,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: Column(
                    children: [
                      Expanded(
                          child: ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 15, left: 10, right: 10),
                            child: TextFormField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: buildInputDecoration(
                                Icons.email,
                                "Adresse électronique professionnelle",
                                color: Colors.white,
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Veuillez entrer  adresse e-mail ";
                                }
                                if (!RegExp(
                                        "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                    .hasMatch(value)) {
                                  return "Veuillez entrer  adresse e-mail ";
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 15, left: 10, right: 10),
                            child: TextFormField(
                              controller: nomController,
                              keyboardType: TextInputType.text,
                              decoration: buildInputDecoration(
                                Icons.person,
                                "Nom de l'employé",
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
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 20, left: 70, right: 70, top: 10),
                            child: DropdownButton(
                              hint: const Text("Poste occupé "),
                              dropdownColor: Colors.white,
                              icon: const Padding(
                                padding: EdgeInsets.only(left: 50),
                                child: Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.orange,
                                ),
                              ),
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.black),
                              iconSize: 40,
                              value: ch,
                              onChanged: (newValue) {
                                setState(() {
                                  ch = newValue.toString();
                                });
                              },
                              items: listItem.map((valueItem) {
                                return DropdownMenuItem(
                                  value: valueItem,
                                  child: Text(valueItem),
                                );
                              }).toList(),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  // Validate returns true if the form is valid, otherwise false.
                                  if (_formKey.currentState!.validate()) {
                                    if (ch != null) {
                                      setState(() {
                                        email = emailController.text;
                                        nom = nomController.text;
                                        tel = telp.text;
                                        adresse = adressee.text;
                                        role = ch;
                                        if (imageFile == null) {
                                          Employe().addEmploye(
                                              email,
                                              nom,
                                              tel,
                                              adresse,
                                              role,
                                              "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png");
                                        } else {
                                          uploadImage(email);
                                        }

                                        clearText();
                                        ch = null;
                                        imageFile = null;
                                      });
                                    } else {
                                      showToast(
                                          "veuillez sélectionner poste occupé ");
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
                    ],
                  ),
                ),
              )),
            ],
          ),
        ));
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(children: <Widget>[
        const Text(
          "Choisissez la photo de profil",
          style: TextStyle(fontSize: 20.0),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton.icon(
              onPressed: () {
                takePhoto(ImageSource.camera);
              },
              icon: const Icon(Icons.camera),
              label: const Text("Appareil photo"),
            ),
            FlatButton.icon(
              onPressed: () {
                takePhoto(ImageSource.gallery);
              },
              icon: const Icon(Icons.camera),
              label: const Text("Galerie"),
            ),
          ],
        )
      ]),
    );
  }

  void takePhoto(ImageSource source) async {
    XFile? pickedFile = await picker.pickImage(source: source);
    setState(() {
      imageFile = pickedFile!;
    });
  }

  uploadImage(String email) async {
    // ignore: unused_local_variable
    final fileName = basename(imageFile!.path);
    // ignore: prefer_const_declarations
    final destination = 'images';

    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child('$email/');
      UploadTask uploadTask = ref.putFile(File(imageFile!.path));
      await uploadTask.whenComplete(() async {
        var uploadPath = await uploadTask.snapshot.ref.getDownloadURL();

        Employe().addEmploye(email, nom, tel, adresse, role, uploadPath);
      });
    } catch (e) {
      // ignore: avoid_print
      print('error occured');
    }
  }

  showToast(mssg) => Fluttertoast.showToast(
      msg: mssg,
      fontSize: 20,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.red,
      textColor: Colors.white);
}
