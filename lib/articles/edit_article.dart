import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
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
              var code_barres = data!['code_barres'];
              var reference_interne = data['reference_interne'];
              var reference_fabricant = data['reference_fabricant '];
              var prix_vente = data['prix_vente '];
              var taxes_a_la_vente = data['taxes_a_la_vente'];
              var prix_dachat = data['prix_dachat'];
              var sale_prix = data['sale_prix'];
              var prix_de_vente = data['prix_de_vente '];
              var nom = data['nom'];
              var type = data['type'];
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
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10.0),
                        child: TextFormField(
                          initialValue: nom,
                          autofocus: false,
                          keyboardType: TextInputType.text,
                          onChanged: (value) => nom = value,
                          decoration: buildInputDecoration(
                            Icons.article,
                            "Nom de article",
                            color: Colors.white,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez entrer le nom darticle';
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10.0),
                        child: TextFormField(
                          initialValue: code_barres,
                          autofocus: false,
                          keyboardType: TextInputType.number,
                          onChanged: (value) => code_barres = value,
                          decoration: buildInputDecoration(
                            Icons.qr_code,
                            "code à barres",
                            color: Colors.white,
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Veuillez entrer le code à barres';
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10.0),
                        child: TextFormField(
                          initialValue: reference_interne,
                          autofocus: false,
                          onChanged: (value) => reference_interne = value,
                          decoration: buildInputDecoration(
                            Icons.recent_actors,
                            "référence interne",
                            color: Colors.white,
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Veuillez entrer la référence interne';
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10.0),
                        child: TextFormField(
                          initialValue: reference_fabricant,
                          autofocus: false,
                          onChanged: (value) => reference_fabricant = value,
                          decoration: buildInputDecoration(
                            Icons.person_pin_rounded,
                            "référence fabricant",
                            color: Colors.white,
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Veuillez entrer la référence fabricant';
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10.0),
                        child: TextFormField(
                          initialValue: prix_vente,
                          autofocus: false,
                          onChanged: (value) => prix_vente = value,
                          decoration: buildInputDecoration(
                            Icons.verified_outlined,
                            "prix vente",
                            color: Colors.white,
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Veuillez entrer la prix de vente';
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10.0),
                        child: TextFormField(
                          initialValue: taxes_a_la_vente,
                          autofocus: false,
                          onChanged: (value) => taxes_a_la_vente = value,
                          decoration: buildInputDecoration(
                            Icons.vignette,
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
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10.0),
                        child: TextFormField(
                          initialValue: prix_dachat,
                          autofocus: false,
                          onChanged: (value) => prix_dachat = value,
                          decoration: buildInputDecoration(
                            Icons.monetization_on,
                            "prix d'achat",
                            color: Colors.white,
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Veuillez entrer le prix d'achat";
                            }
                            return null;
                          },
                        ),
                      ),

                      // ignore: avoid_unnece
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10.0),
                        child: TextFormField(
                          initialValue: sale_prix,
                          autofocus: false,
                          onChanged: (value) => sale_prix = value,
                          decoration: buildInputDecoration(
                            Icons.point_of_sale,
                            "sale prix",
                            color: Colors.white,
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Veuillez entrer la sale prix ';
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10.0),
                        child: TextFormField(
                          initialValue: prix_de_vente,
                          autofocus: false,
                          onChanged: (value) => prix_de_vente = value,
                          decoration: buildInputDecoration(
                            Icons.price_change,
                            "prix de vente",
                            color: Colors.white,
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Veuillez entrer le prix de vente';
                            }
                            return null;
                          },
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
                                    Article().updateArticle(
                                        type,
                                        nom,
                                        code_barres,
                                        reference_interne,
                                        reference_fabricant,
                                        prix_vente,
                                        taxes_a_la_vente,
                                        prix_dachat,
                                        sale_prix,
                                        prix_de_vente,
                                        imageUrl);
                                  } else {
                                    uploadImage(
                                      type,
                                      nom,
                                      code_barres,
                                      reference_interne,
                                      reference_fabricant,
                                      prix_vente,
                                      taxes_a_la_vente,
                                      prix_dachat,
                                      sale_prix,
                                      prix_de_vente,
                                    );
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
      code_barres,
      reference_interne,
      reference_fabricant,
      prix_vente,
      taxes_a_la_vente,
      prix_dachat,
      sale_prix,
      prix_de_vente,
      type) async {
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
          uploadPath,
          type,
          nom,
          code_barres,
          reference_interne,
          reference_fabricant,
          prix_vente,
          taxes_a_la_vente,
          prix_dachat,
          sale_prix,
          prix_de_vente,
        );
      });
    } catch (e) {
      // ignore: avoid_print
      print('error occured');
    }
  }
}
