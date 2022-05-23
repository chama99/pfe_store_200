import 'package:chama_projet/widget/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AutoFacture {
  final CollectionReference autofact =
      FirebaseFirestore.instance.collection('AutoFacture');

  Future getFacturesList() async {
    List itemsList = [];

    try {
      await autofact.orderBy("numfact").get().then((querySnapshot) {
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

  Future<void> addFacture(titre, numero, numdev, client, etat, date1, total,
      ligneCommande, remise, montant) {
    return autofact
        .doc(titre)
        .set({
          'IdFact': titre,
          'numfact': numero,
          'numdevis': numdev,
          'client': client,
          'etat': etat,
          'date de facturation': date1,
          'total': total,
          'ligne facture': ligneCommande,
          'remise': remise,
          'montant': montant
        })
        // ignore: avoid_print
        .then((value) => showToast('facture ajouté'))
        // ignore: avoid_print
        .catchError(
            (error) => showToast("Échec de l'ajout de facture : $error"));
  }

  Future<void> updateFacture(
      titre, client, etat, date1, total, ligneCommande, remise, montant) {
    return autofact
        .doc(titre)
        .update({
          'client': client,
          'etat': etat,
          'date de facturation': date1,
          'total': total,
          'ligne facture': ligneCommande,
          'remise': remise,
          'montant': montant
        })
        // ignore: avoid_print
        .then((value) => showToast("facture mis à jour"))
        // ignore: avoid_print
        .catchError((error) =>
            showToast("Échec de la mise à jour de facture : $error"));
  }

  Future<void> deleteFacture(id) {
    // print("Employe Deleted $id");
    return autofact
        .doc(id)
        .delete()
        // ignore: avoid_print
        .then((value) => showToast('facture supprimé'))
        // ignore: avoid_print
        .catchError((error) =>
            showToast("Échec de la suppression de facture : $error"));
  }

  Future getFactureListByLigneFact() async {
    List itemsListNom = [];

    try {
      await autofact.get().then((querySnapshot) {
        querySnapshot.docs.map((element) {
          Map a = element.data() as Map<String, dynamic>;
          itemsListNom.add(a['ligne facture']);
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
