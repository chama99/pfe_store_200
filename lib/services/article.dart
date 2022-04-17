import 'package:cloud_firestore/cloud_firestore.dart';

class Article {
  final CollectionReference article =
      FirebaseFirestore.instance.collection('Articles');

  Future getArticlesList() async {
    List itemsList = [];

    try {
      await article.get().then((querySnapshot) {
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

  Future<void> addArticle(nom, type, role, cat, data, reference_interne,
      taxes_a_la_vente, prix_dachat, sale_prix, prix_de_vente, unite, url) {
    return article
        .doc(nom)
        .set({
          'nom': nom,
          'type': type,
          'role': role,
          'cat': cat,
          'code_a_barre': data,
          'reference_interne': reference_interne,
          'taxes_a_la_vente': taxes_a_la_vente,
          'prix_dachat': prix_dachat,
          'sale_prix': sale_prix,
          'prix_de_vente': prix_de_vente,
          'unite': unite,
          'image': url,
        })
        // ignore: avoid_print
        .then((value) => print('Article Added'))
        // ignore: avoid_print
        .catchError((error) => print('Failed to Add article: $error'));
  }

  Future<void> updateArticle(nom, type, role, cat, data, reference_interne,
      taxes_a_la_vente, prix_dachat, sale_prix, prix_de_vente, unite, url) {
    return article
        .doc(nom)
        .update({
          'nom': nom,
          'type': type,
          'role': role,
          'cat': cat,
          'code_a_barre': data,
          'reference_interne': reference_interne,
          'taxes_a_la_vente': taxes_a_la_vente,
          'prix_dachat': prix_dachat,
          'sale_prix': sale_prix,
          'prix_de_vente': prix_de_vente,
          'unite': unite,
          'image': url,
        })
        // ignore: avoid_print
        .then((value) => print("Article Updated"))
        // ignore: avoid_print
        .catchError((error) => print("Failed to update article: $error"));
  }

  Future<void> deleteArticle(id) {
    // print("Employe Deleted $id");
    return article
        .doc(id)
        .delete()
        // ignore: avoid_print
        .then((value) => print('Article Deleted'))
        // ignore: avoid_print
        .catchError((error) => print('Failed to Delete article: $error'));
  }

  Future getArticleListByNom() async {
    List itemsListNom = [];

    try {
      await article.get().then((querySnapshot) {
        querySnapshot.docs.map((element) {
          Map a = element.data() as Map<String, dynamic>;
          itemsListNom.add(a['nom']);
        }).toList();
      });
      return itemsListNom;
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
      return null;
    }
  }

  Future getArticleListByTyoeservice() async {
    List itemsListNom = [];

    try {
      await article.get().then((querySnapshot) {
        querySnapshot.docs.map((element) {
          Map a = element.data() as Map<String, dynamic>;
          if (a['role'] == "Service") {
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

  Future getArticleListByTyid(id) async {
    List itemsListNom = [];

    try {
      await article.get().then((querySnapshot) {
        querySnapshot.docs.map((element) {
          Map a = element.data() as Map<String, dynamic>;
          if (a['nom'] == "id") {
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
}
