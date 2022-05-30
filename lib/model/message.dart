import '../pages/utils.dart';

class MessageField {
  static const String createdAt = 'createdAt';
}

class Message {
  // ignore: non_constant_identifier_names
  final String destID;
  final String urlAvatar;
  final String username;
  final String message;
  final String senderID;
  final DateTime createdAt;

  const Message({
    // ignore: non_constant_identifier_names
    required this.destID,
    required this.urlAvatar,
    required this.senderID,
    required this.username,
    required this.message,
    required this.createdAt,
  });

  static Message fromJson(dynamic json) => Message(
        senderID: json['senderID'],
        destID: json['destID'],
        urlAvatar: json['urlAvatar'],
        username: json['username'],
        message: json['message'],
        createdAt: Utils.toDateTime(json['createdAt'])!,
      );

  Map<String, dynamic> toJson() => {
        'destID': destID,
        'urlAvatar': urlAvatar,
        'senderID': senderID,
        'username': username,
        'message': message,
        'createdAt': Utils.fromDateTimeToJson(createdAt),
      };
}
