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
          itemsList.add(a);
        }).toList();
      });
      return itemsList;
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
      return null;
    }
  }

  Future<void> addContact(email, nom, tel, adresse, type, etiquette, url) {
    return employe
        .doc(nom)
        .set({
          'email': email,
          'name': nom,
          'type': type,
          'image': url,
          'portable professionnel': tel,
          'Adresse professionnelle': adresse,
          'Etiquette': etiquette,
        })
        // ignore: avoid_print
        .then((value) => print('Contact Added'))
        // ignore: avoid_print
        .catchError((error) => print('Failed to Add contact: $error'));
  }

  Future<void> updateContact(email, nom, tel, adresse, type, etiquette, url) {
    return employe
        .doc(nom)
        .update({
          'email': email,
          'portable professionnel': tel,
          'Adresse professionnelle': adresse,
          'type': type,
          'image': url,
          'Etiquette': etiquette,
        })
        // ignore: avoid_print
        .then((value) => print("Contact Updated"))
        // ignore: avoid_print
        .catchError((error) => print("Failed to update contact: $error"));
  }

  Future<void> deleteContact(id) {
    // print("Employe Deleted $id");
    return employe
        .doc(id)
        .delete()
        // ignore: avoid_print
        .then((value) => print('Contact Deleted'))
        // ignore: avoid_print
        .catchError((error) => print('Failed to Delete contact: $error'));
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
