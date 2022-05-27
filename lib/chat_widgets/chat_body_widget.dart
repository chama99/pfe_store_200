import 'package:chama_projet/model/user.dart';

import 'package:flutter/material.dart';

import '../../model/user.dart';
import 'chat_page.dart';

class ChatBodyWidget extends StatefulWidget {
  final List<User> users;
  final String currentUser;
  String name, email, url, role, id, tel, adr;
  List acces;
  ChatBodyWidget({
    required this.currentUser,
    required this.users,
    required this.email,
    required this.name,
    required this.acces,
    required this.url,
    required this.role,
    required this.id,
    required this.tel,
    required this.adr,
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
          padding: const EdgeInsets.all(10),
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

  Widget buildChats() {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: TextField(
          onChanged: _runFilter,
          controller: editingController,
          decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: const BorderSide(color: Colors.orange, width: 1.5),
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
      ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final user = userListTobuild[index];
          //print("user coming from drawer => ${user.idUser} ${widget.currentUser}");
          return user.idUser != widget.currentUser
              ? SizedBox(
                  height: 75,
                  child: ListTile(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ChatPage(
                          id: widget.id,
                          user: user,
                          loggedInUserMail: widget.currentUser,
                          email: widget.email,
                          name: widget.name,
                          acces: widget.acces,
                          role: widget.role,
                          url: widget.url,
                          adr: widget.adr,
                          tel: widget.tel,
                        ),
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
      )
    ]);
  }

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
