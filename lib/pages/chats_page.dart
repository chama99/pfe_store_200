import 'package:chama_projet/api/firebase_api.dart';
import 'package:chama_projet/model/user.dart';

import 'package:flutter/material.dart';

import '../api/firebase_api.dart';
import '../chat_widgets/chat_body_widget.dart';
import '../chat_widgets/chat_header_widget.dart';
import '../model/user.dart';

class ChatsPage extends StatelessWidget {
  final String email, id;
  String name, url, role, tel, adr;
  List acces;
  ChatsPage(
      {required this.id,
      required this.email,
      required this.name,
      required this.acces,
      required this.url,
      required this.role,
      required this.tel,
      required this.adr,
      Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.orange,
        body: SafeArea(
          child: StreamBuilder<List<User>>(
            stream: FirebaseApi.getUsers(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Center(child: CircularProgressIndicator());
                default:
                  if (snapshot.hasError) {
                    print(snapshot.error);
                    return buildText(
                        "Échec de achat de l'appareil : ${snapshot.error}");
                  } else {
                    final users = snapshot.data;

                    if (users!.isEmpty) {
                      return buildText('No Users Found');
                    } else {
                      return Column(
                        children: [
                          ChatHeaderWidget(
                            id: id,
                            currentUser: email,
                            users: users,
                            name: name,
                            url: url,
                            acces: acces,
                            role: role,
                            email: email,
                            tel: tel,
                            adr: adr,
                          ),
                          ChatBodyWidget(
                            id: id,
                            currentUser: email,
                            users: users,
                            email: email,
                            name: name,
                            url: url,
                            acces: acces,
                            role: role,
                            tel: tel,
                            adr: adr,
                          )
                        ],
                      );
                    }
                  }
              }
            },
          ),
        ),
      );

  Widget buildText(String text) => Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      );
}
