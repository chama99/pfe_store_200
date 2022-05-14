import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../utils.dart';

class PlanScreen extends StatefulWidget {
  final String planID;
  final dynamic event;
  const PlanScreen({Key? key, required this.event, required this.planID})
      : super(key: key);

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  ///---------State-------------
  String _picturePath = "";
  dynamic _eventFromParent;
  List<bool> _buttons = [false, false, false];
  String _planStatus = "Planifier";
  final ImagePicker _picker = ImagePicker();
  final String _networkImage =
      "https://i0.wp.com/shahpourpouyan.com/wp-content/uploads/2018/10/orionthemes-placeholder-image-1.png";
  final _noteController = TextEditingController();
  XFile? _noteImage;
  final TextStyle _leftTextStyle =
      const TextStyle(fontWeight: FontWeight.bold, fontSize: 18);
  final TextStyle _rightTextStyle =
      const TextStyle(fontWeight: FontWeight.w500, fontSize: 18);

  Widget _saveButtonContent = const Text("Sauvgader",
      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18));

  ///--------Methods--------------
  _renderButton() {
    if (widget.event['state'] == "Demarrer") {
      _planStatus = "Demarrer";
      _buttons = [true, false, true];
    }
    if (widget.event['state'] == "Terminer") {
      _planStatus = "Terminer";
      _buttons = [true, true, true];
    }
    if (widget.event['state'] == "Annuler") {
      _planStatus = "Annuler";
      _buttons = [true, true, true];
    }
    setState(() {});
  }

  // String _getPlanStatus() {
  //   if (_buttons[0]) {
  //     return "Demarrer";
  //   } else if (_buttons[1]) {
  //     return "Terminer";
  //   } else if (_buttons[2]) {
  //     return "Annuler";
  //   }
  //   return "Planifier";
  // }

  void _updatePlan(BuildContext cx) async {
    if (_noteController.text == "") {
      modalShow("Veuillez remplir la note.", cx, success: false);
      return;
    }
    setState(() {
      _saveButtonContent = const SizedBox(
          width: 40,
          child: CupertinoActivityIndicator(
            color: Colors.white,
          ));
    });
    if (_noteImage != null) {
      uploadImage(widget.planID);
    }

    final refPlans = FirebaseFirestore.instance.collection("plan");
    var x = await refPlans.doc(widget.planID).update({
      "state": _planStatus,
      "note": _noteController.text,
      "picture": _picturePath == "" ? "" : _picturePath
    }).then((_) async {
      var _newEvent = await refPlans.doc(widget.planID).get();
      setState(() {
        _eventFromParent = _newEvent;
        _saveButtonContent = Text("Sauvgader", style: _rightTextStyle);
      });
    }).onError((error, stackTrace) {
      setState(() {
        _saveButtonContent = Text("Sauvgader", style: _rightTextStyle);
      });
    });
  }

  ///---------InitState()-------
  @override
  void initState() {
    _eventFromParent = widget.event;
    _renderButton();
    super.initState();
  }

  ///---------UI---------------
  @override
  Widget build(BuildContext context) {
    print("event => ${widget.planID}");
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          centerTitle: true,
          title: const Text("Plan"),
        ),
        body: SingleChildScrollView(
            child: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        if (_buttons[0]) {
                          return;
                        }
                        _planStatus = "Demarrer";
                        _buttons[0] = true;
                        _buttons[1] = false;
                        _buttons[2] = true;
                        setState(() {});
                      },
                      style: ElevatedButton.styleFrom(
                          primary: _buttons[0] ? Colors.grey : Colors.orange),
                      child: const Text("Démarrer")),
                  ElevatedButton(
                      onPressed: () {
                        if (_buttons[1]) {
                          return;
                        }
                        // if (!_buttons[1]) {
                        //   _buttons[0] = _buttons[0];
                        // }
                        _planStatus = "Terminer";
                        _buttons[0] = true;
                        _buttons[1] = true;
                        _buttons[2] = true;

                        setState(() {});
                      },
                      style: ElevatedButton.styleFrom(
                          primary: _buttons[1] ? Colors.grey : Colors.green),
                      child: const Text("Terminer")),
                  ElevatedButton(
                      onPressed: () {
                        if (_buttons[2]) {
                          return;
                        }
                        _planStatus = "Annuler";
                        _buttons[0] = true;
                        _buttons[1] = true;
                        _buttons[2] = true;
                        setState(() {});
                      },
                      style: ElevatedButton.styleFrom(
                          primary: _buttons[2] ? Colors.grey : Colors.red),
                      child: const Text("Annuler")),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Sujet de plan :", style: _leftTextStyle),
                  Text(_eventFromParent['subject'], style: _rightTextStyle)
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Etat de plan :", style: _leftTextStyle),
                  Text(_eventFromParent['state'].toString(),
                      style: _rightTextStyle)
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Client :", style: _leftTextStyle),
                  Text(_eventFromParent['client'], style: _rightTextStyle)
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Date de début :", style: _leftTextStyle),
                  Text(
                      Utils.toReadableDate(_eventFromParent['startTime'])
                          .toString(),
                      style: _rightTextStyle)
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Date de début :", style: _leftTextStyle),
                  Text(
                      Utils.toReadableDate(_eventFromParent['endTime'])
                          .toString(),
                      style: _rightTextStyle)
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Note :", style: _leftTextStyle),
                  Expanded(
                      child: TextField(
                    controller: _noteController,
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                      icon: Container(
                        height: 50,
                        width: 50,
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(40)),
                            color: Colors.grey[400]),
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            builder: ((builder) => bottomSheet()));
                      },
                    )),
                  ))
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              _noteImage == null
                  ? Image.network(
                      _networkImage,
                      height: 200,
                      width: 300,
                    )
                  : Image.file(
                      File(_noteImage!.path),
                      height: 200,
                      width: 300,
                    ),
            ],
          ),
        )),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
          child: ElevatedButton(
              onPressed: () => _updatePlan(context),
              style: ElevatedButton.styleFrom(
                  primary: Colors.orange,
                  fixedSize: Size(MediaQuery.of(context).size.width * .7, 45)),
              child: _saveButtonContent),
        ));
  }

  // void updatePlan() async {
  //   final CollectionReference _collectionRef =
  //       FirebaseFirestore.instance.collection('plan');
  //   var refInDb = _collectionRef.doc(widget.event['subject']);
  //   await refInDb.set({'state': ""});
  // }

  uploadImage(String email) async {
    // ignore: unused_local_variable
    final fileName = basename(_noteImage!.path);
    // ignore: prefer_const_declarations
    final destination = 'PlanNote';

    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child('$email/');
      UploadTask uploadTask = ref.putFile(File(_noteImage!.path));
      await uploadTask.whenComplete(() async {
        _picturePath = await uploadTask.snapshot.ref.getDownloadURL();

        //Employe().addEmploye(email, nom, tel, adresse, uploadPath);
      });
    } catch (e) {
      // ignore: avoid_print
      print('error occured');
    }
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
    XFile? pickedFile = await _picker.pickImage(source: source);
    setState(() {
      _noteImage = pickedFile!;
    });
  }

  modalShow(String text, BuildContext context, {bool success = true}) async {
    return await showDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
              title: success
                  ? Lottie.asset("asset/success.json",
                      height: MediaQuery.of(context).size.height * 0.08,
                      repeat: false)
                  : const Icon(Icons.close,
                      color: Colors.red), //const Text("Succès"),
              content: Column(
                children: [
                  Text(text),
                ],
              ),
              actions: <Widget>[
                CupertinoDialogAction(
                  onPressed: () => Navigator.of(context).pop(),
                  isDefaultAction: true,
                  child: const Text("D'accord"),
                ),
              ],
            ));
  }
}
