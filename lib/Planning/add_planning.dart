// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, sized_box_for_whitespace

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'bottomsheet.dart';
import 'home_page_planning.dart';

var data = FirebaseFirestore.instance;

class AddPlanning extends StatefulWidget {
  final List selectedItems;
  const AddPlanning({Key? key, required this.selectedItems}) : super(key: key);

  @override
  _AddPlanningState createState() => _AddPlanningState();
}

class _AddPlanningState extends State<AddPlanning> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.blueAccent,
              height: 50,
              width: double.infinity,
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Get.to(const MultiSelection());
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      )),
                  SizedBox(
                    width: size.width * 0.15,
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    height: size.height * 0.04,
                    child: Row(
                      children: [
                        Container(
                            child: Text(
                          " Ajouter un Planning",
                          style: TextStyle(
                              fontSize: size.height * 0.03,
                              color: Colors.white),
                        )),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Text(
                  "Techneciens :",
                  style: TextStyle(fontSize: 30),
                ),
              ),
            ),
            Container(
              height: 70,
              child: Wrap(
                spacing: 10,
                children: widget.selectedItems
                    .map((e) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(12)),
                            child: Text(
                              "$e",
                              style: TextStyle(fontSize: 30),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            bottomSheet(context, widget.selectedItems);
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
