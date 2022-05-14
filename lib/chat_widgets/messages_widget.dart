import 'package:chama_projet/api/firebase_api.dart';
import 'package:chama_projet/model/message.dart';

import 'package:flutter/material.dart';

import '../../api/firebase_api.dart';
import 'message_widget.dart';

class MessagesWidget extends StatelessWidget {
  final String userMail;
  final String currentUser;
  const MessagesWidget({
    required this.currentUser,
    required this.userMail,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => StreamBuilder<List<Message>>(
        stream: FirebaseApi.getMessages(userMail),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError) {
                return buildText('Something Went Wrong Try later');
              } else {
                final messages = snapshot.data;

                return messages!.isEmpty
                    ? buildText('Say Hi..')
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        reverse: true,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          print(
                              "=>>>>>>> message ${message.idUser} $currentUser");
                          return MessageWidget(
                            message: message,
                            isMe: message.idUser == userMail,
                          );
                        },
                      );
              }
          }
        },
      );

  Widget buildText(String text) => Center(
        child: Text(
          text,
          style: const TextStyle(fontSize: 24),
        ),
      );
}
