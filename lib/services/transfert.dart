import 'package:chama_projet/widget/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Transfert {
  final CollectionReference transfert =
      FirebaseFirestore.instance.collection('transfert');

  Future getTransfert() async {
    List itemsList = [];

    try {
      await transfert.orderBy("numtran").get().then((querySnapshot) {
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

  Future<void> addTransfert(
      titre, numt, type, etat, date, ligneOperation, trf) {
    return transfert
        .doc(titre)
        .set({
          'IdTran': titre,
          'numtran': numt,
          "type d'operation": type,
          'etat': etat,
          'date prévue': date,
          "ligne d'operation": ligneOperation,
          "transfert à": trf
        })
        // ignore: avoid_print
        .then((value) => showToast('produit ajouté'))
        // ignore: avoid_print
        .catchError(
            (error) => showToast("Échec de l'ajout de produit : $error"));
  }

  Future<void> updateTransfert(titre, type, etat, date, ligneOperation, trf) {
    return transfert
        .doc(titre)
        .update({
          "type d'operation": type,
          'etat': etat,
          'date prévue': date,
          "ligne d'operation": ligneOperation,
          "transfert à": trf
        })
        // ignore: avoid_print
        .then((value) => showToast("produit mis à jour"))
        // ignore: avoid_print
        .catchError((error) =>
            showToast("Échec de la mise à jour de produit : $error"));
  }

  Future<void> deleteTransfert(id) {
    // print("Employe Deleted $id");
    return transfert
        .doc(id)
        .delete()
        // ignore: avoid_print
        .then((value) => showToast('produit supprimé'))
        // ignore: avoid_print
        .catchError((error) =>
            showToast("Échec de la suppression de produit : $error"));
  }

  Future getTransfertListByLigneOperation() async {
    List itemsListNom = [];

    try {
      await transfert.get().then((querySnapshot) {
        querySnapshot.docs.map((element) {
          Map a = element.data() as Map<String, dynamic>;
          itemsListNom.add(a["ligne d'operation"]);
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
