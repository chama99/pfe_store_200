import 'package:chama_projet/Planning/plan_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class TechnicienPlan extends StatefulWidget {
  final String loggedInUserMail;
  final String username, techName, role;
  const TechnicienPlan(
      {Key? key,
      required this.loggedInUserMail,
      required this.username,
      required this.techName,
      required this.role})
      : super(key: key);

  @override
  State<TechnicienPlan> createState() => _TechnicienPlanState();
}

class _TechnicienPlanState extends State<TechnicienPlan> {
  bool _isLoading = true;
  List _plansOfTechnicien = [];
  final CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('plan');
  Future getData() async {
    QuerySnapshot querySnapshot = await _collectionRef.where('owners',
        arrayContainsAny: [widget.loggedInUserMail, widget.username]).get();
    return querySnapshot.docs.map((doc) {
      return doc;
    }).toList();
  }

  @override
  void initState() {
    getData().then((value) {
      setState(() {
        _plansOfTechnicien = value;
        _isLoading = false;
      });
    });
    //_plansOfTechnicien.map((e) => print(e.data()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CupertinoActivityIndicator(),
      );
    }
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          centerTitle: true,
          title: const Text("Mes plans"),
        ),
        body: _plansOfTechnicien.isEmpty
            ? buildText("Vous n'avez aucun plan")
            : ListView.builder(
                itemCount: _plansOfTechnicien.length,
                itemBuilder: (BuildContext context, int index) {
                  return _card(index, _plansOfTechnicien);
                }));
  }

  Widget _card(int index, dynamic list) {
    return GFCard(
        boxFit: BoxFit.cover,
        image: list[index]["picture"].isEmpty
            ? Image.network(
                'https://i0.wp.com/shahpourpouyan.com/wp-content/uploads/2018/10/orionthemes-placeholder-image-1.png')
            : Image.network(list[index]["picture"]),
        title: GFListTile(
          avatar: const CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(
                "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"),
          ),
          title: Text(
            list[index]["subject"],
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subTitle: Text(
            list[index]["client"],
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        content: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PlanScreen(
                          event: list[index],
                          planID: list[index].id,
                          role: widget.role,
                        )));
          },
          child: Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Text(
                    "Plus de details ",
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                  Icon(
                    CupertinoIcons.forward_fill,
                    color: Colors.blueAccent,
                  )
                ],
              )),
        )
        // buttonBar: GFButtonBar(
        //   children: <Widget>[
        //     GFButton(
        //       onPressed: () {},
        //       text: 'OK',
        //     ),
        //     GFButton(
        //       onPressed: () {},
        //       text: 'Cancel',
        //     ),
        //   ],
        // ),
        );
  }

  Widget buildText(String text) => Center(
        child: Text(
          text,
          style: const TextStyle(fontSize: 24),
        ),
      );
}
