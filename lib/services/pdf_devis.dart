import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:syncfusion_flutter_pdf/pdf.dart';

class PdDevis {
  static Future<File> generatePDF({
    required String titre,
    required ByteData imageSignature,
    required List commnd,
    required String client,
    required String date1,
    required double total,
  }) async {
    final document = PdfDocument();
    final page = document.pages.add();

    drawSignature(page, imageSignature);
    drawGrid(page, commnd);
    drawTitre(page, titre, client, date1, total);

    return saveFile(document);
  }

  static void drawTitre(
    PdfPage page,
    String titre,
    String client,
    String date1,
    double total,
  ) {
    final pageSize = page.getClientSize();
    page.graphics
        .drawString(titre, PdfStandardFont(PdfFontFamily.helvetica, 30),
            // ignore: prefer_const_constructors
            brush: PdfBrushes.black,
            // ignore: prefer_const_constructors
            bounds: Rect.fromLTWH(0, 10, 200, 0));
    page.graphics.drawString(
        "Client : $client", PdfStandardFont(PdfFontFamily.helvetica, 20),
        // ignore: prefer_const_constructors
        brush: PdfBrushes.black,
        // ignore: prefer_const_constructors
        bounds: Rect.fromLTWH(0, 50, 200, 0));
    page.graphics.drawString(
        "Date de devis : $date1", PdfStandardFont(PdfFontFamily.helvetica, 20),
        // ignore: prefer_const_constructors
        brush: PdfBrushes.black,
        // ignore: prefer_const_constructors
        bounds: Rect.fromLTWH(0, 80, 0, 0));

    page.graphics.drawString(
        "Total= $total £", PdfStandardFont(PdfFontFamily.helvetica, 30),
        brush: PdfBrushes.black,
        bounds:
            Rect.fromLTWH(pageSize.width - 300, pageSize.height - 300, 0, 0));
  }

  static void drawGrid(PdfPage page, List cmmd) {
    final grid = PdfGrid();
    grid.columns.add(count: 8);
    final headerRow = grid.headers.add(1)[0];
    headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor(68, 114, 196));
    headerRow.style.textBrush = PdfBrushes.white;
    headerRow.cells[0].value = 'réf';
    headerRow.cells[1].value = 'Article';
    headerRow.cells[2].value = 'Description';
    headerRow.cells[3].value = 'Unité';
    headerRow.cells[4].value = 'Quantité';
    headerRow.cells[5].value = 'Prix unitaire';
    headerRow.cells[6].value = 'Taxes';

    headerRow.cells[7].value = 'Sous-total';
    headerRow.style.font =
        PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.bold);
    // ignore: prefer_const_constructors
    grid.draw(page: page, bounds: Rect.fromLTWH(0, 250, 0, 0))!;

    for (var i = 0; i < cmmd.length; i++) {
      final row = grid.rows.add();
      row.cells[0].value = cmmd[i]['réf'].toString();
      row.cells[1].value = cmmd[i]['Article'];
      row.cells[2].value = cmmd[i]['Description'];
      row.cells[3].value = cmmd[i]['Unite'].toString();
      row.cells[4].value = cmmd[i]['Quantite'].toString();

      row.cells[5].value = cmmd[i]['prix'].toString();
      row.cells[6].value = "0.2";
      row.cells[7].value = cmmd[i]['sous-total'].toString();
      row.style.font = PdfStandardFont(PdfFontFamily.helvetica, 10,
          style: PdfFontStyle.bold);
      // ignore: prefer_const_constructors
      grid.draw(page: page, bounds: Rect.fromLTWH(0, 250, 0, 0))!;
    }
  }

  static void drawSignature(PdfPage page, ByteData imageSignature) {
    final pageSize = page.getClientSize();
    final PdfBitmap image = PdfBitmap(imageSignature.buffer.asUint8List());

    page.graphics.drawImage(image,
        Rect.fromLTWH(pageSize.width - 120, pageSize.height - 200, 100, 40));
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
