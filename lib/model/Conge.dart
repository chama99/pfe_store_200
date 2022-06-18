class Conge {
  final String? id;
  final String? name;
  final String? des;
  final String? dur;
  final String? st;
  final String? typ;
  final DateTime? date;

  const Conge(
      {required this.id,
      required this.name,
      required this.des,
      required this.dur,
      required this.st,
      required this.typ,
      required this.date});

  static Conge fromJson(dynamic json) => Conge(
        id: json['id'],
        des: json['description'],
        dur: json['duration'],
        name: json['username'],
        st: json['status'],
        typ: json['leaveType'],
        date: json['beginDateOfTheHoliday'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'description': des,
        'duration': dur,
        'username': name,
        'leaveType': typ,
        'status': st,
        'beginDateOfTheHoliday': date
      };
}
