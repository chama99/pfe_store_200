import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/autofacture.dart';
import '../services/facture.dart';
import '../services/lignefact.dart';
import '../widget/NavBottom.dart';
import '../widget/toast.dart';
import 'AjoutLigneFact.dart';
import 'ModifierLigneFact.dart';
import 'listfact.dart';
import 'listfactdevis.dart';

class UpdateFacture extends StatefulWidget {
  String id, titre, etat, page, client, date1;
  List tab;
  int res;
  double montant, total;
  String emailus, nameus, url, roleus, adrus, telus, idus;

  List accesus;

  UpdateFacture({
    Key? key,
    required this.id,
    required this.titre,
    required this.tab,
    required this.etat,
    required this.res,
    required this.client,
    required this.page,
    required this.total,
    required this.montant,
    required this.date1,
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
  State<UpdateFacture> createState() => _UpdateFactureState();
}

class _UpdateFactureState extends State<UpdateFacture> {
  final _formKey = GlobalKey<FormState>();
  final n = TextEditingController();
  List listItem = ["Brouillon", "Payée", "Avoir"];
  DateTime dataTime = DateTime.now();
  double remise = 0.00;
  @override
  void initState() {
    super.initState();
    fetchDatabaseList();
  }

  List commandeList = [];

  fetchDatabaseList() async {
    dynamic resultant = await CommandeFact().getCommList();

    if (resultant == null) {
      // ignore: avoid_print
      print('Unable to retrieve');
    } else {
      setState(() {
        commandeList = resultant;
      });
    }
  }

  calculMontat() {
    var montant = 0.00;
    for (var i = 0; i < widget.tab.length; i++) {
      montant = montant + widget.tab[i]["sous-total"];
    }
    return montant;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.titre),
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
      body: RefreshIndicator(
        onRefresh: () {
          Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                  // ignore: prefer_const_constructors
                  pageBuilder: (a, b, c) => UpdateFacture(
                      id: widget.id,
                      titre: widget.titre,
                      tab: widget.tab,
                      etat: widget.etat,
                      res: widget.res,
                      client: widget.client,
                      page: widget.page,
                      total: widget.total,
                      montant: widget.montant,
                      date1: widget.date1,
                      idus: widget.idus,
                      url: widget.url,
                      telus: widget.telus,
                      adrus: widget.adrus,
                      accesus: widget.accesus,
                      nameus: widget.nameus,
                      emailus: widget.emailus,
                      roleus: widget.roleus),
                  // ignore: prefer_const_constructors
                  transitionDuration: Duration(seconds: 0)));
          // ignore: void_checks
          return Future.value(false);
        },
        child: Container(
          color: Colors.grey[200],
          child: Column(
            children: [
              Expanded(
                  child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Expanded(
                        child: ListView(
                      children: [
                        Container(
                          color: Colors.white,
                          margin: const EdgeInsets.only(top: 30),
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  color: Colors.orange[100],
                                ),
                                child: Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        Get.to(() => AjoutLigneFacture(
                                            id: widget.id,
                                            titre: widget.titre,
                                            commande: widget.tab,
                                            client: widget.client,
                                            date1: widget.date1,
                                            etat: widget.etat,
                                            montant: widget.montant,
                                            remise: remise,
                                            total: widget.total,
                                            res: widget.res,
                                            page: widget.page,
                                            idus: widget.idus,
                                            url: widget.url,
                                            telus: widget.telus,
                                            adrus: widget.adrus,
                                            accesus: widget.accesus,
                                            nameus: widget.nameus,
                                            emailus: widget.emailus,
                                            roleus: widget.roleus));
                                      },
                                      icon: const Icon(
                                        Icons.add,
                                        color: Colors.orange,
                                      ),
                                    ),
                                    const Text(
                                      "Ajouter lignes de commande ",
                                      style: TextStyle(
                                          fontSize: 15,
                                          letterSpacing: 3,
                                          color: Colors.indigo),
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  color: Colors.orange[100],
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            if (n.text.isEmpty) {
                                              showToast(
                                                  "Veuillez entrer Numéro de ligne");
                                            } else if (int.parse(n.text) >
                                                widget.tab.length - 1) {
                                              showToast(
                                                  "le numéro de ligne n'existe pas");
                                            } else {
                                              Get.to(() => ModifieLignFact(
                                                  id: widget.id,
                                                  titre: widget.titre,
                                                  commande: widget.tab,
                                                  num: int.parse(n.text),
                                                  client: widget.client,
                                                  date1: widget.date1,
                                                  etat: widget.etat,
                                                  montant: widget.montant,
                                                  remise: remise,
                                                  total: widget.total,
                                                  res: widget.res,
                                                  page: widget.page,
                                                  idus: widget.idus,
                                                  url: widget.url,
                                                  telus: widget.telus,
                                                  adrus: widget.adrus,
                                                  accesus: widget.accesus,
                                                  nameus: widget.nameus,
                                                  emailus: widget.emailus,
                                                  roleus: widget.roleus));
                                            }
                                          },
                                          icon: const Icon(
                                            Icons.edit,
                                            color: Colors.orange,
                                          ),
                                        ),
                                        const Text(
                                          "Modifier la commande Numéro :",
                                          style: TextStyle(
                                              fontSize: 15,
                                              letterSpacing: 3,
                                              color: Colors.indigo),
                                          textAlign: TextAlign.left,
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 150, bottom: 10, left: 150),
                                      child: TextFormField(
                                        controller: n,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            borderSide: const BorderSide(
                                                color: Colors.orange,
                                                width: 1.5),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            borderSide: const BorderSide(
                                              color: Colors.orange,
                                              width: 1.5,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: SingleChildScrollView(
                                  child: DataTable(
                                    columns: const [
                                      DataColumn(
                                        label: Text("Numéro de ligne"),
                                      ),
                                      DataColumn(
                                        label: Text("réf"),
                                      ),
                                      DataColumn(
                                        label: Text("Article"),
                                      ),
                                      DataColumn(
                                        label: Text("Description"),
                                      ),
                                      DataColumn(
                                        label: Text(" Unité"),
                                      ),
                                      DataColumn(
                                        label: Text("Quantité"),
                                      ),
                                      DataColumn(
                                        label: Text("Prix Unitaire"),
                                      ),
                                      DataColumn(
                                        label: Text("TVA"),
                                      ),
                                      DataColumn(
                                        label: Text("Sous-total"),
                                      )
                                    ],
                                    rows: [
                                      for (var i = 0;
                                          i < widget.tab.length;
                                          i++) ...[
                                        DataRow(cells: [
                                          DataCell(Text("$i")),
                                          DataCell(
                                              Text("${widget.tab[i]['réf']}")),
                                          DataCell(
                                              Text(widget.tab[i]['Article'])),
                                          DataCell(Text(
                                              widget.tab[i]['Description'])),
                                          DataCell(Text(
                                              "${widget.tab[i]['Unite']}")),
                                          DataCell(Text(
                                              "${widget.tab[i]['Quantite']}")),
                                          DataCell(
                                              Text("${widget.tab[i]['prix']}")),
                                          const DataCell(Text("20%")),
                                          DataCell(Text(
                                              "${widget.tab[i]["sous-total"]}")),
                                        ]),
                                      ]
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          color: Colors.white,
                          margin: const EdgeInsets.only(top: 20, bottom: 20),
                          child: Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(20),
                                child: Text(
                                  "État :",
                                  style:
                                      TextStyle(fontSize: 15, letterSpacing: 3),
                                ),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.only(left: 43, bottom: 15),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color: Colors.grey, width: 1.5)),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    dropdownColor: Colors.white,
                                    icon: const Padding(
                                      padding: EdgeInsets.only(left: 20),
                                      child: Icon(
                                        Icons.arrow_drop_down,
                                        color: Colors.orange,
                                      ),
                                    ),
                                    style: const TextStyle(
                                        fontSize: 20, color: Colors.black),
                                    iconSize: 40,
                                    value: widget.etat,
                                    onChanged: (newValue) {
                                      setState(() {
                                        widget.etat = newValue.toString();
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
                              ),
                            ],
                          ),
                        ),
                        Container(
                          color: Colors.white,
                          margin: const EdgeInsets.only(top: 20, bottom: 20),
                          child: Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(20),
                                child: Text(
                                  "Date de facturations :",
                                  style:
                                      TextStyle(fontSize: 15, letterSpacing: 3),
                                ),
                              ),
                              Container(child: buildDatePicker(dataTime)),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 20, bottom: 20),
                          color: Colors.white,
                          child: Row(
                            children: [
                              Container(
                                width: 350,
                                height: 200,
                                margin: const EdgeInsets.only(
                                    top: 10, left: 20, right: 10),
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    color: Color.fromARGB(255, 245, 245, 245)),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8, top: 15),
                                  child: Column(
                                    children: [
                                      Text(
                                        "Montant HT: ${calculMontat()}",
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                      Text(
                                        "Remise: ${widget.res / 100}",
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                      const Divider(
                                        color: Colors.black,
                                      ),
                                      Text(
                                        "Total: ${(calculMontat() * (1 + 0.2)) * (1 - (widget.res / 100))}",
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
                  ],
                ),
              )),
              SizedBox(
                width: 370,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    maximumSize: const Size(double.infinity, 50),
                    primary: Colors.indigo,
                  ),
                  child: const Text(
                    "Modifier",
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    if (widget.page == "nouvellefacture") {
                      Facture().updateFacture(
                          widget.id,
                          widget.client,
                          widget.etat,
                          dataTime,
                          (calculMontat() * (1 + 0.2)) *
                              (1 - (widget.res / 100)),
                          widget.tab,
                          widget.res,
                          calculMontat());
                      Get.to(() => ListFacture(
                          idus: widget.idus,
                          url: widget.url,
                          telus: widget.telus,
                          adrus: widget.adrus,
                          accesus: widget.accesus,
                          nameus: widget.nameus,
                          emailus: widget.emailus,
                          roleus: widget.roleus));
                    } else {
                      AutoFacture().updateFacture(
                          widget.id,
                          widget.client,
                          widget.etat,
                          dataTime,
                          (calculMontat() * (1 + 0.2)) *
                              (1 - (widget.res / 100)),
                          widget.tab,
                          widget.res,
                          calculMontat());
                      Get.to(() => ListFactureDev(
                          idus: widget.idus,
                          url: widget.url,
                          telus: widget.telus,
                          adrus: widget.adrus,
                          accesus: widget.accesus,
                          nameus: widget.nameus,
                          emailus: widget.emailus,
                          roleus: widget.roleus));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDatePicker(date) => SizedBox(
        height: 150,
        child: CupertinoDatePicker(
          initialDateTime: date,
          mode: CupertinoDatePickerMode.date,
          onDateTimeChanged: (dateTime) => setState(() {
            date = dateTime;
          }),
        ),
      );
}
