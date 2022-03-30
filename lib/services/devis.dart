import 'package:cloud_firestore/cloud_firestore.dart';

class Devis {
  final CollectionReference devis =
      FirebaseFirestore.instance.collection('devis');

  Future getDevisList() async {
    List itemsList = [];

    try {
      await devis.get().then((querySnapshot) {
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

  Future<void> addDevis(titre, client, etat, total) {
    return devis
        .doc(titre)
        .set({
          'titre': titre,
          'client': client,
          'etat': etat,
          'total': total,
        })
        // ignore: avoid_print
        .then((value) => print('devis Added'))
        // ignore: avoid_print
        .catchError((error) => print('Failed to Add devis: $error'));
  }

  Future<void> updateDevis(titre, client, etat, commande, total) {
    return devis
        .doc(titre)
        .update({
          'titre': titre,
          'client': client,
          'etat': etat,
          'commande': commande,
          'total': total,
        })
        // ignore: avoid_print
        .then((value) => print("devis Updated"))
        // ignore: avoid_print
        .catchError((error) => print("Failed to update devis: $error"));
  }

  Future<void> deleteDevis(id) {
    // print("Employe Deleted $id");
    return devis
        .doc(id)
        .delete()
        // ignore: avoid_print
        .then((value) => print('Devis Deleted'))
        // ignore: avoid_print
        .catchError((error) => print('Failed to Delete devis: $error'));
  }

  Future getDevisListByNom() async {
    List itemsListNom = [];

    try {
      await devis.get().then((querySnapshot) {
        querySnapshot.docs.map((element) {
          Map a = element.data() as Map<String, dynamic>;
          itemsListNom.add(a['titre']);
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
