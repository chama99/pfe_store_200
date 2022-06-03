// ignore_for_file: file_names, must_be_immutable, unused_local_variable

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widget/NavBottom.dart';
import 'modifierprof.dart';

class Profile extends StatefulWidget {
  String email, nom, mdp, image, role, id, adress, telef;
  List acces;

  Profile({
    Key? key,
    required this.id,
    required this.image,
    required this.email,
    required this.nom,
    required this.mdp,
    required this.role,
    required this.acces,
    required this.adress,
    required this.telef,
  }) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Widget textfield({@required hintText}) {
    return Material(
      elevation: 4,
      shadowColor: Colors.indigo,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              letterSpacing: 2,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            fillColor: Colors.white30,
            filled: true,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.orange,
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 20, right: 30),
            child: InkWell(
              onTap: () {
                Get.to(() => UpdateProfil(
                    id: widget.id,
                    email: widget.email,
                    nom: widget.nom,
                    acces: widget.acces,
                    tel: widget.telef,
                    adr: widget.adress,
                    image: widget.image,
                    role: widget.role));
              },
              child: Text(
                "Modifier".toUpperCase(),
                style: const TextStyle(
                    fontSize: 15, color: Colors.white, letterSpacing: 3),
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavBottom(
          tel: widget.telef,
          adr: widget.adress,
          id: widget.id,
          email: widget.email,
          name: widget.nom,
          acces: widget.acces,
          url: widget.image,
          role: widget.role),
      body: Stack(alignment: Alignment.center, children: [
        ListView(
          children: [
            Column(
              children: [
                Stack(
                  //alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                      ),
                      painter: HeaderCurvedContainer(),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(120, 20, 120, 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                width: MediaQuery.of(context).size.width / 2,
                                height: MediaQuery.of(context).size.width / 2,
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.white, width: 5),
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(widget.image),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 700,
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(height: 150),
                              textfield(
                                hintText: widget.nom,
                              ),
                              textfield(
                                hintText: widget.role,
                              ),
                              textfield(
                                hintText: widget.email,
                              ),
                              textfield(
                                hintText: widget.adress,
                              ),
                              textfield(hintText: widget.telef),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ]),
    );
  }
}

class HeaderCurvedContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.orange;
    Path path = Path()
      ..relativeLineTo(0, 100)
      ..quadraticBezierTo(size.width / 2, 150, size.width, 100)
      ..relativeLineTo(0, -100)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
