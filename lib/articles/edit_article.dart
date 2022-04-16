import 'package:chama_projet/articles/article_home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:get/get.dart';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import '../services/article.dart';
import '../widget/InputDeco_design.dart';

class EditArticle extends StatefulWidget {
  final String nom;
  // ignore: prefer_const_constructors_in_immutables
  EditArticle({Key? key, required this.nom}) : super(key: key);

  @override
  _EditContactState createState() => _EditContactState();
}

class _EditContactState extends State<EditArticle> {
  var radio;
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  XFile? imageFile;

  late String imageUrl;
  final ImagePicker picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  List listItem = ["Article stockable", "Article consommable", "Service"];
  List listItem1 = [
    "Tous",
    "Accessoires",
    "Accessoires/adaptateur",
    "Accessoires/antichutes",
    "Accessoires/capteur",
    "Accessoires/invenseur+câble",
    "Accessoires/verrou",
    "Accessoires somfoy"
  ];
  List listItem2 = ["Jours", "Litres", "ML", "Piéces", "Kg"];
  var data;
  var role;
  var ch;
  var unite;
  var chh;
  var cat;
  var chhh;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Articles / ${widget.nom}",
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
                .collection('Articles')
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
              var nom = data!['nom'];
              var type = data['type'];
              role = data['role'];
              cat = data['cat'];

              var reference_interne = data['reference_interne'];

              var prix_vente = data['prix_vente '];
              var taxes_a_la_vente = data['taxes_a_la_vente'];
              var prix_dachat = data['prix_dachat'];
              var sale_prix = data['sale_prix'];
              var prix_de_vente = data['prix_de_vente '];

              unite = data['unite'];
              var url = data['image'];

              // ignore: unused_local_variable

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

                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 20, left: 1, right: 1, top: 10),
                        child: DropdownButton(
                          dropdownColor: Colors.white,
                          icon: const Padding(
                            padding: EdgeInsets.only(right: 1),
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
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 20, left: 0, right: 0, top: 1),
                        child: DropdownButton(
                          dropdownColor: Colors.white,
                          icon: const Padding(
                            padding: EdgeInsets.only(left: 1),
                            child: Icon(
                              Icons.arrow_drop_down,
                              color: Colors.orange,
                            ),
                          ),
                          style: const TextStyle(
                              fontSize: 20, color: Colors.black),
                          iconSize: 40,
                          hint: Text(cat),
                          value: chh,
                          onChanged: (newValue) {
                            setState(() {
                              chh = newValue.toString();
                            });
                          },
                          items: listItem1.map((valueItem) {
                            return DropdownMenuItem(
                              value: valueItem,
                              child: Text(valueItem),
                            );
                          }).toList(),
                        ),
                      ),

                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10.0),
                        child: TextFormField(
                          initialValue: prix_vente,
                          autofocus: false,
                          onChanged: (value) => prix_vente = value,
                          decoration: buildInputDecoration(
                            Icons.monetization_on,
                            "prix vente",
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10.0),
                        child: TextFormField(
                          initialValue: taxes_a_la_vente,
                          autofocus: false,
                          onChanged: (value) => taxes_a_la_vente = value,
                          decoration: buildInputDecoration(
                            Icons.monetization_on,
                            "taxes à la vente",
                            color: Colors.white,
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Veuillez entrer le taxe à la vente';
                            }
                            return null;
                          },
                        ),
                      ),

                      // ignore: avoid_unnece

                      // ignore: avoid_unnece
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10.0),
                        child: TextFormField(
                          initialValue: sale_prix,
                          autofocus: false,
                          onChanged: (value) => sale_prix = value,
                          decoration: buildInputDecoration(
                            Icons.monetization_on,
                            "sale prix",
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10.0),
                        child: TextFormField(
                          initialValue: prix_de_vente,
                          autofocus: false,
                          onChanged: (value) => prix_de_vente = value,
                          decoration: buildInputDecoration(
                            Icons.monetization_on,
                            "prix de vente",
                            color: Colors.white,
                          ),
                        ),
                      ),

                      // ignore: avoid_unnece

                      // ignore: avoid_unnece

                      // ignore: avoid_unnecessary_containers
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                // Validate returns true if the form is valid, otherwise false.
                                if (_formKey.currentState!.validate()) {
                                  if (radio != null) {
                                    type = radio;
                                  }
                                  if (imageFile == null) {
                                    var updateArticle = Article().updateArticle(
                                        nom,
                                        type,
                                        role,
                                        cat,
                                        data,
                                        reference_interne,
                                        prix_vente,
                                        taxes_a_la_vente,
                                        prix_dachat,
                                        sale_prix,
                                        prix_de_vente,
                                        unite,
                                        url);
                                  } else {
                                    uploadImage(
                                      nom,
                                      type,
                                      role,
                                      cat,
                                      data,
                                      reference_interne,
                                      prix_vente,
                                      taxes_a_la_vente,
                                      prix_dachat,
                                      sale_prix,
                                      prix_de_vente,
                                      unite,
                                    );
                                  }
                                  // Get.to(() => const listArticle());
                                  Get.to(() => const listArticle());
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
          "Choisissez l'image de l'article",
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

  uploadImage(
    String nom,
    type,
    role,
    cat,
    data,
    reference_interne,
    prix_vente,
    taxes_a_la_vente,
    prix_dachat,
    sale_prix,
    prix_de_vente,
    unite,
  ) async {
    // ignore: unused_local_variable
    final fileName = basename(imageFile!.path);
    // ignore: prefer_const_declarations
    final destination = 'images';

    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child('$imageUrl/');
      UploadTask uploadTask = ref.putFile(File(imageFile!.path));
      await uploadTask.whenComplete(() async {
        var uploadPath = await uploadTask.snapshot.ref.getDownloadURL();
        Article().updateArticle(
          nom,
          type,
          role,
          cat,
          data,
          reference_interne,
          prix_vente,
          taxes_a_la_vente,
          prix_dachat,
          sale_prix,
          prix_de_vente,
          unite,
          uploadPath,
        );
      });
    } catch (e) {
      // ignore: avoid_print
      print('error occured');
    }
  }
}
