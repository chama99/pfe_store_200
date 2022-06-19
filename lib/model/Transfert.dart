class Transfert {
  final String? idtran;
  final String? etat;
  final String? trans;
  final String? typ;
  final String? num;
  final List? tab;
  final DateTime? date;

  const Transfert(
      {required this.idtran,
      required this.etat,
      required this.trans,
      required this.typ,
      required this.num,
      required this.tab,
      required this.date});

  static Transfert fromJson(dynamic json) => Transfert(
      idtran: json['IdTran'],
      etat: json['etat'],
      trans: json['transfert à'],
      num: json['numtran'],
      typ: json["type d'operation"],
      tab: json["ligne d'operation"],
      date: json['date prévue']);

  Map<String, dynamic> toJson() => {
        'IdTran': idtran,
        'etat': etat,
        'transfert à': trans,
        'numtran': num,
        "type d'operation": typ,
        "ligne d'operation": tab,
        'date prévue': date
      };
}
