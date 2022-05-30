import 'package:chama_projet/api/firebase_api.dart';
import 'package:chama_projet/model/message.dart';

import 'package:flutter/material.dart';

import '../pages/utils.dart';
import 'message_widget.dart';

class MessagesWidget extends StatelessWidget {
  final String destID;
  final String currentUserID;

  const MessagesWidget({
    required this.currentUserID,
    required this.destID,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => StreamBuilder<List<Message>>(
        stream: FirebaseApi.getMessages(destID, currentUserID),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError) {
                return buildText(
                    'Something Went Wrong Try later ${snapshot.error}');
              } else {
                Utils.printLog(
                    "Chouf currentUSER $currentUserID desinationID $destID");
                Utils.printLog(
                    "---------------------------------------------------------");
                for (var element in snapshot.data!) {
                  Utils.printLog("${element.toJson()}");
                }
                Utils.printLog(
                    "---------------------------------------------------------");
                final messages = snapshot.data!
                    .where((e) =>
                        (e.destID == destID && e.senderID == currentUserID) ||
                        (e.destID == currentUserID && e.senderID == destID))
                    .toList();

                Utils.printLog(
                    "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
                for (var element in messages) {
                  Utils.printLog("${element.toJson()}");
                }
                Utils.printLog(
                    "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
                return messages.isEmpty
                    ? buildText('Say Hi..')
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        reverse: true,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];

                          //print(
                          //  "message.IdUser == currentUserID.  ${message.destID} == $currentUserID");
                          return MessageWidget(
                            message: message,
                            isMe: message.destID == destID,
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
          style: TextStyle(fontSize: 24),
        ),
      );
}
