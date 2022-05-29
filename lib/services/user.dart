// ignore_for_file: unused_import

import 'package:chama_projet/widget/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final CollectionReference user =
      FirebaseFirestore.instance.collection('users');
  Future<void> addUser(
      id, email, name, password, role, url, acces, telephone, adresse) {
    return user
        .doc(id)
        .set({
          'IdUser': id,
          'email': email,
          'name': name,
          'mot de passe': password,
          'role': role,
          'image': url,
          'acces': acces,
          'telephone': telephone,
          'adresse': adresse,
          'paidLeaveDaysLeft' : "21",
          'totalExpiredLeaveDays' : "0",
          'lastMessageTime': Timestamp.fromDate(DateTime.now())
        })
        // ignore: avoid_print
        .then((value) => showToast("Utilisateur ajouté"))
        // ignore: avoid_print
        .catchError(
            (error) => showToast("Échec de l'ajout de l'utilisateur : $error"));
  }

  Future getUsersList() async {
    List itemsList = [];

    try {
      await user.orderBy("name").get().then((querySnapshot) {
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

  Future getUsersByEmail() async {
    List itemsList = [];

    try {
      await user.get().then((querySnapshot) {
        querySnapshot.docs.map((element) {
          Map a = element.data() as Map<String, dynamic>;
          itemsList.add(a['email']);
        }).toList();
      });
      return itemsList;
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
      return null;
    }
  }

  Future<void> updateUser(id, email, mdp, role, url, acces) {
    return user
        .doc(id)
        .update({
          'email': email,
          'mot de passe': mdp,
          'role': role,
          'image': url,
          'acces': acces,
        })
        // ignore: avoid_print
        .then((value) => showToast("Mise à jour de l'utilisateur"))
        // ignore: avoid_print
        .catchError((error) =>
            showToast("Échec de la mise à jour de l'utilisateur : $error"));
  }

  Future<void> updateProf(id, email, adr, phone, url) {
    return user
        .doc(id)
        .update(
            {'email': email, 'telephone': phone, 'adresse': adr, 'image': url})
        // ignore: avoid_print
        .then((value) => showToast("Mise à jour de l'utilisateur"))
        // ignore: avoid_print
        .catchError((error) =>
            showToast("Échec de la mise à jour de l'utilisateur : $error"));
  }

  Future<void> deleteUser(id) {
    // print("Employe Deleted $id");
    return user
        .doc(id)
        .delete()
        // ignore: avoid_print
        .then((value) => showToast("Utilisateur supprimé"))
        // ignore: avoid_print
        .catchError((error) =>
            showToast("Échec de la suppression de l'employé : $error"));
  }

  Future getListUserTech() async {
    List itemsListNom = [];

    try {
      await user.get().then((querySnapshot) {
        querySnapshot.docs.map((element) {
          Map a = element.data() as Map<String, dynamic>;
          if (a['role'] == "Technicien") {
            itemsListNom.add(a);
          }
        }).toList();
      });
      return itemsListNom;
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
      return null;
    }
  }

  Future getListUserCompt() async {
    List itemsListNom = [];

    try {
      await user.get().then((querySnapshot) {
        querySnapshot.docs.map((element) {
          Map a = element.data() as Map<String, dynamic>;
          if (a['role'] == "Comptable") {
            itemsListNom.add(a);
          }
        }).toList();
      });
      return itemsListNom;
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
      return null;
    }
  }

  Future<void> updateRoleUser(id, acces) {
    return user
        .doc(id)
        .update({
          'acces': acces,
        })
        // ignore: avoid_print
        .then((value) => print("RoleUser Updated"))
        // ignore: avoid_print
        .catchError((error) => print("Failed to update Roleuser: $error"));
  }
}
