import 'package:chama_projet/services/commandeachat.dart';
import 'package:chama_projet/services/contact.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreerAchat extends StatefulWidget {
  const CreerAchat({Key? key}) : super(key: key);

  @override
  State<CreerAchat> createState() => _CreerAchatState();
}

class _CreerAchatState extends State<CreerAchat> {
  final _formKey = GlobalKey<FormState>();
  DateTime dataTime = DateTime.now();
  List listItem = ["Demande de prix", "Commande fournisseur"];
  var fournisseur;
  var etat;
  List commandeList = [];
  List userContactList = [];
  @override
  void initState() {
    super.initState();
    fetchDatabaseList();
  }

  fetchDatabaseList() async {
    dynamic resultant = await CommandeAchat().getCommandesList();
    dynamic resc = await Contact().getContactListByFour();
    if (resultant == null) {
      // ignore: avoid_print
      print('Unable to retrieve');
    } else {
      setState(() {
        commandeList = resultant;
        userContactList = resc;
      });
    }
  }

  calculMontat() {
    var montant = 0.00;
    for (var i = 0; i < commandeList.length; i++) {
      montant = montant + commandeList[i]["sous-total"];
    }
    return montant;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Demande d'achat"),
        backgroundColor: Colors.orange,
      ),
      body: RefreshIndicator(
        onRefresh: () {
          Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                  // ignore: prefer_const_constructors
                  pageBuilder: (a, b, c) => CreerAchat(),
                  // ignore: prefer_const_constructors
                  transitionDuration: Duration(seconds: 0)));
          // ignore: void_checks
          return Future.value(false);
        },
        child: Column(
          children: [
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
                          padding: const EdgeInsets.all(13),
                          child: InkWell(
                            onTap: () {},
                            child: const Text(
                              "Ajouter Lignes de la commande",
                              style: TextStyle(
                                  fontSize: 15,
                                  letterSpacing: 3,
                                  color: Colors.indigo),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SingleChildScrollView(
                            child: DataTable(
                              columns: const [
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
                                  label: Text("Unité"),
                                ),
                                DataColumn(
                                  label: Text("Quantité"),
                                ),
                                DataColumn(
                                  label: Text("Prix unitaire"),
                                ),
                                DataColumn(
                                  label: Text("Taxes"),
                                ),
                                DataColumn(
                                  label: Text("Sous-total"),
                                )
                              ],
                              rows: [
                                for (var i = 0;
                                    i < commandeList.length;
                                    i++) ...[
                                  DataRow(cells: [
                                    DataCell(Text("${commandeList[i]['réf']}")),
                                    DataCell(Text(commandeList[i]['Article'])),
                                    DataCell(
                                        Text(commandeList[i]['Description'])),
                                    DataCell(
                                        Text("${commandeList[i]['Unite']}")),
                                    DataCell(
                                        Text("${commandeList[i]['Quantite']}")),
                                    DataCell(
                                        Text("${commandeList[i]['prix']}")),
                                    const DataCell(Text("${0.2}")),
                                    DataCell(Text(
                                        "${commandeList[i]["sous-total"]}")),
                                  ]),
                                ]
                              ],
                            ),
                          ),
                        ),
                        Row(
                          children: const [
                            Padding(
                              padding: EdgeInsets.all(13),
                              child: Text(
                                "Fournisseur :",
                                style:
                                    TextStyle(fontSize: 15, letterSpacing: 3),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 38),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border:
                                  Border.all(color: Colors.grey, width: 1.5)),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              dropdownColor: Colors.white,
                              icon: const Padding(
                                padding: EdgeInsets.only(left: 115),
                                child: Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.orange,
                                ),
                              ),
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.black),
                              iconSize: 40,
                              value: fournisseur,
                              onChanged: (newValue) {
                                setState(() {
                                  fournisseur = newValue.toString();
                                });
                              },
                              items: userContactList.map((valueItem) {
                                return DropdownMenuItem(
                                  value: valueItem,
                                  child: Text(valueItem),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(20),
                              child: Text(
                                "État",
                                style:
                                    TextStyle(fontSize: 15, letterSpacing: 3),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 43),
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
                                  value: etat,
                                  onChanged: (newValue) {
                                    setState(() {
                                      etat = newValue.toString();
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
                        Row(
                          children: const [
                            Padding(
                              padding: EdgeInsets.all(20),
                              child: Text(
                                "Date de la commande",
                                style:
                                    TextStyle(fontSize: 15, letterSpacing: 3),
                              ),
                            ),
                          ],
                        ),
                        Container(child: buildDatePicker(dataTime)),
                        Row(
                          children: [
                            Container(
                              width: 350,
                              height: 200,
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
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        "Taxes: 0.2",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                    const Divider(
                                      color: Colors.black,
                                    ),
                                    Text(
                                      "Total:  ${(calculMontat() * (1 + 0.2))}",
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )),
                  ],
                ),
              ),
            )),
          ],
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
