import 'package:chama_projet/model/user.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../model/user.dart';
import 'chat_page.dart';

class ChatHeaderWidget extends StatelessWidget {
  final List<User> users;
  final String currentUser;
  String name, email, url, role, id, tel, adr;
  List acces;
  ChatHeaderWidget({
    required this.id,
    required this.users,
    required this.currentUser,
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
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 24),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    CupertinoIcons.back,
                    size: 32,
                    color: Colors.white,
                  )),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.75,
                child: const Text(
                  'Messages',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.only(left: 12),
            height: 70,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];

                if (users[index].idUser != currentUser) {
                  return Container(
                    margin: const EdgeInsets.only(right: 12),
                    child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ChatPage(
                              id: id,
                              user: users[index],
                              loggedInUserMail: currentUser,
                              email: email,
                              name: name,
                              acces: acces,
                              role: role,
                              url: url,
                              tel: tel,
                              adr: adr,
                            ),
                          ));
                        },
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundImage: NetworkImage(user.urlAvatar!),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                                user.name!
                                    .substring(0, user.name!.indexOf(' ')),
                                style: TextStyle(color: Colors.white))
                          ],
                        )),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
          )
        ],
      ));
}
