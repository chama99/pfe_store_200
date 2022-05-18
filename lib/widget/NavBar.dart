// ignore_for_file: must_be_immutable, file_names

import 'package:chama_projet/pages/connexion.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../pages/chats_page.dart';

class NavBar extends StatelessWidget {
  String name;
  String email, role, id;
  String url;
  List acces;
  NavBar(
      {Key? key,
      required this.id,
      required this.name,
      required this.email,
      required this.url,
      required this.role,
      required this.acces})
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
              onTap: null),
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
