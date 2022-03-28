// ignore_for_file: unused_import, deprecated_member_use, avoid_print, prefer_const_constructors

// ignore: avoid_web_libraries_in_flutter

import 'dart:io';
import 'package:chama_projet/services/user.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import '../services/employe.dart';
import '../widget/InputDeco_design.dart';

class AddUserPage extends StatefulWidget {
  const AddUserPage({Key? key}) : super(key: key);

  @override
  _AddUserPageState createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  @override
  void initState() {
    super.initState();

    fetchDatabaseList();
  }

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  XFile? imageFile;

  final ImagePicker picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  late String imageUrl;

  var role = "";
  var email = "";
  var password = "";
  var r = "Poste occupé ";
  var nom = "";

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nomController = TextEditingController();
  final confirmpassword = TextEditingController();
  List listItem = ["Technicien", "Comptable"];
  bool isHiddenPassword = true;
  // ignore: prefer_typing_uninitialized_variables
  var ch;

  // ignore: non_constant_identifier_names
  List NomsEmpList = [];
  fetchDatabaseList() async {
    dynamic resultant = await Employe().getEmployesListByNom();

    if (resultant == null) {
      print('Unable to retrieve');
    } else {
      setState(() {
        NomsEmpList = resultant;
      });
    }
  }

  // ignore: non_constant_identifier_names
  bool Test(String nom) {
    bool b = false;
    for (int i = 0; i < NomsEmpList.length; i++) {
      if (nom == NomsEmpList[i]) {
        b = true;
      }
    }
    return b;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    confirmpassword.dispose();
    emailController.dispose();
    passwordController.dispose();
    nomController.dispose();

    super.dispose();
  }

  clearText() {
    confirmpassword.clear();
    emailController.clear();
    passwordController.clear();
    nomController.clear();
  }

  ImageProvider<Object> networkImage = NetworkImage(
      "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Créer Un Utilisateur"),
          backgroundColor: Colors.orange,
        ),
        body: RefreshIndicator(
          onRefresh: () {
            Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                    pageBuilder: (a, b, c) => AddUserPage(),
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
                              controller: nomController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: buildInputDecoration(
                                Icons.person,
                                "Nom",
                                color: Colors.white,
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
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
                              controller: passwordController,
                              keyboardType: TextInputType.text,
                              obscureText: isHiddenPassword,
                              decoration: buildInputDecoration(
                                Icons.lock,
                                "Mot de passe",
                                color: Colors.white,
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Veuillez entrer votre mot de passe';
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 20, left: 5, right: 5, top: 10),
                            child: TextFormField(
                              controller: confirmpassword,
                              obscureText: isHiddenPassword,
                              keyboardType: TextInputType.text,
                              decoration: buildInputDecoration(
                                Icons.lock,
                                "Confirmez le mot de passe",
                                color: Colors.white,
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Veuillez entrer votre mot de passe';
                                }

                                print(passwordController.text);

                                print(confirmpassword.text);

                                if (passwordController.text !=
                                    confirmpassword.text) {
                                  return "Le mot de passe ne correspond pas ";
                                }

                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 20, left: 70, right: 70, top: 10),
                            child: DropdownButton(
                              hint: Text(r),
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
                                  if (_formKey.currentState!.validate() &&
                                      Test(nomController.text)) {
                                    setState(() {
                                      nom = nomController.text;
                                      email = emailController.text;
                                      password = passwordController.text;
                                      role = ch;
                                      if (imageFile == null) {
                                        User().addUser(
                                            email,
                                            nom,
                                            password,
                                            role,
                                            "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png");
                                      } else {
                                        uploadImage(email);
                                      }

                                      clearText();
                                      ch = null;
                                      imageFile = null;

                                      print(NomsEmpList);
                                    });
                                  } else {
                                    showToast("Nom de l'employé n'existe pas");
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
        User().addUser(email, nom, password, role, uploadPath);
      });
    } catch (e) {
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
