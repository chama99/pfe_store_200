import 'package:chama_projet/api/firebase_api.dart';
import 'package:chama_projet/model/user.dart';

import 'package:flutter/material.dart';

import 'chat_body_widget.dart';
import 'chat_header_widget.dart';

class ChatsPage extends StatelessWidget {
  final String currentUserID;
  String name, id, tel, adr;
  String email;
  String url, role;
  List acces;

  ChatsPage(
      {required this.currentUserID,
      required this.tel,
      required this.adr,
      required this.id,
      required this.name,
      required this.email,
      required this.url,
      required this.acces,
      required this.role,
      Key? key});
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.orange,
        body: SafeArea(
          child: StreamBuilder<List<User>>(
            stream: FirebaseApi.getUsers(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());
                default:
                  if (snapshot.hasError) {
                    print(snapshot.error);
                    return buildText('Something Went Wrong Try later');
                  } else {
                    final users = snapshot.data;

                    if (users!.isEmpty) {
                      return buildText('No Users Found');
                    } else {
                      return Column(
                        children: [
                          ChatHeaderWidget(
                            users: users,
                            currentUserID: currentUserID,
                          ),
                          ChatBodyWidget(
                              users: users,
                              currentUserID: currentUserID,
                              idus: id,
                              url: url,
                              telus: tel,
                              adrus: adr,
                              accesus: acces,
                              nameus: name,
                              emailus: email,
                              roleus: role)
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
          style: const TextStyle(fontSize: 24, color: Colors.white),
        ),
      );
}
