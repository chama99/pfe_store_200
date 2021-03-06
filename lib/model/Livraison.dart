class Livraison {
  final String? idliv;
  final String? etat;
  final String? adr;
  final String? typ;
  final String? num;
  final List? tab;
  final DateTime? date;

  const Livraison(
      {required this.idliv,
      required this.etat,
      required this.adr,
      required this.typ,
      required this.num,
      required this.tab,
      required this.date});

  static Livraison fromJson(dynamic json) => Livraison(
      idliv: json['IdLiv'],
      etat: json['etat'],
      adr: json['Adresse de livraison'],
      num: json['numliv'],
      typ: json["type d'operation"],
      tab: json["ligne d'operation"],
      date: json['date prévue']);

  Map<String, dynamic> toJson() => {
        'IdLiv': idliv,
        'etat': etat,
        'Adresse de livraison': adr,
        'numliv': num,
        "type d'operation": typ,
        "ligne d'operation": tab,
        'date prévue': date
      };
}
