import 'package:cloud_firestore/cloud_firestore.dart';

class Plan {
  String? IdPlan;
  String? subject;
  String? client;
  List<String>? owners;
  Timestamp? startTime;
  Timestamp? endTime;
  String? status;
  Plan(
      {required this.IdPlan,
      required this.subject,
      required this.client,
      required this.owners,
      required this.startTime,
      required this.endTime,
      required this.status});

  static Plan fromJson(dynamic json) => Plan(
        IdPlan: json['IdPlan'],
        subject: json['subject'],
        client: json['client'],
        owners: json['owners'],
        startTime: json['startTime'],
        endTime: json['endTime'],
        status: json['status'],
      );

  Map<String, dynamic> toJson() => {
        'IdPlan': IdPlan,
        'subject': subject,
        'client': client,
        'owners': owners,
        'startTime': startTime,
        'endTime': endTime,
        'status': status,
      };
}
