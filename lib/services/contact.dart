import 'package:chama_projet/widget/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Contact {
  final CollectionReference client =
      FirebaseFirestore.instance.collection('clients');

  Future getContactsList() async {
    List itemsList = [];

    try {
      await client.orderBy("name").get().then((querySnapshot) {
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

  Future<void> addContact(id, email, nom, tel, adresse, etiquette, url) {
    return client
        .doc(id)
        .set({
          'id': id,
          'email': email,
          'name': nom,
          'image': url,
          'portable professionnel': tel,
          'Adresse professionnelle': adresse,
          'Etiquette': etiquette,
        })
        // ignore: avoid_print
        .then((value) => showToast('Client ajouté'))
        // ignore: avoid_print
        .catchError(
            (error) => showToast("Échec de l'ajout du client : $error"));
  }

  Future<void> updateContact(id, email, nom, tel, adresse, etiquette, url) {
    return client
        .doc(id)
        .update({
          'id': id,
          'email': email,
          'portable professionnel': tel,
          'Adresse professionnelle': adresse,
          'image': url,
          'Etiquette': etiquette,
        })
        // ignore: avoid_print
        .then((value) => showToast("Client mis à jour"))
        // ignore: avoid_print
        .catchError(
            (error) => showToast("Échec de la mise à jour du client : $error"));
  }

  Future<void> deleteContact(id) {
    // print("Employe Deleted $id");
    return client
        .doc(id)
        .delete()
        // ignore: avoid_print
        .then((value) => showToast('Client supprimé'))
        // ignore: avoid_print
        .catchError(
            (error) => showToast('Échec de la suppression du client : $error'));
  }

  Future getContactListByNom() async {
    List itemsListNom = [];

    try {
      await client.get().then((querySnapshot) {
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
