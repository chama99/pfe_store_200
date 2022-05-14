import 'package:chama_projet/api/firebase_api.dart';
import 'package:chama_projet/model/user.dart';

import 'package:flutter/material.dart';

import '../api/firebase_api.dart';
import '../chat_widgets/chat_body_widget.dart';
import '../chat_widgets/chat_header_widget.dart';
import '../model/user.dart';

class ChatsPage extends StatelessWidget {
  final String email;
  const ChatsPage({required this.email, Key? key}) : super(key: key);
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
                          ChatHeaderWidget(currentUser: email, users: users),
                          ChatBodyWidget(currentUser: email, users: users)
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
