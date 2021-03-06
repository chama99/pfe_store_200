// ignore_for_file: unused_import, deprecated_member_use, non_constant_identifier_names, must_be_immutable

// ignore: avoid_web_libraries_in_flutter

import 'dart:io';

import 'package:chama_projet/clients/contact_home_page.dart';
import 'package:chama_projet/services/contact.dart';
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
import '../widget/NavBottom.dart';
import '../widget/toast.dart';

class CreeContactPage extends StatefulWidget {
  String emailus, nameus, url, roleus, adrus, telus, idus;

  List accesus;
  CreeContactPage({
    Key? key,
    required this.idus,
    required this.url,
    required this.emailus,
    required this.nameus,
    required this.roleus,
    required this.accesus,
    required this.telus,
    required this.adrus,
  }) : super(key: key);

  @override
  _CreeContactPageState createState() => _CreeContactPageState();
}

class _CreeContactPageState extends State<CreeContactPage> {
  List NomContact = [];
  @override
  void initState() {
    super.initState();

    fetchDatabaseList();
  }

  fetchDatabaseList() async {
    dynamic resultant = await Client().getContactListByNom();

    if (resultant == null) {
      // ignore: avoid_print
      print('Unable to retrieve');
    } else {
      setState(() {
        NomContact = resultant;
      });
    }
  }

  bool VerificationContactByNom(String nom) {
    bool b = false;
    for (int i = 0; i < NomContact.length; i++) {
      if (nom == NomContact[i]) {
        b = true;
      }
    }
    return b;
  }

  final String uuid = GUIDGen.generate();

  XFile? imageFile;

  final ImagePicker picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  late String imageUrl;
  // ignore: prefer_typing_uninitialized_variables
  var radio;
  String client = "client";
  String fournisseur = "fournisseur";

  var email = "";
  var nom = "";
  var tel = "";
  var adresse = "";
  var etiquette = "";
  // Create a text controller and use it to retrieve the current value
  // of the TextField.

  final emailController = TextEditingController();
  final nomController = TextEditingController();
  final telp = TextEditingController();
  final adressee = TextEditingController();
  final etiquettetroller = TextEditingController();

  bool isHiddenPassword = true;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    telp.dispose();
    emailController.dispose();
    nomController.dispose();
    adressee.dispose();
    etiquettetroller.dispose();

    super.dispose();
  }

  clearText() {
    telp.clear();
    emailController.clear();
    nomController.clear();
    adressee.clear();
    etiquettetroller.clear();
  }

  // ignore: prefer_const_constructors
  ImageProvider<Object> networkImage = NetworkImage(
      "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Cr??er Un Client"),
          backgroundColor: Colors.orange,
        ),
        bottomNavigationBar: NavBottom(
            tel: widget.telus,
            adr: widget.adrus,
            id: widget.idus,
            email: widget.emailus,
            name: widget.nameus,
            acces: widget.accesus,
            url: widget.url,
            role: widget.roleus),
        body: RefreshIndicator(
          onRefresh: () {
            Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                    // ignore: prefer_const_constructors
                    pageBuilder: (a, b, c) => CreeContactPage(
                        idus: widget.idus,
                        url: widget.url,
                        telus: widget.telus,
                        adrus: widget.adrus,
                        accesus: widget.accesus,
                        nameus: widget.nameus,
                        emailus: widget.emailus,
                        roleus: widget.roleus),
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
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  child: Column(
                    children: [
                      Expanded(
                          child: ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 15, left: 10, right: 10),
                            child: TextFormField(
                              controller: nomController,
                              keyboardType: TextInputType.text,
                              decoration: buildInputDecoration(
                                Icons.person,
                                "Nom de contact",
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
                                bottom: 15, left: 10, right: 10),
                            child: TextFormField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: buildInputDecoration(
                                Icons.email,
                                "Adresse ??lectronique professionnelle",
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
                                bottom: 20, left: 5, right: 5, top: 10),
                            child: TextFormField(
                              controller: telp,
                              keyboardType: TextInputType.number,
                              decoration: buildInputDecoration(
                                Icons.phone,
                                "T??l. portable professionnel",
                                color: Colors.white,
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Veuillez entrer t??l. portable professionnel';
                                }
                                return null;
                              },
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
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Veuillez entrer adresse professionnelle';
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 15, left: 10, right: 10),
                            child: TextFormField(
                              controller: etiquettetroller,
                              keyboardType: TextInputType.text,
                              decoration: buildInputDecoration(
                                Icons.vertical_distribute_sharp,
                                "Etiquette",
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
                                    if (VerificationContactByNom(
                                            nomController.text) ==
                                        false) {
                                      setState(() {
                                        email = emailController.text;
                                        nom = nomController.text;
                                        tel = telp.text;
                                        adresse = adressee.text;

                                        etiquette = etiquettetroller.text;
                                        if (imageFile == null) {
                                          Client().addContact(
                                              uuid,
                                              email,
                                              nom,
                                              tel,
                                              adresse,
                                              etiquette,
                                              "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png");
                                        } else {
                                          uploadImage(email);
                                        }

                                        clearText();
                                        radio = null;
                                        imageFile = null;
                                        Get.to(() => listContact(
                                            idus: widget.idus,
                                            url: widget.url,
                                            telus: widget.telus,
                                            adrus: widget.adrus,
                                            accesus: widget.accesus,
                                            nameus: widget.nameus,
                                            emailus: widget.emailus,
                                            roleus: widget.roleus));
                                      });
                                    } else {
                                      showToast("Nom de contact d??ja exist??");
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
        Client()
            .addContact(uuid, email, nom, tel, adresse, etiquette, uploadPath);
      });
    } catch (e) {
      // ignore: avoid_print
      print('error occured');
    }
  }
}
