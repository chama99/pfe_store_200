import 'package:chama_projet/widget/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Commande {
  final CollectionReference commande =
      FirebaseFirestore.instance.collection('commandes');

  Future getCommandesList() async {
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

  Future<void> addCommande(
      ref, article, des, unite, qt, prix, taxe, soustotal) {
    return commande
        .add({
          'réf': ref,
          'Article': article,
          'Description': des,
          'Unite': unite,
          'Quantite': qt,
          'prix': prix,
          'taxe': taxe,
          'sous-total': soustotal
        })
        // ignore: avoid_print
        .then((value) => showToast("Commande ajoutée"))
        // ignore: avoid_print
        .catchError(
            (error) => showToast("Échec de l'ajout de la commande:$error"));
  }

  Future<void> deleteCommande() {
    // print("Employe Deleted $id");
    return commande.get().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });
  }
}
