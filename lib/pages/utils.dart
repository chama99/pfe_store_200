import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

///f3ca1b70-fcd8-43b6-ab95-00a0adb4f933
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

  static String toReadableDate(t) {
    if (t == null) {
      return "";
    }
    var time;
    if (t is Timestamp) {
      time = DateTime.parse(t.toDate().toString());
    } else {
      time = DateTime.parse(t.toString());
    }
    String result = DateTime(time.year, time.month, time.day).toString();
    return result.substring(0, result.indexOf(" "));
  }

  static GetSnackBar SuccessSnackBar(
      {String title = 'Success', required String message}) {
    Get.log("[$title] $message");
    return GetSnackBar(
      titleText: Text(title.tr,
          style: Get.textTheme.headline6!
              .merge(TextStyle(color: Get.theme.primaryColor))),
      messageText: Text(message,
          style: Get.textTheme.caption!
              .merge(TextStyle(color: Get.theme.primaryColor))),
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(20),
      backgroundColor: Colors.green,
      icon: Icon(Icons.check_circle_outline,
          size: 32, color: Get.theme.primaryColor),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      borderRadius: 8,
      dismissDirection: DismissDirection.horizontal,
      duration: const Duration(seconds: 5),
    );
  }

  static snack(BuildContext ctx, IconData icon, String txt) {
    return ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Row(children: [
        Icon(
          icon,
          color: icon == Icons.check ? Colors.greenAccent : Colors.redAccent,
        ),
        const Spacer(),
        Text(txt)
      ]),
    ));
  }

  static void printLog([dynamic data, DateTime? startTime]) {
    var time = '';
    if (startTime != null) {
      final endTime = DateTime.now().difference(startTime);
      final icon = endTime.inMilliseconds > 2000
          ? '⌛️Slow-'
          : endTime.inMilliseconds > 1000
              ? '⏰Medium-'
              : '⚡️Fast-';
      time = '[$icon${endTime.inMilliseconds}ms]';
    }

    try {
      final now = DateFormat('h:mm:ss-ms').format(DateTime.now());
      debugPrint('ℹ️[${now}ms]$time${data.toString()}');

      if (data.toString().contains('is not a subtype of type')) {
        throw Exception();
      }
    } catch (e, trace) {
      debugPrint('🔴 ${data.toString()}');
      debugPrint(trace.toString());
    }
  }

  static capitalizeFirstLetter(String phrase) {
    return "${phrase[0].toUpperCase()}${phrase.substring(1).toLowerCase()}";
  }

  static modalShow(
    String text,
    BuildContext context, {
    bool success = true,
  }) async {
    return await showDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
              title: success
                  ? Lottie.asset("asset/success.json",
                      height: MediaQuery.of(context).size.height * 0.08,
                      repeat: false)
                  : const Icon(Icons.close,
                      color: Colors.red), //const Text("Succès"),
              content: Column(
                children: [
                  Text(text),
                ],
              ),
              actions: <Widget>[
                CupertinoDialogAction(
                  onPressed: () => Navigator.of(context).pop(),
                  isDefaultAction: true,
                  child: const Text("D'accord"),
                ),
              ],
            ));
  }

  static String formatDateToRender(DateTime _date) {
    return DateFormat("yyyy - MM - dd").format(_date);
  }

  static DateTime formatDateToCalculate(DateTime _date) {
    return DateTime(_date.year, _date.month, _date.day, 0, 0, 0);
  }
}
