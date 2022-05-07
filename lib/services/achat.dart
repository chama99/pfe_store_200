import 'package:chama_projet/widget/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Achat {
  final CollectionReference achat =
      FirebaseFirestore.instance.collection('achat');

  Future getAchatList() async {
    List itemsList = [];

    try {
      await achat.get().then((querySnapshot) {
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

  Future<void> addAchat(
      titre, client, etat, total, ligneCommande, remise, montant, date) {
    return achat
        .doc(titre)
        .set({
          'idAchat': titre,
          'fournisseur': client,
          'etat': etat,
          'total': total,
          'commande': ligneCommande,
          'remise': remise,
          'montant': montant,
          'date de devis': date,
        })
        // ignore: avoid_print
        .then((value) => showToast('achat ajouté'))
        // ignore: avoid_print
        .catchError(
            (error) => showToast("Échec de achat de l'appareil : $error"));
  }

  Future<void> updateAchat(titre, client, etat, total, cmd, remise, montant) {
    return achat
        .doc(titre)
        .update({
          'fournisseur': client,
          'etat': etat,
          'total': total,
          'commande': cmd,
          'remise': remise,
          'montant': montant
        })
        // ignore: avoid_print
        .then((value) => showToast("achat mis à jour"))
        // ignore: avoid_print
        .catchError((error) =>
            showToast("Échec de la mise à jour de l'appareil : $error"));
  }

  Future<void> deleteAchat(id) {
    // print("Employe Deleted $id");
    return achat
        .doc(id)
        .delete()
        // ignore: avoid_print
        .then((value) => showToast('achat supprimée'))
        // ignore: avoid_print
        .catchError((error) =>
            showToast("Échec de la suppression de l'appareil : $error"));
  }

  Future getAchatListByNom() async {
    List itemsListNom = [];

    try {
      await achat.get().then((querySnapshot) {
        querySnapshot.docs.map((element) {
          Map a = element.data() as Map<String, dynamic>;
          itemsListNom.add(a['idAchat']);
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
