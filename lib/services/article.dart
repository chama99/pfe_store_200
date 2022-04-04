import 'package:cloud_firestore/cloud_firestore.dart';

class Article {
  final CollectionReference employe =
      FirebaseFirestore.instance.collection('Articles');

  Future getArticlesList() async {
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

  Future<void> addArticle(
      nom,
      type,
      code_barres,
      reference_interne,
      reference_fabricant,
      prix_vente,
      taxes_a_la_vente,
      sale_prix,
      prix_de_vente,
      prix_dachat,
      url) {
    return employe
        .doc(nom)
        .set({
          'nom': nom,
          'type': type,
          'image': url,
          'code_barres': code_barres,
          'reference_interne': reference_interne,
          'reference_fabricant': reference_fabricant,
          'prix_vente': prix_vente,
          'taxes_a_la_vente': taxes_a_la_vente,
          'sale_prix': sale_prix,
          'prix_de_vente': prix_de_vente,
        })
        // ignore: avoid_print
        .then((value) => print('Article Added'))
        // ignore: avoid_print
        .catchError((error) => print('Failed to Add article: $error'));
  }

  Future<void> updateArticle(
      nom,
      type,
      code_barres,
      reference_interne,
      reference_fabricant,
      prix_vente,
      taxes_a_la_vente,
      sale_prix,
      prix_de_vente,
      prix_dachat,
      url) {
    return employe
        .doc(nom)
        .update({
          'nom': nom,
          'type': type,
          'image': url,
          'code_barres': code_barres,
          'reference_interne': reference_interne,
          'reference_fabricant': reference_fabricant,
          'prix_vente': prix_vente,
          'taxes_a_la_vente': taxes_a_la_vente,
          'sale_prix': sale_prix,
          'prix_de_vente': prix_de_vente,
        })
        // ignore: avoid_print
        .then((value) => print("Article Updated"))
        // ignore: avoid_print
        .catchError((error) => print("Failed to update article: $error"));
  }

  Future<void> deleteArticle(id) {
    // print("Employe Deleted $id");
    return employe
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
      await employe.get().then((querySnapshot) {
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
}
