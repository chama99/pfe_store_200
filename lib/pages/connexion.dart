// ignore_for_file: deprecated_member_use, unused_import

import 'package:chama_projet/services/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';

import 'package:flutter/material.dart';
import 'dart:convert' show base64, utf8;
import '../widget/InputDeco_design.dart';
import '../widget/menuAdmin.dart';
import '../widget/toast.dart';

class Connexion extends StatefulWidget {
  const Connexion({Key? key}) : super(key: key);

  @override
  _connexion createState() => _connexion();
}

// ignore: camel_case_types
class _connexion extends State<Connexion> {
  //TextController to read text entered in text field
  TextEditingController password = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController id = TextEditingController();

  bool isHiddenPassword = true;
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  final firestoreInstance = FirebaseFirestore.instance;

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  @override
  void initState() {
    getData().then((client) {
      for (int i = 0; i < client.length; i++) {
        users.add(client[i]);
      }
    });
    super.initState();
    fetchDatabaseListByEmail();
  }

  List users = [];
  String motp = "";
  Future getData() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await usersCollection.get();

    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  String idu = "";
  UserDonnes(String value) {
    var user = users.where(((e) => e["email"] == value)).toList();
    if (user.isNotEmpty) {
      setState(() {
        idu = user[0]["IdUser"];
      });
    }
    return idu;
  }

  List useListByEmail = [];
  fetchDatabaseListByEmail() async {
    dynamic resul = await User().getUsersByEmail();
    if (resul == null) {
      // ignore: avoid_print
      print('Unable to retrieve');
    } else {
      setState(() {
        useListByEmail = resul;
      });
    }
  }

  verifydonnes(String e, String m) {
    // ignore: unused_local_variable
    bool t = false;
    for (var ch in useListByEmail) {
      if (e == ch) {
        t = true;
      }
    }
    var iduu = UserDonnes(e);
    if (t == true) {
      firestoreInstance.collection("users").doc(iduu).get().then((value) {
        String email = value.data()!["email"];
        String mdp = value.data()!["mot de passe"];
        String name = value.data()!["name"];
        List acces = value.data()!["acces"];
        String url = value.data()!["image"];
        String role = value.data()!["role"];
        String id = value.data()!["IdUser"];
        String tel = value.data()!["telephone"];
        String adr = value.data()!["adresse"];
        var decodeBytes = base64.decode(mdp);
        var decodeString = utf8.decode(decodeBytes);

        if (m == decodeString) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MenuAdmin(
                        id: id,
                        email: email,
                        name: name,
                        acces: acces,
                        url: url,
                        role: role,
                        tel: tel,
                        adr: adr,
                      )));
        } else {
          showToast("Mauvais  mot de passe");
        }
      });
    } else {
      showToast(" Email n'existe pas ");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 50,
          horizontal: 10,
        ),
        child: Center(
          child: RefreshIndicator(
              onRefresh: () {
                Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                        // ignore: prefer_const_constructors
                        pageBuilder: (a, b, c) => Connexion(),
                        // ignore: prefer_const_constructors
                        transitionDuration: Duration(seconds: 0)));
                // ignore: void_checks
                return Future.value(false);
              },
              child: SingleChildScrollView(
                child: Form(
                  key: _formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'asset/2.png',
                        height: 100.0,
                      ),
                      const Padding(
                        padding:
                            EdgeInsets.only(bottom: 15, left: 10, right: 10),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 15, left: 10, right: 10),
                        child: TextFormField(
                          controller: email,
                          keyboardType: TextInputType.emailAddress,
                          decoration: buildInputDecoration(
                            Icons.email,
                            "Email",
                            color: Colors.white,
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Veuillez entrer votre adresse e-mail ";
                            }
                            if (!RegExp(
                                    "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                .hasMatch(value)) {
                              return "Veuillez entrer votre adresse e-mail ";
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 15, left: 10, right: 10),
                        child: TextFormField(
                          controller: password,
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
                      SizedBox(
                        width: 200,
                        height: 50,
                        child: RaisedButton(
                          color: Colors.orange,
                          onPressed: () {
                            if (_formkey.currentState!.validate()) {
                              verifydonnes(email.text, password.text);
                              return;
                            } else {
                              // ignore: avoid_print
                              print("UnSuccessfull");
                            }
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          textColor: Colors.white,
                          child: const Text("Connexion"),
                        ),
                      ),
                      Image.network(
                        'https://store2000.fr/wp-content/uploads/2021/07/Artboard-1.png',
                        height: 400,
                      ),
                    ],
                  ),
                ),
              )),
        ),
      ),
    );
  }
}
