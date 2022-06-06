// ignore_for_file: file_names, must_be_immutable, non_constant_identifier_names, prefer_const_constructors

import 'package:flutter/material.dart';

import '../widget/NavBottom.dart';
import 'edit_article.dart';

class ArticleDetail extends StatefulWidget {
  String id, nom, type, role, cat, data, unite;
  int reference_interne;
  double prix_dachat, prix_de_vente;
  String image;
  int qt, taxes_a_la_vente;
  String emailus, nameus, url, roleus, adrus, telus, idus;

  List accesus;
  ArticleDetail({
    Key? key,
    required this.id,
    required this.nom,
    required this.type,
    required this.role,
    required this.cat,
    required this.data,
    required this.reference_interne,
    required this.taxes_a_la_vente,
    required this.prix_dachat,
    required this.prix_de_vente,
    required this.unite,
    required this.image,
    required this.qt,
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
  State<ArticleDetail> createState() => _ArticleDetailState();
}

class _ArticleDetailState extends State<ArticleDetail> {
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
              color: Color.fromARGB(255, 30, 41, 106),
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
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.orange,
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 20, right: 30),
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditArticle(
                            id: widget.id,
                            nom: widget.nom,
                            type: widget.type,
                            role: widget.role,
                            cat: widget.cat,
                            data: widget.data,
                            reference_interne: widget.reference_interne,
                            taxes_a_la_vente: widget.taxes_a_la_vente,
                            prix_dachat: widget.prix_dachat,
                            prix_de_vente: widget.prix_de_vente,
                            unite: widget.unite,
                            image: widget.image,
                            qt: widget.qt,
                            idus: widget.idus,
                            url: widget.url,
                            telus: widget.telus,
                            adrus: widget.adrus,
                            accesus: widget.accesus,
                            nameus: widget.nameus,
                            emailus: widget.emailus,
                            roleus: widget.roleus)));
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
          tel: widget.telus,
          adr: widget.adrus,
          id: widget.idus,
          email: widget.emailus,
          name: widget.nameus,
          acces: widget.accesus,
          url: widget.url,
          role: widget.roleus),
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
                          padding: const EdgeInsets.fromLTRB(150, 20, 150, 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10.0),
                                width: MediaQuery.of(context).size.width / 4,
                                height: MediaQuery.of(context).size.width / 4,
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
                          height: 850,
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(height: 70),
                              textfield(
                                hintText: "Nom d'artcile: ${widget.nom}",
                              ),
                              textfield(
                                hintText: "Type d'article: ${widget.role}",
                              ),
                              textfield(
                                hintText: "Catégorie d'article: ${widget.cat}",
                              ),
                              textfield(
                                hintText: "Code à barres: ${widget.data}",
                              ),
                              textfield(
                                hintText:
                                    "Référence interne: ${widget.reference_interne}",
                              ),
                              textfield(
                                hintText: "Prix d'acht: ${widget.prix_dachat}",
                              ),
                              textfield(
                                hintText: "Unité de mesure: ${widget.unite}",
                              ),
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

//..quadraticBezierTo(size.width / 2, 225, size.width, 150)
class HeaderCurvedContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.orange;
    Path path = Path()
      ..relativeLineTo(0, 40)
      ..quadraticBezierTo(size.width / 2, 80, size.width, 40)
      ..relativeLineTo(0, -40)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
