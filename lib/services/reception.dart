import 'package:chama_projet/widget/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Reception {
  final CollectionReference reception =
      FirebaseFirestore.instance.collection('reception');

  Future getReceptionList() async {
    List itemsList = [];

    try {
      await reception.get().then((querySnapshot) {
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

  Future<void> addReception(titre, type, etat, date, ligneOperation, recept) {
    return reception
        .doc(titre)
        .set({
          'titre': titre,
          "type d'operation": type,
          'etat': etat,
          'date prévue': date,
          "ligne d'operation": ligneOperation,
          "reception": recept
        })
        // ignore: avoid_print
        .then((value) => showToast('produit ajouté'))
        // ignore: avoid_print
        .catchError(
            (error) => showToast("Échec de l'ajout de produit : $error"));
  }

  Future<void> updateReception(titre, type, etat, date, ligneOperation) {
    return reception
        .doc(titre)
        .update({
          'titre': titre,
          "type d'operation": type,
          'etat': etat,
          'date prévue': date,
          "ligne d'operation": ligneOperation,
        })
        // ignore: avoid_print
        .then((value) => showToast("produit mis à jour"))
        // ignore: avoid_print
        .catchError((error) =>
            showToast("Échec de la mise à jour de produit : $error"));
  }

  Future<void> deleteReception(id) {
    // print("Employe Deleted $id");
    return reception
        .doc(id)
        .delete()
        // ignore: avoid_print
        .then((value) => showToast('produit supprimé'))
        // ignore: avoid_print
        .catchError((error) =>
            showToast("Échec de la suppression de produit : $error"));
  }

  Future getRecepListByLigneOperation() async {
    List itemsListNom = [];

    try {
      await reception.get().then((querySnapshot) {
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
