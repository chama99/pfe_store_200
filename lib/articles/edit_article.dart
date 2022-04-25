// ignore_for_file: prefer_typing_uninitialized_variables, avoid_unnecessary_containers, must_be_immutable, non_constant_identifier_names

import 'package:chama_projet/articles/article_home_page.dart';

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
  String id, nom, type, role, cat, data, unite;
  int reference_interne, sale_prix;
  double prix_dachat, prix_de_vente;
  String image;
  int qt;
  int taxes_a_la_vente;
  EditArticle({
    Key? key,
    required this.id,
    required this.nom,
    required this.type,
    required this.role,
    required this.cat,
    required this.data,
    required this.reference_interne,
    required this.taxes_a_la_vente,
    required this.prix_dachat,
    required this.sale_prix,
    required this.prix_de_vente,
    required this.unite,
    required this.image,
    required this.qt,
  }) : super(key: key);

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
    "Accessoires",
    "Accessoires/adaptateur",
    "Accessoires/antichutes",
    "Accessoires/capteur",
    "Accessoires/invenseur+câble",
    "Accessoires/verrou",
    "Accessoires somfoy"
  ];
  List listItem2 = ["Jours", "Litres", "ML", "Piéces", "Kg"];

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
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
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
                              ? NetworkImage(widget.image) as ImageProvider
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
                      style: const TextStyle(fontSize: 20, color: Colors.black),
                      iconSize: 40,
                      value: widget.role,
                      onChanged: (newValue) {
                        setState(() {
                          widget.role = newValue.toString();
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
                      style: const TextStyle(fontSize: 20, color: Colors.black),
                      iconSize: 40,
                      value: widget.cat,
                      onChanged: (newValue) {
                        setState(() {
                          widget.cat = newValue.toString();
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
                      initialValue: widget.qt.toString(),
                      autofocus: false,
                      onChanged: (value) => widget.qt = int.parse(value),
                      decoration: buildInputDecoration(
                        Icons.web_stories,
                        "Quantité",
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    child: TextFormField(
                      initialValue: "${widget.taxes_a_la_vente}",
                      autofocus: false,
                      onChanged: (value) =>
                          widget.taxes_a_la_vente = int.parse(value),
                      decoration: buildInputDecoration(
                        Icons.monetization_on,
                        "taxes à la vente",
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    child: TextFormField(
                      initialValue: "${widget.sale_prix}",
                      autofocus: false,
                      onChanged: (value) => widget.sale_prix = int.parse(value),
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
                      initialValue: "${widget.prix_de_vente}",
                      autofocus: false,
                      onChanged: (value) =>
                          widget.prix_de_vente = double.parse(value),
                      decoration: buildInputDecoration(
                        Icons.monetization_on,
                        "prix de vente",
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Validate returns true if the form is valid, otherwise false.
                            if (_formKey.currentState!.validate()) {
                              if (imageFile == null) {
                                Article().updateArticle(
                                    widget.id,
                                    widget.nom,
                                    widget.type,
                                    widget.role,
                                    widget.cat,
                                    widget.data,
                                    widget.reference_interne,
                                    widget.taxes_a_la_vente,
                                    widget.prix_dachat,
                                    widget.sale_prix,
                                    widget.prix_de_vente,
                                    widget.unite,
                                    widget.image,
                                    widget.qt);
                              } else {
                                uploadImage(
                                  widget.id,
                                  widget.nom,
                                  widget.type,
                                  widget.role,
                                  widget.cat,
                                  widget.data,
                                  widget.reference_interne,
                                  widget.taxes_a_la_vente,
                                  widget.prix_dachat,
                                  widget.sale_prix,
                                  widget.prix_de_vente,
                                  widget.unite,
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
                          style:
                              ElevatedButton.styleFrom(primary: Colors.orange),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
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
    id,
    nom,
    type,
    role,
    cat,
    data,
    referenceInterne,
    taxesALaVente,
    prixDachat,
    salePrix,
    prixDeVente,
    unite,
  ) async {
    // ignore: unused_local_variable
    final fileName = basename(imageFile!.path);
    // ignore: prefer_const_declarations
    final destination = 'images';

    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child('$nom/');
      UploadTask uploadTask = ref.putFile(File(imageFile!.path));
      await uploadTask.whenComplete(() async {
        var uploadPath = await uploadTask.snapshot.ref.getDownloadURL();
        Article().updateArticle(
            id,
            nom,
            type,
            role,
            cat,
            data,
            referenceInterne,
            taxesALaVente,
            prixDachat,
            salePrix,
            prixDeVente,
            unite,
            uploadPath,
            widget.qt);
      });
    } catch (e) {
      // ignore: avoid_print
      print('error occured');
    }
  }
}
