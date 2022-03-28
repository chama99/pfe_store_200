import 'package:flutter/material.dart';

class ListNotifications extends StatefulWidget {
  String text;
  ListNotifications({Key? key, required this.text}) : super(key: key);

  @override
  State<ListNotifications> createState() => _ListNotificationsState();
}

class _ListNotificationsState extends State<ListNotifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Notifications"),
          backgroundColor: Colors.orange,
        ),
        body: Container(
            child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Card(
                      child: InkWell(
                    onTap: () {},
                    splashColor: const Color.fromARGB(255, 3, 56, 109),
                    child: ListTile(
                      title: Text(widget.text),
                      leading: const CircleAvatar(
                        radius: 20.0,
                        backgroundImage: NetworkImage(
                            "https://www.pexels.com/fr-fr/photo/femme-portant-un-haut-a-bretelles-spaghetti-noir-415829/"),
                      ),
                    ),
                  ));
                })));
  }
}
