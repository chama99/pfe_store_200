import 'dart:io';

import 'package:flutter/material.dart';

class ModalImage extends StatelessWidget {
  final String link;
  const ModalImage({Key? key, required this.link}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        insetPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        contentPadding: const EdgeInsets.all(0),
        scrollable: true,
        content: Builder(builder: (context) {
          return SizedBox(
              width: MediaQuery.of(context).size.width * .9,
              height: MediaQuery.of(context).size.height * .5,
              child: Stack(children: <Widget>[
                link.contains("https") || link.contains("http")
                    ? Center(child: Image.network(link))
                    : Center(child: Image.file(File(link))),
                Align(
                  // These values are based on trial & error method
                  alignment: const Alignment(0.98, -0.98),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.close,
                      color: Colors.black87,
                      size: 35,
                    ),
                  ),
                ),
              ]));
        }));
  }
}
