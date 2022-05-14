// ignore_for_file: must_be_immutable, file_names

import 'package:chama_projet/pages/connexion.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../pages/chats_page.dart';

class NavBar extends StatelessWidget {
  String name;
  String email;
  String url;
  NavBar({Key? key, required this.name, required this.email, required this.url})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(name),
            accountEmail: Text(email),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.network(
                  url,
                  fit: BoxFit.cover,
                  width: 90,
                ),
              ),
            ),
            decoration: const BoxDecoration(color: Colors.orange),
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text("Notifications"),
            // ignore: avoid_returning_null_for_void
            onTap: () => null,
          ),
          const Divider(),
          ListTile(
              leading: const Icon(Icons.message),
              title: const Text("Messages"),
              // ignore: avoid_returning_null_for_void
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatsPage(email: email),
                  ))),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text("Déconnexion"),
            onTap: () => Get.to(() => const Connexion()),
          ),
        ],
      ),
    );
  }
}
