// ignore_for_file: file_names, must_be_immutable

import 'package:chama_projet/services/user.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AjoutRole extends StatefulWidget {
  String name, email;

  String image;

  String role;

  String mp;
  List acces;

  AjoutRole(
      {Key? key,
      required this.name,
      required this.email,
      required this.image,
      required this.role,
      required this.mp,
      required this.acces})
      : super(key: key);

  @override
  State<AjoutRole> createState() => _AjoutRoleState();
}

class _AjoutRoleState extends State<AjoutRole> {
  List roleList = [];
  var stock = "Stock";
  var achat = "Achat";
  var devis = "Devis";
  var config = "Configuration";
  var contact = "Contact";
  var plan = "Plan";
  var mssg = "Message";
  var notif = "Notificaion";
  var fact = "facture";

  bool t = false;

  bool s = false;
  bool a = false;
  bool c = false;
  bool g = false;
  bool p = false;
  bool m = false;
  bool n = false;
  bool d = false;
  bool f = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Utilisateur / ${widget.name}"),
        backgroundColor: Colors.orange,
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
              Text(
                "Liste De Role",
                style: TextStyle(
                    color: Colors.indigo,
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
              )
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(
                  activeColor: Colors.indigo,
                  value: a,
                  onChanged: (value) {
                    setState(() {
                      a = value!;

                      for (var i in widget.acces) {
                        if (i == achat) {
                          t = true;
                        }
                      }
                      if (t == true) {
                        showToast("Rôle existait déjà ");
                      }
                      if (t == false) {
                        roleList.add(achat);
                      }
                    });
                  },
                ),
                Text(achat),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(
                  activeColor: Colors.indigo,
                  value: g,
                  onChanged: (value) {
                    setState(() {
                      g = value!;
                      for (var i in widget.acces) {
                        if (i == config) {
                          t = true;
                        }
                      }
                      if (t == true) {
                        showToast("Rôle existait déjà ");
                      }
                      if (t == false) {
                        roleList.add(config);
                      }
                    });
                  },
                ),
                Text(config),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(
                  activeColor: Colors.indigo,
                  value: c,
                  onChanged: (value) {
                    setState(() {
                      c = value!;
                      for (var i in widget.acces) {
                        if (i == contact) {
                          t = true;
                        }
                      }
                      if (t == true) {
                        showToast("Rôle existait déjà ");
                      }
                      if (t == false) {
                        roleList.add(contact);
                      }
                    });
                  },
                ),
                Text(contact),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(
                  activeColor: Colors.indigo,
                  value: d,
                  onChanged: (value) {
                    setState(() {
                      d = value!;
                      for (var i in widget.acces) {
                        if (i == devis) {
                          t = true;
                        }
                      }
                      if (t == true) {
                        showToast("Rôle existait déjà ");
                      }
                      if (t == false) {
                        roleList.add(devis);
                      }
                    });
                  },
                ),
                Text(devis),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(
                  activeColor: Colors.indigo,
                  value: f,
                  onChanged: (value) {
                    setState(() {
                      f = value!;
                      for (var i in widget.acces) {
                        if (i == fact) {
                          t = true;
                        }
                      }
                      if (t == true) {
                        showToast("Rôle existait déjà ");
                      }
                      if (t == false) {
                        roleList.add(fact);
                      }
                    });
                  },
                ),
                Text(fact),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(
                  activeColor: Colors.indigo,
                  value: m,
                  onChanged: (value) {
                    setState(() {
                      m = value!;
                      for (var i in widget.acces) {
                        if (i == mssg) {
                          t = true;
                        }
                      }
                      if (t == true) {
                        showToast("Rôle existait déjà ");
                      }
                      if (t == false) {
                        roleList.add(mssg);
                      }
                    });
                  },
                ),
                Text(mssg),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(
                  activeColor: Colors.indigo,
                  value: n,
                  onChanged: (value) {
                    setState(() {
                      n = value!;
                      for (var i in widget.acces) {
                        if (i == notif) {
                          t = true;
                        }
                      }
                      if (t == true) {
                        showToast("Rôle existait déjà ");
                      }
                      if (t == false) {
                        roleList.add(notif);
                      }
                    });
                  },
                ),
                Text(notif),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(
                  activeColor: Colors.indigo,
                  value: p,
                  onChanged: (value) {
                    setState(() {
                      p = value!;
                      for (var i in widget.acces) {
                        if (i == plan) {
                          t = true;
                        }
                      }
                      if (t == true) {
                        showToast("Rôle existait déjà ");
                      }
                      if (t == false) {
                        roleList.add(plan);
                      }
                    });
                  },
                ),
                Text(plan),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(
                  activeColor: Colors.indigo,
                  value: s,
                  onChanged: (value) {
                    setState(() {
                      s = value!;
                      for (var i in widget.acces) {
                        if (i == stock) {
                          t = true;
                        }
                      }
                      if (t == true) {
                        showToast("Rôle existait déjà ");
                      }
                      if (t == false) {
                        roleList.add(stock);
                      }
                    });
                  },
                ),
                Text(stock),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    for (var ch in roleList) {
                      widget.acces.add(ch);
                    }
                    User().updateRoleUser(widget.email, widget.mp, widget.role,
                        widget.image, widget.acces, widget.name);
                  },
                  child: const Text(
                    "Ajouter",
                    style: TextStyle(fontSize: 18.0),
                  ),
                  style: ElevatedButton.styleFrom(primary: Colors.orange),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  showToast(mssg) => Fluttertoast.showToast(
      msg: mssg,
      fontSize: 50,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.red,
      textColor: Colors.white);
}
