import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../api/firebase_api.dart';
import '../pages/utils.dart';
import '../widget/NavBottom.dart';
import 'conges_screen.dart';

class DemandeCongeScreen extends StatefulWidget {
  final VoidCallback callBack;
  final String userID;
  final String emailus, nameus, url, roleus, adrus, telus, idus;
  final String role;

  final List accesus;
  const DemandeCongeScreen({
    Key? key,
    required this.role,
    required this.userID,
    required this.callBack,
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
  State<DemandeCongeScreen> createState() => _DemandeCongeScreenState();
}

class _DemandeCongeScreenState extends State<DemandeCongeScreen> {
  Object? typeConge = "Paid";
  DateTime _endDate =
      Utils.formatDateToCalculate(DateTime.now().add(const Duration(days: 1)));
  DateTime _beginDate = Utils.formatDateToCalculate(DateTime.now());
  int leaveDaysDemanded = 0;
  int daysLeftForUser = 21;
  Widget _saveButtonContent = const Text("Demander",
      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18));
  TextEditingController _demandeController = TextEditingController();

  ///---------------------------Methods-------------------------------
  ///
  void getDurationOfHolidays() {
    leaveDaysDemanded = _endDate.difference(_beginDate).inDays +
        (_endDate.difference(_beginDate).inDays == 1 ? 0 : 1);
    setState(() {});
  }

  void getUserPaidDaysLeft(String userID) {
    FirebaseApi.getUser(userID).then((v) {
      daysLeftForUser = int.parse(v["paidLeaveDaysLeft"] ?? "0");
      setState(() {});
    });
  }

  @override
  void initState() {
    getUserPaidDaysLeft(widget.userID);
    getDurationOfHolidays();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        //centerTitle: true,
        title: const Text("Demande de Congé"),
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
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              children: [
                const Text(
                  "Description : ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Expanded(
                    child: TextFormField(
                  controller: _demandeController,
                  minLines:
                      3, // any number you need (It works as the rows for the textarea)
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                ))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Type de congé :",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    const Text("Payés"),
                    Radio(
                        value: "Paid",
                        groupValue: typeConge,
                        onChanged: (v) {
                          print(typeConge);
                          typeConge = v;
                          setState(() {});
                        }),
                  ],
                ),
                Row(
                  children: [
                    const Text("Non payés"),
                    Radio(
                        value: "NotPaid",
                        groupValue: typeConge,
                        onChanged: (v) {
                          print(typeConge);
                          typeConge = v;
                          setState(() {});
                        })
                  ],
                ),
              ],
            ),
            Row(children: [
              const Text(
                "Date de début : ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              ElevatedButton(
                // style: ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith(),
                style: ElevatedButton.styleFrom(primary: Colors.orange),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_month,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(Utils.formatDateToRender(_beginDate),
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white)),
                  ],
                ),
                onPressed: () {
                  _selectDate(context, _beginDate, true);
                },
              ),
            ]),
            Row(children: [
              const Text(
                "Date du fin: ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.orange),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_month,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(Utils.formatDateToRender(_endDate).toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white)),
                  ],
                ),
                onPressed: () {
                  _selectDate(context, _endDate, false);
                },
              ),
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Durée : ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text("${leaveDaysDemanded.toString()} Jours")
              ],
            ),

            //Align(alignment: Alignment.bottomCenter,child:
            Center(
              child: ElevatedButton(
                  onPressed: () {
                    _insertLeaveDemande(context);
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Colors.orange,
                      fixedSize:
                          Size(MediaQuery.of(context).size.width * .7, 45)),
                  child: _saveButtonContent),
            )
          ],
        ),
      ),
    );
  }

  Future _insertLeaveDemande(ctx) async {
    DateTime now = Utils.formatDateToCalculate(DateTime.now());
    print(
        "end date = $_endDate ------- beginDate ==== $_beginDate ====== $now");
    bool isValidDate = _beginDate.isBefore(now) || _endDate.isBefore(now);

    if (isValidDate) {
      Utils.modalShow("Un congé ne peut pas etre au passé", context,
          success: false);
      return null;
    }
    if (daysLeftForUser < leaveDaysDemanded) {
      Utils.modalShow(
          "Vous ne pouvez pas demander un conge qui dépasse le nombre de jours autoriser",
          context,
          success: false);
      return;
    }
    if (_demandeController.text.isEmpty) {
      Utils.modalShow("Veuillez remplir la description", context,
          success: false);
      return null;
    }
    _saveButtonContent = const SizedBox(
        width: 40,
        child: CupertinoActivityIndicator(
          color: Colors.white,
        ));
    setState(() {});
    FirebaseApi.createLeaveDemande(
            widget.userID,
            leaveDaysDemanded.toString(),
            Timestamp.fromDate(_beginDate),
            typeConge.toString().toLowerCase(),
            _demandeController.text)
        .then((v) {
      widget.callBack();
      Utils.snack(ctx, Icons.check, "Demande a été sauvgarder avec success");
      Get.to(() => CongesScreen(
            idus: widget.idus,
            url: widget.url,
            emailus: widget.emailus,
            nameus: widget.nameus,
            roleus: widget.roleus,
            accesus: widget.accesus,
            telus: widget.telus,
            adrus: widget.adrus,
            role: widget.role,
            userID: widget.userID,
          ));
    }).onError((error, stackTrace) {
      print(error);
      print(stackTrace);
      Utils.snack(ctx, Icons.close,
          "Un problème s'est produit pendant l'enregistrement de la demande. ");
    });
    setState(() {
      _saveButtonContent = const Text("Demander",
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18));
    });
  }

  Future<void> _selectDate(
      BuildContext context, DateTime _date, bool isItBeginDate) async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(2022, 1),
        lastDate: DateTime(2023));
    if (isItBeginDate && picked != null) {
      _beginDate = Utils.formatDateToCalculate(picked);
    } else if (!isItBeginDate && picked != null) {
      _endDate = Utils.formatDateToCalculate(picked);
    }
    print("end date = $_endDate ------- beginDate ==== $_beginDate");
    getDurationOfHolidays();
  }
}
