import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Utils {
  static StreamTransformer<QuerySnapshot<Map<String, dynamic>>, List<T>>
      transformer<T>(T Function(dynamic json) fromJson) => StreamTransformer<
              QuerySnapshot<Map<String, dynamic>>, List<T>>.fromHandlers(
            handleData: (QuerySnapshot data, EventSink<List<T>> sink) {
              final snaps = data.docs.map((doc) => doc.data()).toList();
              final users = snaps.map((json) => fromJson(json)).toList();

              sink.add(users);
            },
          );

  static DateTime? toDateTime(Timestamp value) {
    if (value == null) return null;

    return value.toDate();
  }

  static dynamic fromDateTimeToJson(DateTime date) {
    if (date == null) return null;

    return date.toUtc();
  }

  static DateTime toReadableDate(Timestamp t) {
    var time = DateTime.parse(t.toDate().toString());

    return DateTime(time.year, time.month, time.day);
  }
}
