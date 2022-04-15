import 'dart:io';

import 'package:chama_projet/articles/article_home_page.dart';
import 'package:chama_projet/services/article.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
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
  String data = '';
  _scan() async {
    await FlutterBarcodeScanner.scanBarcode(
            "#FFA500", "Annuler", true, ScanMode.BARCODE)
        .then((value) => setState(() => data = value));
  }

  final ImagePicker picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  late String imageUrl;
  var radio;
  String choix1 = "Peut être vendu";
  String choix2 = "Peut être acheté";
  String choix3 = "Peut être inséré dans un note de frais";
  var role = '';
  var type = '';
  var nom = "";
  var cat = "";
  var unite = "";
  var code_a_barre = "";
  var reference_interne = "";
  var ch;
  var chh;
  var chhh;
  var prix_vente = "";
  var taxes_a_la_vente = "";
  var prix_dachat = "";
  var sale_prix = "";
  var prix_de_vente = "";
  var etat;

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
  // Create a text controller and use it to retrieve the current value
  // of the TextField.

  final nomController = TextEditingController();
  final reference_interneController = TextEditingController();

  final prix_venteController = TextEditingController();
  final taxes_a_la_venteController = TextEditingController();
  final prix_dachatController = TextEditingController();
  final sale_prixController = TextEditingController();
  final prix_de_venteController = TextEditingController();
  final value = false;
  bool isHiddenPassword = true;
  late String dropdown1;
  late String dropdown2;
  late String dropdown3;
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.

    nomController.dispose();
    reference_interneController.dispose();

    prix_venteController.dispose();
    taxes_a_la_venteController.dispose();
    prix_dachatController.dispose();
    sale_prixController.dispose();
    prix_de_venteController.dispose();

    super.dispose();
  }

  clearText() {
    nomController.clear();
    reference_interneController.clear();

    prix_venteController.clear();
    taxes_a_la_venteController.clear();
    prix_dachatController.clear();
    sale_prixController.clear();
    prix_de_venteController.clear();
  }

  //zyda
  List nomarticle = [];
  @override
  void initState() {
    super.initState();

    fetchDatabaseList();
  }

  fetchDatabaseList() async {
    dynamic resultant = await Article().getArticleListByNom();

    if (resultant == null) {
      // ignore: avoid_print
      print('Unable to retrieve');
    } else {
      setState(() {
        nomarticle = resultant;
      });
    }
  }

  // ignore: prefer_const_constructors
  ImageProvider<Object> networkImage = NetworkImage(
      "https://avatar.anytimefitness.com/Content/Placeholders/camera.png");
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
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 1, left: 1, right: 1, top: 1),
                            child: DropdownButton(
                              hint: const Text("Type d'article"),
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
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 1, left: 1, right: 1, top: 1),
                            child: DropdownButton(
                              hint: const Text("Catégorie d'article "),
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
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FlatButton(
                                  onPressed: () => _scan(),
                                  child: Text(
                                    "code à barres",
                                    style: TextStyle(
                                      backgroundColor: Colors.orange,
                                      fontSize: 25,
                                      color: Colors.black,
                                    ),
                                  )),
                              Text(
                                data,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 25,
                                ),
                              ),
                            ],
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
                                bottom: 15, left: 10, right: 10),
                            child: TextFormField(
                              controller: prix_venteController,
                              keyboardType: TextInputType.number,
                              decoration: buildInputDecoration(
                                Icons.monetization_on,
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
                                Icons.monetization_on,
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
                                Icons.monetization_on,
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
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 1, left: 1, right: 1, top: 1),
                            child: DropdownButton(
                              hint: const Text("  Unité de mesure  "),
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
                              value: chhh,
                              onChanged: (newValue) {
                                setState(() {
                                  chhh = newValue.toString();
                                });
                              },
                              items: listItem2.map((valueItem) {
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
                                    if ((radio != null) &&
                                        (ch != null) &&
                                        (chh != null) &&
                                        (chhh != null)) {
                                      setState(() {
                                        nom = nomController.text;
                                        type = radio;
                                        role = ch;
                                        cat = chh;
                                        code_a_barre = data;
                                        reference_interne =
                                            reference_interneController.text;

                                        prix_vente = prix_venteController.text;
                                        taxes_a_la_vente =
                                            taxes_a_la_venteController.text;
                                        prix_dachat =
                                            prix_dachatController.text;
                                        sale_prix = sale_prixController.text;
                                        prix_de_vente =
                                            prix_de_venteController.text;

                                        unite = chhh;
                                        if (imageFile == null) {
                                          Article().addArticle(
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
                                              "https://avatar.anytimefitness.com/Content/Placeholders/camera.png");
                                        } else {
                                          uploadImage(imageUrl);
                                        }

                                        clearText();
                                        ch = null;
                                        chh = null;
                                        chhh = null;
                                        radio = null;
                                        imageFile = null;
                                        Get.to(() => const listArticle());
                                      });
                                    } else {
                                      showToast(
                                          "veuillez sélectionner un type darticle , catégorie darticle et unite de mesure ");
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
          imageUrl,
        );
        //type = '';
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
