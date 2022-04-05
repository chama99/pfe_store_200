import 'package:chama_projet/widget/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommandeFact {
  final CollectionReference commande =
      FirebaseFirestore.instance.collection('commandefact');

  Future getCommList() async {
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

  Future<void> addCommde(lib, article, comp, etq, qt, prix, soustotal) {
    return commande
        .add({
          'Libélle': lib,
          'Article': article,
          'Compte analytique': comp,
          'Etiquette analytique': etq,
          'Quantite': qt,
          'prix': prix,
          'sous-total': soustotal
        })
        // ignore: avoid_print
        .then((value) => showToast("Commande ajoutée"))
        // ignore: avoid_print
        .catchError(
            (error) => showToast("Échec de l'ajout de la commande:$error"));
  }

  Future<void> deleteCommde() {
    // print("Employe Deleted $id");
    return commande.get().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });
  }
}
