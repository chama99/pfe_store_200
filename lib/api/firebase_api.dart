import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chama_projet/model/message.dart';
import 'package:chama_projet/model/user.dart';
import 'package:flutter_azure_b2c/GUIDGenerator.dart';

import '../model/user.dart';
import '../pages/utils.dart';

class FirebaseApi {
  static final fbRef = FirebaseFirestore.instance;
  static getUser(String userID) async {
    print("/////////$userID");
    var user = await fbRef.collection("users").doc(userID).get();
    return user.data();
  }

  static Stream<List<User>>? getUsers() {
    var x = fbRef
        .collection('users')
        .orderBy(UserField.lastMessageTime, descending: true)
        .snapshots()
        .transform(Utils.transformer(User.fromJson));
    //print(x);
    return x;
  }

  static Future uploadMessage(
      String currentUserID, String destID, String message) async {
    print(" eli connecter = $currentUserID  eli bésh nab3thlou $destID");
    final refUsers = fbRef.collection("users");
    final refMessages = fbRef.collection('chats');
    var step = await refUsers.where('IdUser', isEqualTo: currentUserID).get();
    var user = step.docs.map((doc) => doc.data()).toList().first;
    final newMessage = Message(
      senderID: currentUserID,
      destID: destID,
      urlAvatar: user['image'],
      username: user['name'],
      message: message,
      createdAt: DateTime.now(),
    );
    await refMessages.add(newMessage.toJson());

    await refUsers
        .doc(currentUserID)
        .update({UserField.lastMessageTime: DateTime.now()});
  }

  static Stream<List<Message>> getMessages(
      String currentUserID, String destID) {
    return fbRef
        .collection('chats')
        //.where("destID", isEqualTo: destID)
        .orderBy(MessageField.createdAt, descending: true)
        .snapshots()
        .transform(Utils.transformer(Message.fromJson));
  }

  static Future addRandomUsers(List<User> users) async {
    final refUsers = fbRef.collection('users');
    final allUsers = await refUsers.get();
    if (allUsers.size != 0) {
      return;
    } else {
      for (final user in users) {
        final userDoc = refUsers.doc();
        final newUser = user.copyWith(idUser: userDoc.id);

        await userDoc.set(newUser.toJson());
      }
    }
  }

  static Future? createNewLeave(String userID, String leaveDays) {
    final refUsers = fbRef.collection("users");
    refUsers.doc(userID).update({"leaveDays": leaveDays});
  }

  static Future<List<String?>>? getLeaveDays(String userID) async {
    var days = await fbRef.collection("users").doc(userID).get();
    return [
      days.data()!["paidLeaveDaysLeft"].toString(),
      days.data()!["totalExpiredLeaveDays"].toString()
    ];
  }

  ///hard coded id "f3ca1b70-fcd8-43b6-ab95-00a0adb4f933" << is for the administrator
  /// as we demand leave for admins right ???
  ///For this "{{$userID}}" this is the user who demanded the
  ///holiday(leave) it's like a template so if we find it
  ///then that's something which should be rendred like
  ///cards containg a aceept or refuse button
  ///so incase the  admin id changed this should be changed so the app
  ///keep running like it should
  /// here's 4 apples from Anoir
  static Future createLeaveDemande(String userID, String duration,
      Timestamp beginDate, String leaveType, String description) async {
    var uuid = GUIDGen.generate();
    var user = await fbRef.collection("users").doc(userID).get();
    await fbRef.collection("conge").doc(uuid).set({
      "leaveID": uuid,
      "userID": userID,
      "duration": duration,
      "beginDateOfTheHoliday": beginDate,
      "leaveType": leaveType,
      "status": 'waiting',
      "description": description,
      "username": user.data()!["name"]
    }).then((value) async => await uploadMessage(
        userID, "{{$userID}}", "f3ca1b70-fcd8-43b6-ab95-00a0adb4f933"));
  }

  static Future<List?>? getLeaveDemandes() async {
    var leaveDemandes = await fbRef.collection("conge").get();
    var leaveList = leaveDemandes.docs;
    return leaveList;
  }

  static Future<bool> updateLeave(
      String leaveID, String status, String congeType,
      {String? duration, String? userID}) async {
    await fbRef
        .collection("conge")
        .doc(leaveID)
        .update({"status": status}).then((value) {
      if (status != "accepted") {
        return true;
      }
    }).onError((error, stackTrace) {
      return false;
    });

    if (status == "accepted" && congeType == "paid") {
      getUser(userID!).then((value) async {
        var leaveDays = int.parse(value["leaveDays"] ?? "0");
        var paidLeaveDaysLeft = int.parse(value["paidLeaveDaysLeft"] ?? "0");
        var totalExpiredLeaveDays =
            int.parse(value["totalExpiredLeaveDays"] ?? "0");
        var newLeaveDays = leaveDays + int.parse(duration!);
        var newPaidLeaveDaysLeft = paidLeaveDaysLeft - int.parse(duration);
        var newTotalExpiredLeaveDays =
            totalExpiredLeaveDays + int.parse(duration);
        await fbRef.collection("users").doc(userID).update({
          "leaveDays": newLeaveDays.toString(),
          "paidLeaveDaysLeft": newPaidLeaveDaysLeft.toString(),
          "totalExpiredLeaveDays": newTotalExpiredLeaveDays.toString()
        }).then((value) {
          return true;
        }).onError((error, stackTrace) {
          return false;
        });
      });
      return true;
    }
    print("wselt lel lekher");
    return false;
  }

  static getLeaveDemandAccepted(String userID) async {
    var demand = await fbRef
        .collection("conge")
        .where("userID", isEqualTo: userID)
        .where("status", isEqualTo: "accepted")
        .get();
    return demand.docs;
  }

  ///TODO GET THISD TO YOUR APP
  static getUserLeaveDemandedRefused(String userID) async {
    var leaves = await fbRef
        .collection("conge")
        .where("userID", isEqualTo: userID)
        .where("status", isEqualTo: "refused")
        .get();
    return leaves.docs;
  }

  ///TODO GET THISD TO YOUR APP
}
