// ignore_for_file: deprecated_member_use

import 'package:chama_projet/services/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../widget/InputDeco_design.dart';
import '../widget/menuAdmin.dart';

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

  final firestoreInstance = FirebaseFirestore.instance;

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    fetchDatabaseListByEmail();
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
    if (t == true) {
      firestoreInstance.collection("users").doc(e).get().then((value) {
        String email = value.data()!["email"];
        String mdp = value.data()!["mot de passe"];
        String name = value.data()!["name"];
        List acces = value.data()!["acces"];
        String url = value.data()!["image"];
        if (e == email && m == mdp) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MenuAdmin(
                        email: email,
                        name: name,
                        acces: acces,
                        url: url,
                      )));
        } else {
          showToast("Mauvais  mot de passe");
        }
      });
    } else {
      showToast(" Mauvais nom d'utilisateur ");
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
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 18, left: 10, right: 10),
                        child: InkWell(
                          onTap: () {},
                          child: Text(
                            "Mot de passe oublié ?".toUpperCase(),
                            style: const TextStyle(
                                fontSize: 12,
                                color: Colors.indigo,
                                letterSpacing: 1.7),
                            textAlign: TextAlign.left,
                          ),
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

  showToast(mssg) => Fluttertoast.showToast(
      msg: mssg,
      fontSize: 20,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.red,
      textColor: Colors.white);
}
