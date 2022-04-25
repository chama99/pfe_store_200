import 'package:chama_projet/widget/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Employe {
  final CollectionReference employe =
      FirebaseFirestore.instance.collection('employes');

  Future getEmployesList() async {
    List itemsList = [];

    try {
      await employe.get().then((querySnapshot) {
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

  Future<void> addEmploye(id, nom, tel, adresse) {
    return employe
        .doc(id)
        .set({
          'IdEmp': id,
          'name': nom,
          'portable professionnel': tel,
          'Adresse professionnelle': adresse,
        })
        // ignore: avoid_print
        .then((value) => showToast('Employé Ajouté'))
        // ignore: avoid_print
        .catchError(
            (error) => showToast("Échec de l'ajout de l'employé : $error"));
  }

  Future<void> updateEmploye(id, tel, adresse) {
    return employe
        .doc(id)
        .update({
          'portable professionnel': tel,
          'Adresse professionnelle': adresse,
        })
        // ignore: avoid_print
        .then((value) => showToast("Employé mis à jour"))
        // ignore: avoid_print
        .catchError((error) =>
            showToast("Échec de la mise à jour de l'employé : $error"));
  }

  Future<void> deleteEmploye(id) {
    // print("Employe Deleted $id");
    return employe
        .doc(id)
        .delete()
        // ignore: avoid_print
        .then((value) => print(showToast("Employé supprimé")))
        // ignore: avoid_print
        .catchError((error) =>
            showToast("Échec de la suppression de l'employé : $error"));
  }

  Future getEmployesListByNom() async {
    List itemsListNom = [];

    try {
      await employe.get().then((querySnapshot) {
        querySnapshot.docs.map((element) {
          Map a = element.data() as Map<String, dynamic>;
          itemsListNom.add(a['name']);
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
