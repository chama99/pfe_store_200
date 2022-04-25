// ignore_for_file: file_names, unused_local_variable, camel_case_types

import 'package:chama_projet/services/article.dart';

import 'package:flutter/material.dart';
import '../widget/boitedialogue.dart';
import 'ArticleDetail.dart';
import 'cree_article.dart';

class listArticle extends StatefulWidget {
  const listArticle({Key? key}) : super(key: key);

  @override
  _listArticleState createState() => _listArticleState();
}

class _listArticleState extends State<listArticle> {
  TextEditingController searchcontroller = TextEditingController();
  TextEditingController editingController = TextEditingController();
  List userArticleList = [];
  @override
  void initState() {
    super.initState();

    fetchDatabaseList();
  }

  fetchDatabaseList() async {
    dynamic resultant = await Article().getArticlesList();

    if (resultant == null) {
      // ignore: avoid_print
      print('Unable to retrieve');
    } else {
      setState(() {
        userArticleList = resultant;
      });
    }
  }

  // ignore: prefer_typing_uninitialized_variables
  var length;

  // ignore: unnecessary_new
  Widget appBarTitle = const Text("Articles");
  Icon actionIcon = const Icon(Icons.search);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: appBarTitle,
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 20, right: 30),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CreeArticlePage()));
                  print(userArticleList);
                },
                child: Text(
                  "Créer".toUpperCase(),
                  style: const TextStyle(
                      fontSize: 15, color: Colors.white, letterSpacing: 3),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          ],
          backgroundColor: Colors.orange,
        ),
        body: Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  onChanged: (value) {
                    filterSearchResults(value);
                  },
                  controller: editingController,
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide:
                            const BorderSide(color: Colors.orange, width: 1.5),
                      ),
                      labelText: "Search",
                      labelStyle: const TextStyle(
                          fontSize: 20.0,
                          color: Color.fromARGB(255, 102, 102, 102)),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.orange,
                      ),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                      )),
                ),
              ),
              Expanded(
                child: userArticleList.isEmpty
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : RefreshIndicator(
                        onRefresh: () {
                          Navigator.pushReplacement(
                              context,
                              PageRouteBuilder(
                                  pageBuilder: (a, b, c) => const listArticle(),
                                  transitionDuration:
                                      const Duration(seconds: 0)));
                          // ignore: void_checks
                          return Future.value(false);
                        },
                        child: ListView.builder(
                            itemCount: userArticleList.length,
                            itemBuilder: (context, index) {
                              final article = userArticleList[index];
                              return Card(
                                  child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ArticleDetail(
                                                id: userArticleList[index]
                                                    ['id_art'],
                                                nom: userArticleList[index]
                                                    ['nom_art'],
                                                type: userArticleList[index]
                                                    ['type_art'],
                                                role: userArticleList[index]
                                                    ['role_art'],
                                                cat: userArticleList[index]
                                                    ['cat'],
                                                data: userArticleList[index]
                                                    ['code_a_barre'],
                                                reference_interne:
                                                    userArticleList[index]
                                                        ['reference_interne'],
                                                taxes_a_la_vente:
                                                    userArticleList[index]
                                                        ['taxes_a_la_vente'],
                                                prix_dachat:
                                                    userArticleList[index]
                                                        ['prix_dachat'],
                                                sale_prix:
                                                    userArticleList[index]
                                                        ['sale_prix'],
                                                prix_de_vente:
                                                    userArticleList[index]
                                                        ['prix_de_vente'],
                                                unite: userArticleList[index]
                                                    ['unite'],
                                                image: userArticleList[index]
                                                    ['image'],
                                                qt: userArticleList[index]
                                                    ["Quantité"],
                                              )));
                                },
                                splashColor:
                                    const Color.fromARGB(255, 3, 56, 109),
                                child: ListTile(
                                  title: Text(article['nom_art']),
                                  subtitle: Text(article['cat']),
                                  trailing: IconButton(
                                    onPressed: () => {
                                      openDialog(
                                          context,
                                          article["id_art"],
                                          "Êtes-vous sûr de vouloir supprimer cette article",
                                          "article")
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ),
                                  leading: CircleAvatar(
                                    radius: 20.0,
                                    backgroundImage:
                                        NetworkImage(article['image']),
                                  ),
                                ),
                              ));
                            })),
              ),
            ],
          ),
        ));
  }

  void filterSearchResults(String query) {
    final suggestions = userArticleList.where((article) {
      final nom = article['nom'].toLowerCase();
      final input = query.toLowerCase();
      return nom.contains(input);
    }).toList();
    setState(() {
      userArticleList = suggestions;
    });
  }
}
