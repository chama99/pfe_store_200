import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../pages/utils.dart';

class PlanScreen extends StatefulWidget {
  final String? role;
  final String planID;
  final dynamic event;
  const PlanScreen(
      {Key? key, required this.event, required this.planID, this.role})
      : super(key: key);

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  ///---------State-------------
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  String _picturePath = "";
  List<String> _pictureUploaded = [];
  dynamic _eventFromParent;
  List<bool> _buttons = [false, false, false];
  String _planStatus = "Planifier";
  final ImagePicker _picker = ImagePicker();
  final String _networkImage =
      "https://i0.wp.com/shahpourpouyan.com/wp-content/uploads/2018/10/orionthemes-placeholder-image-1.png";
  final _noteController = TextEditingController();
  List<XFile?>? _noteImage;
  final TextStyle _leftTextStyle =
      const TextStyle(fontWeight: FontWeight.bold, fontSize: 18);
  final TextStyle _rightTextStyle =
      const TextStyle(fontWeight: FontWeight.w500, fontSize: 18);

  Widget _saveButtonContent = const Text("Sauvgader",
      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18));

  Map<String, String> _paths = {};
  String _extension = "";
  late FileType _pickType;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  List<UploadTask> _tasks = <UploadTask>[];

  ///--------Methods--------------
  Future _uploadImages(String email) async {
    const destination = 'PlanNote';
    for (var f in _noteImage!) {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child('$email/');
      final UploadTask uploadTask = ref.putFile(File(f!.path));
    }
  }

  void selectImages() async {
    List<XFile>? imageFileList = [];
    final List<XFile>? selectedImages = await ImagePicker().pickMultiImage();
    if (selectedImages!.isNotEmpty) {
      imageFileList.addAll(selectedImages);
    }
    setState(() {});
  }

  void openFileExplorer() async {
    var i = 0;
    try {
      var x = await FilePicker.platform.pickFiles();
      for (var picture in x!.files) {
        _paths.addAll({'$i': picture.path!});
      }
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
    if (!mounted) return;
  }

  _renderButton() {
    if (_planStatus == "Demarrer") {
      _planStatus = "Demarrer";
      _buttons = [true, false, true];
    }
    if (_planStatus == "Terminer") {
      _planStatus = "Terminer";
      _buttons = [true, true, true];
    }
    if (_planStatus == "Annuler") {
      _planStatus = "Annuler";
      _buttons = [true, true, true];
    }
    setState(() {});
  }

  updatePlanStatus(String status, BuildContext context) async {
    final refPlans = FirebaseFirestore.instance.collection("plan");
    refPlans.doc(widget.planID).update({"state": status}).then((v) {
      print("i had began");
      _planStatus = status;
      _renderButton();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Row(children: const [
          Icon(
            Icons.check,
            color: Colors.greenAccent,
          ),
          Spacer(),
          Text('Plan a été mis a jour avec success ')
        ]),
      ));
    });
  }

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
      _uploadImages(widget.planID);
    }

    final refPlans = FirebaseFirestore.instance.collection("plan");
    await refPlans.doc(widget.planID).update({
      "state": _planStatus,
      "note": _noteController.text,
      "picture": _picturePath == "" ? "" : _picturePath
    }).then((_) async {
      var _newEvent = await refPlans.doc(widget.planID).get();
      setState(() {
        _eventFromParent = _newEvent;
        _saveButtonContent = Text("Sauvgader", style: _rightTextStyle);
      });
      _scaffoldkey.currentState!.showSnackBar(SnackBar(
        content: Row(children: const [
          Icon(
            Icons.check,
            color: Colors.greenAccent,
          ),
          Spacer(),
          Text('Plan a été mis a jour avec success ')
        ]),
      ));
    }).onError((error, stackTrace) {
      setState(() {
        _saveButtonContent = Text("Sauvgader", style: _rightTextStyle);
      });
      ScaffoldMessenger.of(cx).showSnackBar(SnackBar(
        content: Row(children: [
          const Icon(
            Icons.check,
            color: Colors.greenAccent,
          ),
          const SizedBox(width: 8),
          Text('Probléme : ${error}')
        ]),
      ));
    });
  }

  ///---------InitState()-------
  @override
  void initState() {
    if (widget.role == "Technicien") {
      _buttons = [false, false, true];
    }
    _eventFromParent = widget.event;
    _planStatus = _eventFromParent['state'];
    _renderButton();
    _noteController.text = _eventFromParent['note'] ?? "";
    super.initState();
  }

  ///---------UI---------------
  @override
  Widget build(BuildContext context) {
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
                        updatePlanStatus("Demarrer", context);
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
                        if (_noteController.text.isEmpty) {
                          modalShow("Veuillez remplir les note", context,
                              success: false);
                          return;
                        }
                        updatePlanStatus("Terminer", context);
                        //_planStatus = "Terminer";
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
                        updatePlanStatus("Annuler", context);
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
                  Text(Utils.toReadableDate(_eventFromParent['startTime']),
                      style: _rightTextStyle)
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Date de fin :", style: _leftTextStyle),
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
                  Text("Heure :", style: _leftTextStyle),
                  Text(_eventFromParent['time'] ?? "--:--  --:--",
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
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 200,
                              childAspectRatio: 3 / 2,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20),
                      itemCount: _noteImage!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                            child: Container(
                          child: Image.asset(_noteImage![index]!.path),
                        ));
                      })
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
                selectImages();
              },
              icon: const Icon(Icons.camera),
              label: const Text("Appareil photo"),
            ),
            FlatButton.icon(
              onPressed: () {
                selectImages();
              },
              icon: const Icon(Icons.camera),
              label: const Text("Galerie"),
            ),
          ],
        )
      ]),
    );
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

  Widget buildImageCard(int index, XFile image) => Card(
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: GestureDetector(
          onTap: () {},
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(image.path),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        //padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(100)),
                        child: const Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
        ),
      );
}
