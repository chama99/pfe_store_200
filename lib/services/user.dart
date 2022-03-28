// ignore_for_file: unused_import

import 'package:chama_projet/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final CollectionReference user =
      FirebaseFirestore.instance.collection('users');
  Future<void> addUser(email, name, password, role, url) {
    return user
        .doc(email)
        .set({
          'email': email,
          'name': name,
          'mot de passe': password,
          'role': role,
          'image': url,
          'acces': [],
        })
        // ignore: avoid_print
        .then((value) => print('User Added'))
        // ignore: avoid_print
        .catchError((error) => print('Failed to Add user: $error'));
  }

  Future getUsersList() async {
    List itemsList = [];

    try {
      await user.get().then((querySnapshot) {
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

  Future<void> updateUser(email, mdp, role, url, acces) {
    return user
        .doc(email)
        .update({
          'email': email,
          'mot de passe': mdp,
          'role': role,
          'image': url,
          'acces': acces,
        })
        // ignore: avoid_print
        .then((value) => print("User Updated"))
        // ignore: avoid_print
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> deleteUser(id) {
    // print("Employe Deleted $id");
    return user
        .doc(id)
        .delete()
        // ignore: avoid_print
        .then((value) => print('User Deleted'))
        // ignore: avoid_print
        .catchError((error) => print('Failed to Delete employé: $error'));
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

  Future<void> updateRoleUser(email, mdp, role, url, acces, name) {
    return user
        .doc(email)
        .set({
          'name': name,
          'email': email,
          'mot de passe': mdp,
          'role': role,
          'image': url,
          'acces': acces,
        })
        // ignore: avoid_print
        .then((value) => print("RoleUser Updated"))
        // ignore: avoid_print
        .catchError((error) => print("Failed to update Roleuser: $error"));
  }
}
