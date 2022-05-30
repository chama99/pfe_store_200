import 'package:chama_projet/model/user.dart';

import 'package:flutter/material.dart';

import '../../model/user.dart';
import '../widget/NavBottom.dart';
import 'chat_page.dart';

class ChatBodyWidget extends StatefulWidget {
  final List<User> users;
  final String currentUserID;
  final String emailus, nameus, url, roleus, adrus, telus, idus;

  final List accesus;

  const ChatBodyWidget({
    required this.users,
    required this.currentUserID,
    required this.idus,
    required this.url,
    required this.emailus,
    required this.nameus,
    required this.roleus,
    required this.accesus,
    required this.telus,
    required this.adrus,
    Key? key,
  }) : super(key: key);

  @override
  State<ChatBodyWidget> createState() => _ChatBodyWidgetState();
}

class _ChatBodyWidgetState extends State<ChatBodyWidget> {
  List<User> userBackup = [];
  List<User> userListTobuild = [];

  TextEditingController editingController = TextEditingController();

  @override
  void initState() {
    userBackup = widget.users;
    userListTobuild = widget.users;
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: buildChats(),
        ),
      );

  Widget buildChats() => Column(children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            onChanged: _runFilter,
            controller: editingController,
            decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide:
                      const BorderSide(color: Colors.orange, width: 1.5),
                ),
                labelText: "Recherche",
                labelStyle: const TextStyle(
                    fontSize: 20.0, color: Color.fromARGB(255, 102, 102, 102)),
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
            child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final user = userListTobuild[index];

            return user.idUser != widget.currentUserID
                ? SizedBox(
                    height: 75,
                    child: ListTile(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ChatPage(
                              user: user, currentUserID: widget.currentUserID),
                        ));
                      },
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(user.urlAvatar!),
                      ),
                      title: Text(user.name!),
                    ),
                  )
                : const SizedBox();
          },
          itemCount: userListTobuild.length,
        )),
        NavBottom(
            tel: widget.telus,
            adr: widget.adrus,
            id: widget.idus,
            email: widget.emailus,
            name: widget.nameus,
            acces: widget.accesus,
            url: widget.url,
            role: widget.roleus),
      ]);

  void _runFilter(String enteredKeyword) {
    List<User> results = [];
    if (enteredKeyword.isEmpty) {
      results = userBackup;
    } else {
      results = widget.users.where((employe) {
        final String namemploye = employe.name!.toLowerCase();
        final String input = enteredKeyword.toLowerCase();
        return namemploye.startsWith(input);
      }).toList();
    }

    setState(() {
      userListTobuild = results;
    });
  }
}
