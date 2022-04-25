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

  Future<void> addArticle(id, nom, type, role, cat, data, referenceinterne,
      taxesalavente, prixdachat, saleprix, prixdevente, unite, url, qt) {
    return article
        .doc(id)
        .set({
          'id_art': id,
          'nom_art': nom,
          'type_art': type,
          'role_art': role,
          'cat': cat,
          'code_a_barre': data,
          'reference_interne': referenceinterne,
          'taxes_a_la_vente': taxesalavente,
          'prix_dachat': prixdachat,
          'sale_prix': saleprix,
          'prix_de_vente': prixdevente,
          'unite': unite,
          'image': url,
          'Quantité': qt
        })
        // ignore: avoid_print
        .then((value) => print('Article Added'))
        // ignore: avoid_print
        .catchError((error) => print('Failed to Add article: $error'));
  }

  Future<void> updateArticle(id, nom, type, role, cat, data, referenceinterne,
      taxesalavente, prixdachat, saleprix, prixdevente, unite, url, qt) {
    return article
        .doc(id)
        .update({
          'id_art': id,
          'nom_art': nom,
          'type_art': type,
          'role_art': role,
          'cat': cat,
          'code_a_barre': data,
          'reference_interne': referenceinterne,
          'taxes_a_la_vente': taxesalavente,
          'prix_dachat': prixdachat,
          'sale_prix': saleprix,
          'prix_de_vente': prixdevente,
          'unite': unite,
          'image': url,
          'Quantité': qt
        })
        // ignore: avoid_print
        .then((value) => print("Article Updated"))
        // ignore: avoid_print
        .catchError((error) => print("Failed to update article: $error"));
  }

  Future<void> updateQuantite(id, qt) {
    return article
        .doc(id)
        .update({'Quantité': qt})
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
          itemsListNom.add(a['nom_art']);
        }).toList();
      });
      return itemsListNom;
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
      return null;
    }
  }

  Future getArticleListByTypeVendu() async {
    List itemsListNom = [];

    try {
      await article.get().then((querySnapshot) {
        querySnapshot.docs.map((element) {
          Map a = element.data() as Map<String, dynamic>;
          if (a['type_art'] == "Peut être vendu") {
            itemsListNom.add(a["nom_art"]);
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

  Future getArticleListByTypeservice() async {
    List itemsListNom = [];

    try {
      await article.get().then((querySnapshot) {
        querySnapshot.docs.map((element) {
          Map a = element.data() as Map<String, dynamic>;
          if (a['role_art'] == "Service") {
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

  Future getArticleListByTypestock() async {
    List itemsListNom = [];

    try {
      await article.get().then((querySnapshot) {
        querySnapshot.docs.map((element) {
          Map a = element.data() as Map<String, dynamic>;
          if (a['role_art'] == "Article stockable") {
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

  Future getArticleListByTypeconsom() async {
    List itemsListNom = [];

    try {
      await article.get().then((querySnapshot) {
        querySnapshot.docs.map((element) {
          Map a = element.data() as Map<String, dynamic>;
          if (a['role_art'] == "Article consommable") {
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

  Future getArticleListByid(id) async {
    List itemsListNom = [];

    try {
      await article.get().then((querySnapshot) {
        querySnapshot.docs.map((element) {
          Map a = element.data() as Map<String, dynamic>;
          if (a['id_art'] == id) {
            itemsListNom.add(a["Quantité"]);
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

  Future getArticleListByid2(nom) async {
    List itemsListNom = [];

    try {
      await article.get().then((querySnapshot) {
        querySnapshot.docs.map((element) {
          Map a = element.data() as Map<String, dynamic>;
          if (a['nom_art'] == nom) {
            itemsListNom.add(a["id_art"]);
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

  Future getArticleListByid3(id) async {
    List itemsListNom = [];

    try {
      await article.get().then((querySnapshot) {
        querySnapshot.docs.map((element) {
          Map a = element.data() as Map<String, dynamic>;
          if (a['id_art'] == id) {
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
