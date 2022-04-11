import 'package:chama_projet/widget/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Facture {
  final CollectionReference devis =
      FirebaseFirestore.instance.collection('factures');

  Future getFacturesList() async {
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

  Future<void> addFacture(titre, client, etat, date1, date2, adresse, total,
      ligneCommande, remise, montant) {
    return devis
        .doc(titre)
        .set({
          'titre': titre,
          'client': client,
          'etat': etat,
          'date de facturation': date1,
          "adresse d'intervention": adresse,
          "date d'intervention": date2,
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

  Future<void> updateFacture(titre, client, etat, date1, date2, adresse, total,
      ligneCommande, remise, montant) {
    return devis
        .doc(titre)
        .update({
          'titre': titre,
          'client': client,
          'etat': etat,
          'date de facturation': date1,
          "adresse d'intervention": adresse,
          "date d'intervention": date2,
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
    return devis
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
      await devis.get().then((querySnapshot) {
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
