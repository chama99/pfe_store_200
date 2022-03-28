import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import '../services/employe.dart';
import '../widget/InputDeco_design.dart';

class UpdateEmployePage extends StatefulWidget {
  final String nom;
  // ignore: prefer_const_constructors_in_immutables
  UpdateEmployePage({Key? key, required this.nom}) : super(key: key);

  @override
  _UpdateEmployePageState createState() => _UpdateEmployePageState();
}

class _UpdateEmployePageState extends State<UpdateEmployePage> {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  XFile? imageFile;

  final ImagePicker picker = ImagePicker();
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
      body: Form(
          key: _formKey,
          // Getting Specific Data by ID
          child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            future: FirebaseFirestore.instance
                .collection('employes')
                .doc(widget.nom)
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
              var email = data['email'];
              var adresse = data['Adresse professionnelle'];
              role = data['role'];
              var url = data['image'];
              // ignore: unused_local_variable
              var nom = data['name'];

              return Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  child: ListView(
                    children: [
                      Center(
                        child: Stack(children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              radius: 60.0,
                              // ignore: unnecessary_null_comparison
                              backgroundImage: imageFile == null
                                  ? NetworkImage(url) as ImageProvider
                                  : FileImage(
                                      File(imageFile!.path),
                                    ),
                            ),
                          ),
                          Positioned(
                            bottom: 25.0,
                            right: 15.0,
                            child: InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: ((builder) => bottomSheet()));
                              },
                              child: const Icon(
                                Icons.edit,
                                color: Colors.orange,
                                size: 28.0,
                              ),
                            ),
                          )
                        ]),
                      ),
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
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Entrer Name';
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10.0),
                        child: TextFormField(
                          initialValue: email,
                          autofocus: false,
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (value) => email = value,
                          decoration: buildInputDecoration(
                            Icons.email,
                            "Email",
                            color: Colors.white,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Entrer Email';
                            } else if (!value.contains('@')) {
                              return ' Entrer Valid Email';
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10.0),
                        child: TextFormField(
                          initialValue: adresse,
                          autofocus: false,
                          onChanged: (value) => adresse = value,
                          decoration: buildInputDecoration(
                            Icons.email,
                            "Adresse professionnelle",
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 20, left: 70, right: 70, top: 10),
                        child: DropdownButton(
                          dropdownColor: Colors.white,
                          icon: const Padding(
                            padding: EdgeInsets.only(left: 45),
                            child: Icon(
                              Icons.arrow_drop_down,
                              color: Colors.orange,
                            ),
                          ),
                          style: const TextStyle(
                              fontSize: 20, color: Colors.black),
                          iconSize: 40,
                          hint: Text(role),
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
                                  if (imageFile == null) {
                                    Employe().updateEmploye(email, widget.nom,
                                        tel, adresse, role, url);
                                  } else {
                                    uploadImage(
                                        email, widget.nom, tel, adresse);
                                  }
                                  Navigator.pop(context);
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
    );
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
            // ignore: deprecated_member_use
            FlatButton.icon(
              onPressed: () {
                takePhoto(ImageSource.camera);
              },
              icon: const Icon(Icons.camera),
              label: const Text("Appareil photo"),
            ),
            // ignore: deprecated_member_use
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

  uploadImage(String email, nom, tel, adresse) async {
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
        Employe()
            .updateEmploye(email, widget.nom, tel, adresse, role, uploadPath);
      });
    } catch (e) {
      // ignore: avoid_print
      print('error occured');
    }
  }
}
