// ignore_for_file: file_names

import 'package:chama_projet/widget/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommandeOperation {
  final CollectionReference commande =
      FirebaseFirestore.instance.collection('commandeOperation');

  Future getCommopList() async {
    List itemsList = [];

    try {
      await commande.get().then((querySnapshot) {
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

  Future<void> addCommdeop(colis, colisDes, article, appartenant, fait, unite) {
    return commande
        .add({
          'Article': article,
          'Colis source': colis,
          'Colis de destination': colisDes,
          'Appartenant': appartenant,
          'Fait': fait,
          'Unite': unite,
        })
        // ignore: avoid_print
        .then((value) => showToast("Commande ajoutée"))
        // ignore: avoid_print
        .catchError(
            (error) => showToast("Échec de l'ajout de la commande:$error"));
  }

  Future<void> deleteCommdeop() {
    // print("Employe Deleted $id");
    return commande.get().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });
  }
}
