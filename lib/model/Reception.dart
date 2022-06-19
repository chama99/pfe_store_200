class Reception {
  final String? idrecp;
  final String? etat;
  final String? recp;
  final String? typ;
  final String? num;
  final List? tab;
  final DateTime? date;

  const Reception(
      {required this.idrecp,
      required this.etat,
      required this.recp,
      required this.typ,
      required this.num,
      required this.tab,
      required this.date});

  static Reception fromJson(dynamic json) => Reception(
      idrecp: json['IdRecp'],
      etat: json['etat'],
      recp: json['reception'],
      num: json['numrecp'],
      typ: json["type d'operation"],
      tab: json["ligne d'operation"],
      date: json['date prévue']);

  Map<String, dynamic> toJson() => {
        'IdRecp': idrecp,
        'etat': etat,
        'reception': recp,
        'numrecp': num,
        "type d'operation": typ,
        "ligne d'operation": tab,
        'date prévue': date
      };
}
