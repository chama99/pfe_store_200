import 'package:chama_projet/widget/toast.dart';
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

  Future<void> addDevis(
      titre, client, etat, total, ligneCommande, remise, montant, date) {
    return devis
        .doc(titre)
        .set({
          'titre': titre,
          'client': client,
          'etat': etat,
          'total': total,
          'commande': ligneCommande,
          'remise': remise,
          'montant': montant,
          'date de devis': date,
        })
        // ignore: avoid_print
        .then((value) => showToast('devis ajouté'))
        // ignore: avoid_print
        .catchError(
            (error) => showToast("Échec de l'ajout de l'appareil : $error"));
  }

  Future<void> updateDevis(titre, client, etat, total, cmd, remise, montant) {
    return devis
        .doc(titre)
        .update({
          'titre': titre,
          'client': client,
          'etat': etat,
          'total': total,
          'commande': cmd,
          'remise': remise,
          'montant': montant
        })
        // ignore: avoid_print
        .then((value) => showToast("devis mis à jour"))
        // ignore: avoid_print
        .catchError((error) =>
            showToast("Échec de la mise à jour de l'appareil : $error"));
  }

  Future<void> deleteDevis(id) {
    // print("Employe Deleted $id");
    return devis
        .doc(id)
        .delete()
        // ignore: avoid_print
        .then((value) => showToast('Devis Deleted'))
        // ignore: avoid_print
        .catchError((error) =>
            showToast("Échec de la suppression de l'appareil : $error"));
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
