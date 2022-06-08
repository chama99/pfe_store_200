import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

import '../pages/utils.dart';
import '../widget/NavBottom.dart';
import '../widget/modal.dart';
import 'calander.dart';

class PlanScreen extends StatefulWidget {
  final VoidCallback callBack;
  final String? role;
  final String planID;
  final dynamic event;
  final String emailus, nameus, url, roleus, adrus, telus, idus;

  final String techName;
  final String username;
  final List accesus;
  const PlanScreen(
      {Key? key,
      required this.callBack,
      required this.event,
      required this.planID,
      required this.idus,
      required this.url,
      required this.emailus,
      required this.nameus,
      required this.roleus,
      required this.accesus,
      required this.telus,
      required this.adrus,
      required this.techName,
      required this.username,
      this.role})
      : super(key: key);

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  ///---------State-------------
  List<String> _pictureUploaded =
      []; // This is for the capture of the pictures had been uploaded
  dynamic _eventFromParent; // thisq is from the parent widget
  List<bool> _buttons = [false, false, false]; // this for the buttons
  String _planStatus = "Planifier"; // this is the initial status
  final _noteController = TextEditingController();
  List<XFile?>? _noteImage = []; // this is for the images picked
  final TextStyle _leftTextStyle =
      const TextStyle(fontWeight: FontWeight.bold, fontSize: 18);
  final TextStyle _rightTextStyle =
      const TextStyle(fontWeight: FontWeight.w500, fontSize: 18);
  Widget _saveButtonContent = const Text("Sauvgarder",
      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18));
  Map<String, String> _paths = {};
  int indexOfImage = 0;
  bool _isLoading = false;

  ///---------InitState()-------
  @override
  void initState() {
    if (widget.role!.toLowerCase() != "admin") {
      _buttons = [false, true, true];
    } else {
      _buttons = [false, true, false];
    }
    _eventFromParent = widget.event;
    _planStatus = _eventFromParent['state'];
    _renderButton();
    _noteController.text = _eventFromParent['note'] ?? "";
    print('This is the event from parent !!!! ${widget.event}');
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
                      Get.to(() => Calander(
                            techName: widget.techName,
                            username: widget.username,
                            idus: widget.idus,
                            url: widget.url,
                            emailus: widget.emailus,
                            nameus: widget.nameus,
                            roleus: widget.roleus,
                            accesus: widget.accesus,
                            telus: widget.telus,
                            adrus: widget.adrus,
                            role: widget.roleus,
                          ));
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
                      _planStatus = "Terminer";
                      Get.to(() => Calander(
                            techName: widget.techName,
                            username: widget.username,
                            idus: widget.idus,
                            url: widget.url,
                            emailus: widget.emailus,
                            nameus: widget.nameus,
                            roleus: widget.roleus,
                            accesus: widget.accesus,
                            telus: widget.telus,
                            adrus: widget.adrus,
                            role: widget.roleus,
                          ));

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
                      Get.to(() => Calander(
                            techName: widget.techName,
                            username: widget.username,
                            idus: widget.idus,
                            url: widget.url,
                            emailus: widget.emailus,
                            nameus: widget.nameus,
                            roleus: widget.roleus,
                            accesus: widget.accesus,
                            telus: widget.telus,
                            adrus: widget.adrus,
                            role: widget.roleus,
                          ));
                      setState(() {});
                    },
                    style: ElevatedButton.styleFrom(
                        primary: _buttons[2] ? Colors.grey : Colors.red),
                    child: const Text("Annuler")),
              ],
            ),
            const SizedBox(
              height: 10,
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
              height: 10,
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
                        Icons.image_rounded,
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
              height: 10,
            ),
            _noteImage!.isNotEmpty && _eventFromParent["picture"] != null
                ? listImageContainer(_noteImage!, isItFromParent: false)
                : listImageContainer(_eventFromParent["picture"],
                    isItFromParent: true),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
              child: ElevatedButton(
                  onPressed: () => _savgardePlan(context),
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

  ///--------Methods--------------
  Future _uploadImages() async {
    await FirebaseAuth.instance.signInAnonymously();

    await Future.forEach(_noteImage!, (XFile? image) async {
      Reference ref = FirebaseStorage.instance
          .ref("plans_picture")
          .child('${widget.planID}${indexOfImage.toString()}');
      UploadTask uploadTask = ref.putFile(File(image!.path));

      var _url = await (await uploadTask).ref.getDownloadURL();
      _pictureUploaded.add(_url);

      print("this is the images uploaded ===$_pictureUploaded");

      indexOfImage++;
    }).whenComplete(() => indexOfImage = 0);
  }

  void selectImages() async {
    final List<XFile>? selectedImages = await ImagePicker().pickMultiImage();
    if (selectedImages!.isNotEmpty) {
      _noteImage!.addAll(selectedImages);
    }
    setState(() {});
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
    bool clicked = GetStorage().read(widget.planID) ?? false;
    if (status != "Terminer") {
      final refPlans = FirebaseFirestore.instance.collection("plan");
      refPlans.doc(widget.planID).update({"state": status}).then((v) {
        _planStatus = status;
        _renderButton();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Row(children: [
            const Icon(
              Icons.check,
              color: Colors.greenAccent,
            ),
            const Spacer(),
            Text('Plan a été $status avec success ')
          ]),
        ));
      });
    } else if (status == "Terminer" && clicked) {
      final refPlans = FirebaseFirestore.instance.collection("plan");
      refPlans.doc(widget.planID).update({"state": status}).then((v) {
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
            Text('Plan a été Terminer avec success')
          ]),
        ));
      });
    } else if (status == "Terminer" && clicked == false) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Row(children: const [
          Icon(
            Icons.warning,
            color: Colors.orangeAccent,
          ),
          Spacer(),
          Text(
              'Veuillez remplir le note et sauvgarder pour \nterminer le plan!')
        ]),
      ));
    }
    Get.to(() => Calander(
          techName: widget.techName,
          username: widget.username,
          idus: widget.idus,
          url: widget.url,
          emailus: widget.emailus,
          nameus: widget.nameus,
          roleus: widget.roleus,
          accesus: widget.accesus,
          telus: widget.telus,
          adrus: widget.adrus,
          role: widget.roleus,
        ));
  }

  void _savgardePlan(BuildContext cx) async {
    if (_isLoading) {
      return;
    }
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
    _isLoading = true;
    if (_noteImage != null) {
      _uploadImages().whenComplete(() async {
        print(
            "this is the picture uploaded that will be added to the don ================ $_pictureUploaded");
        final refPlans = FirebaseFirestore.instance.collection("plan");
        refPlans.doc(widget.planID).update({
          "state": _planStatus,
          "note": _noteController.text,
          "picture": _pictureUploaded,
          "updated": true
        }).whenComplete(() async {
          var _newEvent = await refPlans.doc(widget.planID).get();

          setState(() {
            _eventFromParent = _newEvent;
            _saveButtonContent = Text("Sauvgarder", style: _rightTextStyle);
          });
          ScaffoldMessenger.of(cx).showSnackBar(SnackBar(
            content: Row(children: const [
              Icon(
                Icons.check,
                color: Colors.greenAccent,
              ),
              Spacer(),
              Text('Plan a été mis a jour avec success ')
            ]),
          ));
          GetStorage().write(widget.planID, true);
          Get.to(() => Calander(
                techName: widget.techName,
                username: widget.username,
                idus: widget.idus,
                url: widget.url,
                emailus: widget.emailus,
                nameus: widget.nameus,
                roleus: widget.roleus,
                accesus: widget.accesus,
                telus: widget.telus,
                adrus: widget.adrus,
                role: widget.roleus,
              ));
          widget.callBack();
        }).onError((error, stackTrace) {
          setState(() {
            _saveButtonContent = Text("Sauvgarder", style: _rightTextStyle);
          });
          print(error);
          print(stackTrace);
          ScaffoldMessenger.of(cx).showSnackBar(SnackBar(
            content: Row(children: [
              const Icon(
                Icons.check,
                color: Colors.greenAccent,
              ),
              const SizedBox(width: 8),
              Text('Probléme : $error')
            ]),
          ));
        });
      }).onError((error, stackTrace) {
        throw ScaffoldMessenger.of(cx).showSnackBar(SnackBar(
          content: Row(children: const [
            Icon(
              Icons.check,
              color: Colors.greenAccent,
            ),
            SizedBox(width: 8),
            Text("un probléme s'est produit lors du chargement des photo ")
          ]),
        ));
      });
    }
  }

  Widget listImageContainer(List<dynamic>? images, {bool? isItFromParent}) {
    return Expanded(
        child: GridView.builder(
            scrollDirection: Axis.vertical,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20),
            itemCount: images?.length ?? 0,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: Stack(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      child: Center(
                          child: isItFromParent!
                              ? Image.network(
                                  _eventFromParent["picture"][index])
                              : Image.file(File(images![index].path))),
                    ),
                    Positioned(
                        bottom: 10,
                        right: 10,
                        child: GestureDetector(
                            onTap: () async => showDialog(
                                  context: context,
                                  builder: (context) => ModalImage(
                                      link: isItFromParent
                                          ? images![index]
                                          : _eventFromParent["picture"][index]),
                                ),
                            child: const Icon(Icons.zoom_in))),
                  ],
                ),
              );
            }));
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
