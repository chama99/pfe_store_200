// ignore_for_file: must_be_immutable, file_names

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../pages/chats_page.dart';

import '../users/profile.dart';
import 'menuAdmin.dart';

class NavBottom extends StatefulWidget {
  String name, id, tel, adr;
  String email;
  String url, role;
  List acces;
  NavBottom(
      {Key? key,
      required this.tel,
      required this.adr,
      required this.id,
      required this.name,
      required this.email,
      required this.url,
      required this.acces,
      required this.role})
      : super(key: key);
  @override
  State<NavBottom> createState() => _NavBottomState();
}

class _NavBottomState extends State<NavBottom> {
  int index = 2;

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      IconButton(
        onPressed: () => {
          Get.to(
            () => MenuAdmin(
                tel: widget.tel,
                adr: widget.adr,
                id: widget.id,
                email: widget.email,
                name: widget.name,
                acces: widget.acces,
                url: widget.url,
                role: widget.role),
          )
        },
        icon: const Icon(
          Icons.home,
          size: 30,
        ),
      ),
      IconButton(
        onPressed: () => {
          Get.to(
            () => ChatsPage(
              id: widget.id,
              email: widget.email,
              name: widget.name,
              url: widget.url,
              acces: widget.acces,
              role: widget.role,
              tel: widget.tel,
              adr: widget.adr,
            ),
          )
        },
        icon: const Icon(
          Icons.chat,
          size: 30,
        ),
      ),
      InkWell(
        onTap: () => {
          Get.to(() => Profile(
                id: widget.id,
                email: widget.email,
                nom: widget.name,
                role: widget.role,
                image: widget.url,
                acces: widget.acces,
                mdp: '',
                telef: widget.tel,
                adress: widget.adr,
              ))
        },
        child: const Icon(
          Icons.person,
          size: 30,
        ),
      )
    ];
    return Theme(
      data: Theme.of(context)
          .copyWith(iconTheme: const IconThemeData(color: Colors.white)),
      child: CurvedNavigationBar(
        items: items,
        height: 60,
        backgroundColor: Colors.transparent,
        color: Colors.orange,
        buttonBackgroundColor: Colors.orange,
      ),
    );
  }
}
