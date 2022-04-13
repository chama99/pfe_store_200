// ignore_for_file: file_names, must_be_immutable

import 'package:chama_projet/pages/role.dart';
import 'package:chama_projet/services/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widget/toast.dart';

class AjoutAcces extends StatefulWidget {
  String name, email;

  String image;

  String role;

  String mp;
  List acces;

  AjoutAcces(
      {Key? key,
      required this.name,
      required this.email,
      required this.image,
      required this.role,
      required this.mp,
      required this.acces})
      : super(key: key);

  @override
  State<AjoutAcces> createState() => _AjoutAccesState();
}

class _AjoutAccesState extends State<AjoutAcces> {
  List roleList = [];
  var stock = "Inventaire";
  var achat = "Achats";
  var devis = "Devis";
  var uts = "Utilisateurs";
  var contact = "Contacts";
  var plan = "Plan";
  var mssg = "Message";
  var emp = "Employés";
  var fact = "Factures";
  var article = "Articles";
  var app = "Applications";
  var cong = "Conges";

  bool t = false;
  bool ap = false;
  bool ar = false;
  bool con = false;
  bool s = false;
  bool a = false;
  bool u = false;
  bool c = false;
  bool p = false;
  bool m = false;
  bool e = false;
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
                "Liste Des Applications",
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
                        showToast("$achat déjà existé");
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
                  value: ar,
                  onChanged: (value) {
                    setState(() {
                      ar = value!;

                      for (var i in widget.acces) {
                        if (i == article) {
                          t = true;
                        }
                      }
                      if (t == true) {
                        showToast("$article  déjà existé ");
                      }
                      if (t == false) {
                        roleList.add(article);
                      }
                    });
                  },
                ),
                Text(article),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(
                  activeColor: Colors.indigo,
                  value: ap,
                  onChanged: (value) {
                    setState(() {
                      ap = value!;

                      for (var i in widget.acces) {
                        if (i == app) {
                          t = true;
                        }
                      }
                      if (t == true) {
                        showToast("$app déjà existé");
                      }
                      if (t == false) {
                        roleList.add(app);
                      }
                    });
                  },
                ),
                Text(app),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(
                  activeColor: Colors.indigo,
                  value: con,
                  onChanged: (value) {
                    setState(() {
                      con = value!;

                      for (var i in widget.acces) {
                        if (i == cong) {
                          t = true;
                        }
                      }
                      if (t == true) {
                        showToast("$cong déjà existé ");
                      }
                      if (t == false) {
                        roleList.add(cong);
                      }
                    });
                  },
                ),
                Text(cong),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(
                  activeColor: Colors.indigo,
                  value: u,
                  onChanged: (value) {
                    setState(() {
                      u = value!;
                      for (var i in widget.acces) {
                        if (i == uts) {
                          t = true;
                        }
                      }
                      if (t == true) {
                        showToast("$uts déjà existé");
                      }
                      if (t == false) {
                        roleList.add(uts);
                      }
                    });
                  },
                ),
                Text(uts),
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
                        showToast("$contact  déjà existé");
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
                        showToast("$devis  déjà existé");
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
                        showToast("$fact déjà existé");
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
                        showToast("$mssg  déjà existé");
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
                        showToast("$plan déjà existé ");
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
                  value: e,
                  onChanged: (value) {
                    setState(() {
                      e = value!;
                      for (var i in widget.acces) {
                        if (i == emp) {
                          t = true;
                        }
                      }
                      if (t == true) {
                        showToast("$emp déjà existé ");
                      }
                      if (t == false) {
                        roleList.add(emp);
                      }
                    });
                  },
                ),
                Text(emp),
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
                        showToast("$stock déjà existé");
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
                    Get.to(() => const Roles());
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
}
