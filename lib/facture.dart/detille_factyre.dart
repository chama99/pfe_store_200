// ignore_for_file: must_be_immutable

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

import '../services/pdf_api.dart';

class DetailFacture extends StatefulWidget {
  String titre, client, etat, date1, date2, adrss;
  final double order;
  List listfact;

  double total;
  DetailFacture(
      {Key? key,
      required this.titre,
      required this.client,
      required this.etat,
      required this.date1,
      required this.date2,
      required this.adrss,
      required this.total,
      required this.order,
      required this.listfact})
      : super(key: key);

  @override
  State<DetailFacture> createState() => _DetailFactureState();
}

class _DetailFactureState extends State<DetailFacture> {
  final keySignaturePad = GlobalKey<SfSignaturePadState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.titre),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          Text("Etat :${widget.etat}"),
          Text("Client :${widget.client}"),
          Text("Date de Facturation :${widget.date1}"),
          Text("Adresse d'intervention :${widget.adrss}"),
          Text("Date d'intervention :${widget.date2}"),
          Text("Total :${widget.total}"),
          SfSignaturePad(
            key: keySignaturePad,
            backgroundColor: Colors.yellow[100],
          )
        ],
      ),
      bottomNavigationBar: ElevatedButton(
        style: ElevatedButton.styleFrom(
          maximumSize: Size(double.infinity, 50),
        ),
        child: Text("sauvgarder"),
        onPressed: onSubmit,
      ),
    );
  }

  Future onSubmit() async {
    showDialog(
        context: context,
        builder: (context) => Center(
              child: CircularProgressIndicator(),
            ));
    final image = await keySignaturePad.currentState?.toImage();
    final imageSignature = await image!.toByteData(format: ImageByteFormat.png);
    final file = await PdfApi.generatePDF(
        order: widget.order,
        imageSignature: imageSignature!,
        commnd: widget.listfact);
    Navigator.of(context).pop();
    await OpenFile.open(file.path);
  }
}
