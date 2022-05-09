import 'package:cloud_firestore/cloud_firestore.dart';

class Plan {
  String? subject;
  String? client;
  List<String>? owners;
  Timestamp? startTime;
  Timestamp? endTime;
  String? status;

  Plan.fromJson(){}
}