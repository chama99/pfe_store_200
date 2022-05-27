import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chama_projet/model/message.dart';
import 'package:chama_projet/model/user.dart';

import '../model/user.dart';
import '../pages/utils.dart';

class FirebaseApi {
  static Stream<List<User>>? getUsers() {
    var x = FirebaseFirestore.instance
        .collection('users')
        .orderBy(UserField.lastMessageTime, descending: true)
        .snapshots()
        .transform(Utils.transformer(User.fromJson));
    //print(x);
    return x;
  }

  static Future uploadMessage(String idUser, String message) async {
    final refUsers = FirebaseFirestore.instance.collection("users");
    final refMessages =
        FirebaseFirestore.instance.collection('chats/$idUser/messages');
    var step = await refUsers.where('email', isEqualTo: idUser).get();
    var user = step.docs.map((doc) => doc.data()).toList().first;
    final newMessage = Message(
      idUser: user['email'],
      urlAvatar: user['image'],
      username: user['name'],
      message: message,
      createdAt: DateTime.now(),
    );
    await refMessages.add(newMessage.toJson());

    await refUsers
        .doc(idUser)
        .update({UserField.lastMessageTime: DateTime.now()});
  }

  static Stream<List<Message>> getMessages(String idUser) =>
      FirebaseFirestore.instance
          .collection('chats/$idUser/messages')
          .orderBy(MessageField.createdAt, descending: true)
          .snapshots()
          .transform(Utils.transformer(Message.fromJson));

  static Future addRandomUsers(List<User> users) async {
    final refUsers = FirebaseFirestore.instance.collection('users');

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

  static Future<dynamic>? createNewLeave(String userID, String leaveDays) {
    final refUsers = FirebaseFirestore.instance.collection("conge");
    refUsers.doc(userID).update({"leaveDays": leaveDays});
  }
}
