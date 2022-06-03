// ignore_for_file: prefer_const_constructors, duplicate_ignore

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class PdfApi {
  static Future<File> generatePDF({
    required String titre,
    required ByteData imageSignature,
    required String name,
    required String email,
    required List commnd,
    required String client,
    required String date1,
    required double montant,
    required int remise,
    required double total,
  }) async {
    final document = PdfDocument();
    final page = document.pages.add();

    drawSignature(page, imageSignature);
    drawGrid(page, commnd);
    drawTitre(page, titre, client, date1, total, montant, remise, name, email);

    return saveFile(document);
  }

  static void drawTitre(PdfPage page, String titre, String client, String date1,
      double total, double montant, int remise, String name, String email) {
    final pageSize = page.getClientSize();
    page.graphics.drawString(
        "Nom  : $name", PdfStandardFont(PdfFontFamily.helvetica, 20),
        // ignore: prefer_const_constructors
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(300, 0, 200, 0));
    page.graphics.drawString(
        "Email : $email", PdfStandardFont(PdfFontFamily.helvetica, 20),
        // ignore: prefer_const_constructors
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(300, 50, 200, 0));
    page.graphics
        .drawString(titre, PdfStandardFont(PdfFontFamily.helvetica, 30),
            // ignore: prefer_const_constructors
            brush: PdfBrushes.black,
            bounds: Rect.fromLTWH(0, 110, 200, 0));

    page.graphics.drawString(
        "Client : $client", PdfStandardFont(PdfFontFamily.helvetica, 20),
        // ignore: prefer_const_constructors
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(0, 150, 200, 0));
    page.graphics.drawString("Date de facturation : $date1",
        PdfStandardFont(PdfFontFamily.helvetica, 20),
        // ignore: prefer_const_constructors
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(0, 170, 0, 0));
    page.graphics.drawString(
        "Signature", PdfStandardFont(PdfFontFamily.helvetica, 30),
        brush: PdfBrushes.black,
        bounds:
            Rect.fromLTWH(pageSize.width - 150, pageSize.height - 250, 0, 0));
    final grid = PdfGrid();
    grid.columns.add(count: 3);
    final headerRow = grid.headers.add(1)[0];
    headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor(68, 114, 196));
    headerRow.style.textBrush = PdfBrushes.white;
    headerRow.cells[0].value = 'Montant';
    headerRow.cells[1].value = 'Remise';
    headerRow.cells[2].value = 'Total';

    headerRow.style.font =
        PdfStandardFont(PdfFontFamily.helvetica, 15, style: PdfFontStyle.bold);
    // ignore: prefer_const_constructors
    grid.draw(page: page, bounds: Rect.fromLTWH(0, 400, 220, 0))!;

    final row = grid.rows.add();
    row.cells[0].value = "$montant £";
    row.cells[1].value = "$remise %";
    row.cells[2].value = "$total £";
    row.style.font =
        PdfStandardFont(PdfFontFamily.helvetica, 15, style: PdfFontStyle.bold);
    // ignore: prefer_const_constructors
    grid.draw(page: page, bounds: Rect.fromLTWH(0, 400, 250, 0))!;
  }

  static void drawGrid(PdfPage page, List cmmd) {
    final grid = PdfGrid();
    grid.columns.add(count: 7);
    final headerRow = grid.headers.add(1)[0];
    headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor(68, 114, 196));
    headerRow.style.textBrush = PdfBrushes.white;
    headerRow.cells[0].value = 'Réference';
    headerRow.cells[1].value = 'Article';
    headerRow.cells[2].value = 'Libélle';
    headerRow.cells[3].value = 'Unité';
    headerRow.cells[4].value = 'Quantité';
    headerRow.cells[5].value = 'Prix';
    headerRow.cells[6].value = 'Sous-total';
    headerRow.style.font =
        PdfStandardFont(PdfFontFamily.helvetica, 15, style: PdfFontStyle.bold);
    // ignore: prefer_const_constructors
    grid.draw(page: page, bounds: Rect.fromLTWH(0, 250, 0, 0))!;

    for (var i = 0; i < cmmd.length; i++) {
      final row = grid.rows.add();
      row.cells[0].value = cmmd[i]['réf'].toString();
      row.cells[1].value = cmmd[i]['Article'];
      row.cells[2].value = cmmd[i]['Description'];
      row.cells[3].value = cmmd[i]['Unite'];
      row.cells[4].value = cmmd[i]['Quantite'].toString();
      row.cells[5].value = cmmd[i]['prix'].toString();
      row.cells[6].value = cmmd[i]['sous-total'].toString();
      row.style.font = PdfStandardFont(PdfFontFamily.helvetica, 15,
          style: PdfFontStyle.bold);
      // ignore: prefer_const_constructors
      grid.draw(page: page, bounds: Rect.fromLTWH(0, 250, 0, 0))!;
    }
  }

  static void drawSignature(PdfPage page, ByteData imageSignature) {
    final pageSize = page.getClientSize();
    final PdfBitmap image = PdfBitmap(imageSignature.buffer.asUint8List());

    page.graphics.drawImage(image,
        Rect.fromLTWH(pageSize.width - 100, pageSize.height - 200, 100, 40));
  }

  static Future<File> saveFile(PdfDocument document) async {
    final path = await getApplicationDocumentsDirectory();
    final fileName = path.path + ' ${DateTime.now().toIso8601String()}.pdf';
    final file = File(fileName);
    file.writeAsBytes(document.save());
    document.dispose();
    return file;
  }
}
