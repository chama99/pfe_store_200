import 'package:chama_projet/model/user.dart';

import 'package:flutter/material.dart';

import '../chat_widgets/messages_widget.dart';
import '../chat_widgets/new_message_widget.dart';
import '../chat_widgets/profile_header_widget.dart';
import '../model/user.dart';
import '../widget/NavBottom.dart';

class ChatPage extends StatefulWidget {
  final User user;
  String name, email, url, role, id, tel, adr;
  List acces;
  final String loggedInUserMail;

  ChatPage({
    required this.id,
    required this.loggedInUserMail,
    required this.user,
    required this.email,
    required this.name,
    required this.acces,
    required this.url,
    required this.role,
    required this.tel,
    required this.adr,
    Key? key,
  }) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  void initState() {
    print(widget.user.toJson());
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.orange,
        bottomNavigationBar: NavBottom(
          id: widget.id,
          email: widget.email,
          name: widget.name,
          acces: widget.acces,
          url: widget.url,
          role: widget.role,
          tel: widget.tel,
          adr: widget.adr,
        ),
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
                    userMail: widget.user.idUser!,
                    currentUser: widget.loggedInUserMail,
                  ),
                ),
              ),
              NewMessageWidget(
                  idUser: widget.user.idUser!,
                  currentUserMail: widget.loggedInUserMail)
            ],
          ),
        ),
      );
}
