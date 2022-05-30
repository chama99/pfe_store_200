import 'package:chama_projet/chat_widgets/profile_header_widget.dart';
import 'package:chama_projet/model/user.dart';

import 'package:flutter/material.dart';

import 'messages_widget.dart';
import 'new_message_widget.dart';

class ChatPage extends StatefulWidget {
  final User user;
  final String currentUserID;

  const ChatPage({
    required this.currentUserID,
    required this.user,
    Key? key,
  }) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.orange,
        body: SafeArea(
          child: Column(
            children: [
              ProfileHeaderWidget(name: widget.user.name!),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  child: MessagesWidget(
                    destID: widget.user.idUser!,
                    currentUserID: widget.currentUserID,
                  ),
                ),
              ),
              NewMessageWidget(
                  currentUserID: widget.currentUserID,
                  destID: widget.user.idUser!)
            ],
          ),
        ),
      );
}
