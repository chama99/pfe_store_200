import '../pages/utils.dart';

class UserField {
  static const String lastMessageTime = 'lastMessageTime';
}

class User {
  final String? idUser;
  final String? name;
  final String? urlAvatar;
  final DateTime? lastMessageTime;

  const User({
    required this.idUser,
    required this.name,
    required this.urlAvatar,
    required this.lastMessageTime,
  });

  User copyWith({
    String? idUser,
    String? name,
    String? urlAvatar,
    DateTime? lastMessageTime,
  }) =>
      User(
        idUser: idUser,
        name: name,
        urlAvatar: urlAvatar,
        lastMessageTime: lastMessageTime,
      );

  static User fromJson(dynamic json) => User(
        idUser: json['email'],
        name: json['name'],
        urlAvatar: json['image'],
        lastMessageTime: Utils.toDateTime(json['lastMessageTime']),
      );

  Map<String, dynamic> toJson() => {
        'idUser': idUser,
        'name': name,
        'image': urlAvatar,
        'lastMessageTime': Utils.fromDateTimeToJson(lastMessageTime!),
      };
}
