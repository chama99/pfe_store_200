import 'dart:io';

import 'package:chama_projet/services/article.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import '../widget/InputDeco_design.dart';

class CreeArticlePage extends StatefulWidget {
  const CreeArticlePage({Key? key}) : super(key: key);

  @override
  _CreeArticlePageState createState() => _CreeArticlePageState();
}

class _CreeArticlePageState extends State<CreeArticlePage> {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  XFile? imageFile;

  final ImagePicker picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  late String imageUrl;
  var radio;
  String choix1 = "Peut être vendu";
  String choix2 = "Peut être acheté";
  String choix3 = "Peut être inséré dans un note de frais";
  String choix4 = "option(H/L)";
  String choix5 = "Puissance";

  var type = '';
  var nom = "";
  var code_barres = "";
  var reference_interne = "";
  var reference_fabricant = "";
  var prix_vente = "";
  var taxes_a_la_vente = "";
  var prix_dachat = "";
  var sale_prix = "";
  var prix_de_vente = "";
  // Create a text controller and use it to retrieve the current value
  // of the TextField.

  final code_barresController = TextEditingController();
  final nomController = TextEditingController();
  final reference_interneController = TextEditingController();
  final reference_fabricantController = TextEditingController();
  final prix_venteController = TextEditingController();
  final taxes_a_la_venteController = TextEditingController();
  final prix_dachatController = TextEditingController();
  final sale_prixController = TextEditingController();
  final prix_de_venteController = TextEditingController();
  final value = false;
  bool isHiddenPassword = true;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    code_barresController.dispose();
    nomController.dispose();
    reference_interneController.dispose();
    reference_fabricantController.dispose();
    prix_venteController.dispose();
    taxes_a_la_venteController.dispose();
    prix_dachatController.dispose();
    sale_prixController.dispose();
    prix_de_venteController.dispose();

    super.dispose();
  }

  late String dropdown;

  clearText() {
    code_barresController.clear();
    nomController.clear();
    reference_interneController.clear();
    reference_fabricantController.clear();
    prix_venteController.clear();
    taxes_a_la_venteController.clear();
    prix_dachatController.clear();
    sale_prixController.clear();
    prix_de_venteController.clear();
  }

  // ignore: prefer_const_constructors
  ImageProvider<Object> networkImage = NetworkImage(
      "https://cdn3.vectorstock.com/i/1000x1000/98/37/camera-with-a-orange-color-on-a-blue-background-vector-35539837.jpg");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Créer Un Article"),
          backgroundColor: Colors.orange,
        ),
        body: RefreshIndicator(
          onRefresh: () {
            Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                    // ignore: prefer_const_constructors
                    pageBuilder: (a, b, c) => CreeArticlePage(),
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
                                Icons.article,
                                "Nom de article",
                                color: Colors.white,
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Veuillez entrer le nom darticle';
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 15, left: 10, right: 10),
                            child: TextFormField(
                              controller: code_barresController,
                              keyboardType: TextInputType.number,
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
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 20, left: 5, right: 5, top: 10),
                            child: TextFormField(
                              controller: reference_interneController,
                              keyboardType: TextInputType.number,
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
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 20, left: 5, right: 5, top: 10),
                            child: TextFormField(
                              controller: reference_fabricantController,
                              keyboardType: TextInputType.number,
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
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 15, left: 10, right: 10),
                            child: TextFormField(
                              controller: prix_venteController,
                              keyboardType: TextInputType.number,
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
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 15, left: 10, right: 10),
                            child: TextFormField(
                              controller: taxes_a_la_venteController,
                              keyboardType: TextInputType.number,
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
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 15, left: 10, right: 10),
                            child: TextFormField(
                              controller: prix_dachatController,
                              keyboardType: TextInputType.number,
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
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 15, left: 10, right: 10),
                            child: TextFormField(
                              controller: sale_prixController,
                              keyboardType: TextInputType.number,
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
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 15, left: 10, right: 10),
                            child: TextFormField(
                              controller: prix_de_venteController,
                              keyboardType: TextInputType.number,
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
                          RadioListTile(
                              title: const Text("Peut être vendu"),
                              value: choix1,
                              groupValue: radio,
                              onChanged: (value) {
                                setState(() {
                                  radio = value;
                                });
                              }),
                          RadioListTile(
                              title: const Text("Peut être acheté"),
                              value: choix2,
                              groupValue: radio,
                              onChanged: (value) {
                                setState(() {
                                  radio = value;
                                });
                              }),
                          RadioListTile(
                              title: const Text(
                                  "Peut être inséré dans un note de frais"),
                              value: choix3,
                              groupValue: radio,
                              onChanged: (value) {
                                setState(() {
                                  radio = value;
                                });
                              }),
                          RadioListTile(
                              title: const Text("option(H/L)"),
                              value: choix4,
                              groupValue: radio,
                              onChanged: (value) {
                                setState(() {
                                  radio = value;
                                });
                              }),
                          RadioListTile(
                              title: const Text("Puissance"),
                              value: choix5,
                              groupValue: radio,
                              onChanged: (value) {
                                setState(() {
                                  radio = value;
                                });
                              }),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  // Validate returns true if the form is valid, otherwise false.
                                  if (_formKey.currentState!.validate()) {
                                    if (radio != null) {
                                      setState(() {
                                        code_barres =
                                            code_barresController.text;
                                        nom = nomController.text;
                                        reference_interne =
                                            reference_interneController.text;
                                        reference_fabricant =
                                            reference_fabricantController.text;
                                        prix_vente = prix_venteController.text;
                                        taxes_a_la_vente =
                                            taxes_a_la_venteController.text;
                                        prix_dachat =
                                            prix_dachatController.text;
                                        sale_prix = sale_prixController.text;
                                        prix_de_vente =
                                            prix_de_venteController.text;
                                        type = radio;
                                        if (imageFile == null) {
                                          Article().addArticle(
                                              type,
                                              code_barres,
                                              nom,
                                              reference_interne,
                                              reference_fabricant,
                                              prix_vente,
                                              taxes_a_la_vente,
                                              prix_dachat,
                                              sale_prix,
                                              prix_de_vente,
                                              "https://cdn3.vectorstock.com/i/1000x1000/98/37/camera-with-a-orange-color-on-a-blue-background-vector-35539837.jpg");
                                        } else {
                                          uploadImage(imageUrl);
                                        }

                                        clearText();
                                        radio = null;
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
          "Choisissez la photo d'article'",
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

  uploadImage(String imageUrl) async {
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
        Article().addArticle(
            type,
            nom,
            code_barres,
            reference_interne,
            reference_fabricant,
            prix_vente,
            prix_dachat,
            taxes_a_la_vente,
            sale_prix,
            prix_de_vente,
            uploadPath);
        type = '';
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
