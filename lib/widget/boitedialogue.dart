import 'package:chama_projet/services/contact.dart';
import 'package:chama_projet/services/employe.dart';
import 'package:chama_projet/services/user.dart';
import 'package:flutter/material.dart';

Future openDialog(context, id, mssg, ch) {
  return showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(mssg),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Annuler')),
              TextButton(
                  onPressed: () {
                    if (ch == "employé") {
                      Employe().deleteEmploye(id);
                    } else if (ch == "utilisateur") {
                      User().deleteUser(id);
                    } else {
                      Contact().deleteContact(id);
                    }
                    Navigator.of(context).pop();
                  },
                  child: const Text('Confirmer')),
            ],
          ));
}
