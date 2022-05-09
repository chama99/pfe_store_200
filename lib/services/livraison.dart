import 'package:chama_projet/widget/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Livraison {
  final CollectionReference livraisonn =
      FirebaseFirestore.instance.collection('livraison');

  Future getLivraisonList() async {
    List itemsList = [];

    try {
      await livraisonn.get().then((querySnapshot) {
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

  Future<void> addLivraison(
      id, titre, type, etat, date, ligneOperation, adresse) {
    return livraisonn
        .doc(id)
        .set({
          'IdLiv': id,
          'numliv': titre,
          "type d'operation": type,
          'etat': etat,
          'date prévue': date,
          "ligne d'operation": ligneOperation,
          "Adresse de livraison": adresse
        })
        // ignore: avoid_print
        .then((value) => showToast('produit ajouté'))
        // ignore: avoid_print
        .catchError(
            (error) => showToast("Échec de l'ajout de produit : $error"));
  }

  Future<void> updateLivraison(
      titre, type, etat, date, ligneOperation, adresse) {
    return livraisonn
        .doc(titre)
        .update({
          "type d'operation": type,
          'etat': etat,
          'date prévue': date,
          "ligne d'operation": ligneOperation,
          "Adresse de livraison": adresse
        })
        // ignore: avoid_print
        .then((value) => showToast("produit mis à jour"))
        // ignore: avoid_print
        .catchError((error) =>
            showToast("Échec de la mise à jour de produit : $error"));
  }

  Future<void> deleteLivraison(id) {
    // print("Employe Deleted $id");
    return livraisonn
        .doc(id)
        .delete()
        // ignore: avoid_print
        .then((value) => showToast('produit supprimé'))
        // ignore: avoid_print
        .catchError((error) =>
            showToast("Échec de la suppression de produit : $error"));
  }

  Future getRecepListByLigneLivraison() async {
    List itemsListNom = [];

    try {
      await livraisonn.get().then((querySnapshot) {
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
