import 'dart:convert';

import 'package:chama_projet/widget/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Contact {
  final CollectionReference employe =
      FirebaseFirestore.instance.collection('contacts');

  Future getContactsList() async {
    List itemsList = [];

    try {
      await employe.get().then((querySnapshot) {
        querySnapshot.docs.map((element) {
          Map a = element.data() as Map<String, dynamic>;
          var b = ({
            'id': element.reference.id,
            'email': a['email'],
            'name': a['name'],
            'type': a['type'],
            'image': a['image'],
            'portable professionnel': a['portable professionnel'],
            'Adresse professionnelle': a['Adresse professionnelle'],
            'Etiquette': a['Etiquette'],
          });

          // ignore: unused_local_variable
          var c = json.decode(json.encode(b));
          itemsList.add(c);
        }).toList();
      });
      return itemsList;
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
      return null;
    }
  }

  Future<void> addContact(id, email, nom, tel, adresse, type, etiquette, url) {
    return employe
        .doc(id)
        .set({
          'id': id,
          'email': email,
          'name': nom,
          'type': type,
          'image': url,
          'portable professionnel': tel,
          'Adresse professionnelle': adresse,
          'Etiquette': etiquette,
        })
        // ignore: avoid_print
        .then((value) => showToast('Contact ajouté'))
        // ignore: avoid_print
        .catchError(
            (error) => showToast("Échec de l'ajout du contact : $error"));
  }

  Future<void> updateContact(
      id, email, nom, tel, adresse, type, etiquette, url) {
    return employe
        .doc(id)
        .update({
          'id': id,
          'email': email,
          'portable professionnel': tel,
          'Adresse professionnelle': adresse,
          'type': type,
          'image': url,
          'Etiquette': etiquette,
        })
        // ignore: avoid_print
        .then((value) => showToast("Contact mis à jour"))
        // ignore: avoid_print
        .catchError((error) =>
            showToast("Échec de la mise à jour du contact : $error"));
  }

  Future<void> deleteContact(id) {
    // print("Employe Deleted $id");
    return employe
        .doc(id)
        .delete()
        // ignore: avoid_print
        .then((value) => showToast('Contact supprimé'))
        // ignore: avoid_print
        .catchError((error) =>
            showToast('Échec de la suppression du contact : $error'));
  }

  Future getContactListByNom() async {
    List itemsListNom = [];

    try {
      await employe.get().then((querySnapshot) {
        querySnapshot.docs.map((element) {
          Map a = element.data() as Map<String, dynamic>;
          itemsListNom.add(a['name']);
        }).toList();
      });
      return itemsListNom;
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
      return null;
    }
  }
}
