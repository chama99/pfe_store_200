// ignore_for_file: must_be_immutable

import 'package:chama_projet/services/contact.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:get/get.dart';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import '../widget/InputDeco_design.dart';
import '../widget/NavBottom.dart';
import 'contact_home_page.dart';

class EditContact extends StatefulWidget {
  final String nom, id;
  String emailus, nameus, url, roleus, adrus, telus, idus;

  List accesus;
  // ignore: prefer_const_constructors_in_immutables
  EditContact({
    Key? key,
    required this.nom,
    required this.id,
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
  _EditContactState createState() => _EditContactState();
}

class _EditContactState extends State<EditContact> {
  // ignore: prefer_typing_uninitialized_variables
  var radio;
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  XFile? imageFile;

  final ImagePicker picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Client / ${widget.nom}",
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
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
      body: Form(
          key: _formKey,
          // Getting Specific Data by ID
          child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            future: FirebaseFirestore.instance
                .collection('clients')
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
              var email = data['email'];
              var adresse = data['Adresse professionnelle'];
              var type = data['type'];
              var url = data['image'];
              var etiquette = data['Etiquette'];
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
                            Icons.location_on,
                            "Adresse professionnelle",
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10.0),
                        child: TextFormField(
                          initialValue: etiquette,
                          autofocus: false,
                          onChanged: (value) => etiquette = value,
                          decoration: buildInputDecoration(
                            Icons.vertical_distribute_sharp,
                            "Etiquette",
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
                                  if (imageFile == null) {
                                    Client().updateContact(widget.id, email,
                                        nom, tel, adresse, etiquette, url);
                                  } else {
                                    uploadImage(email, widget.nom, tel, adresse,
                                        type, etiquette);
                                  }
                                  Get.to(() => listContact(
                                      idus: widget.idus,
                                      url: widget.url,
                                      telus: widget.telus,
                                      adrus: widget.adrus,
                                      accesus: widget.accesus,
                                      nameus: widget.nameus,
                                      emailus: widget.emailus,
                                      roleus: widget.roleus));
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

  uploadImage(String email, nom, tel, adresse, type, etiquette) async {
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
        Client().updateContact(
            widget.id, email, nom, tel, adresse, etiquette, uploadPath);
      });
    } catch (e) {
      // ignore: avoid_print
      print('error occured');
    }
  }
}
