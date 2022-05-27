// ignore_for_file: file_names, must_be_immutable

import 'package:chama_projet/users/role.dart';
import 'package:chama_projet/services/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widget/NavBottom.dart';
import '../widget/toast.dart';

class AjoutAcces extends StatefulWidget {
  String id, name;
  String emailus, nameus, url, roleus, adrus, telus, idus;

  List accesus;
  List acces;

  AjoutAcces({
    Key? key,
    required this.id,
    required this.acces,
    required this.name,
    required this.idus,
    required this.url,
    required this.emailus,
    required this.nameus,
    required this.roleus,
    required this.accesus,
    required this.telus,
    required this.adrus,
  }) : super(key: key);

  @override
  State<AjoutAcces> createState() => _AjoutAccesState();
}

class _AjoutAccesState extends State<AjoutAcces> {
  List roleList = [];
  var stock = "Inventaire";

  var devis = "Devis";
  var uts = "Utilisateurs";
  var contact = "Clients";
  var plan = "Plan";

  var emp = "Employés";
  var fact = "Factures";
  var article = "Articles";
  var app = "Applications";
  var cong = "Clients";

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
      bottomNavigationBar: NavBottom(
          tel: widget.telus,
          adr: widget.adrus,
          id: widget.idus,
          email: widget.emailus,
          name: widget.nameus,
          acces: widget.accesus,
          url: widget.url,
          role: widget.roleus),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Stack(children: [
                  Text("Liste des applications",
                      style: TextStyle(
                        fontSize: 30,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 1.5
                          ..color = Color.fromARGB(255, 11, 64, 117),
                      )),
                ]),
              ]),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Checkbox(
                    activeColor: Color.fromARGB(255, 11, 64, 117),
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
                    activeColor: Color.fromARGB(255, 11, 64, 117),
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
                    activeColor: Color.fromARGB(255, 11, 64, 117),
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
                    activeColor: Color.fromARGB(255, 11, 64, 117),
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
                    activeColor: Color.fromARGB(255, 11, 64, 117),
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
                    activeColor: Color.fromARGB(255, 11, 64, 117),
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
                    activeColor: Color.fromARGB(255, 11, 64, 117),
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
                    activeColor: Color.fromARGB(255, 11, 64, 117),
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
                    activeColor: Color.fromARGB(255, 11, 64, 117),
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
                    activeColor: Color.fromARGB(255, 11, 64, 117),
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
                      User().updateRoleUser(widget.id, widget.acces);
                      Get.to(() => Roles(
                          idus: widget.idus,
                          url: widget.url,
                          telus: widget.telus,
                          adrus: widget.adrus,
                          accesus: widget.accesus,
                          nameus: widget.nameus,
                          emailus: widget.emailus,
                          roleus: widget.roleus));
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
      ),
    );
  }
}
