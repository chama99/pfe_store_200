import 'package:chama_projet/model/user.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'chat_page.dart';

class ChatHeaderWidget extends StatelessWidget {
  final List<User> users;
  final String currentUserID;

  const ChatHeaderWidget({
    required this.currentUserID,
    required this.users,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        color: Colors.orange,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
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
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  if (currentUserID != user.idUser) {
                    return Container(
                      margin: const EdgeInsets.only(right: 12),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ChatPage(
                                user: users[index],
                                currentUserID: currentUserID),
                          ));
                        },
                        child: CircleAvatar(
                          radius: 24,
                          backgroundImage: NetworkImage(user.urlAvatar!),
                        ),
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            )
          ],
        ),
      );
}
