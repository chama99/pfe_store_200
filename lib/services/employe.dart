import 'package:cloud_firestore/cloud_firestore.dart';

class Employe {
  final CollectionReference employe =
      FirebaseFirestore.instance.collection('employes');

  Future<void> createUserData(
      String name, String gender, int score, String uid) async {
    return await employe
        .doc(uid)
        .set({'name': name, 'gender': gender, 'score': score});
  }

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

  Future<void> addEmploye(email, nom, tel, adresse, role, url) {
    return employe
        .doc(nom)
        .set({
          'email': email,
          'name': nom,
          'role': role,
          'image': url,
          'portable professionnel': tel,
          'Adresse professionnelle': adresse,
        })
        // ignore: avoid_print
        .then((value) => print('Employé Added'))
        // ignore: avoid_print
        .catchError((error) => print('Failed to Add employé: $error'));
  }

  Future<void> updateEmploye(email, nom, tel, adresse, role, url) {
    return employe
        .doc(nom)
        .update({
          'email': email,
          'portable professionnel': tel,
          'Adresse professionnelle': adresse,
          'role': role,
          'image': url,
        })
        // ignore: avoid_print
        .then((value) => print("Employe Updated"))
        // ignore: avoid_print
        .catchError((error) => print("Failed to update employé: $error"));
  }

  Future<void> deleteEmploye(id) {
    // print("Employe Deleted $id");
    return employe
        .doc(id)
        .delete()
        // ignore: avoid_print
        .then((value) => print('Employe Deleted'))
        // ignore: avoid_print
        .catchError((error) => print('Failed to Delete employé: $error'));
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
