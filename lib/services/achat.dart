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
      titre, numa, client, etat, total, ligneCommande, montant, date) {
    return achat
        .doc(titre)
        .set({
          'idAchat': titre,
          'numachat': numa,
          'fournisseur': client,
          'etat': etat,
          'total': total,
          'commande': ligneCommande,
          'montant': montant,
          "date d'achat": date,
        })
        // ignore: avoid_print
        .then((value) => showToast('achat ajouté'))
        // ignore: avoid_print
        .catchError(
            (error) => showToast("Échec de achat de l'appareil : $error"));
  }

  Future<void> updateAchat(titre, client, etat, total, cmd, montant) {
    return achat
        .doc(titre)
        .update({
          'fournisseur': client,
          'etat': etat,
          'total': total,
          'commande': cmd,
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
