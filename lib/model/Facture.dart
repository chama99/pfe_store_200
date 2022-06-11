class Facture {
  String? Idfact;
  String? numfact;
  int? remise;
  List<String>? commande;
  DateTime? date;
  double? total;
  double? montant;
  String? client;
  String etat;

  Facture(
      {required this.Idfact,
      required this.numfact,
      required this.commande,
      required this.remise,
      required this.date,
      required this.total,
      required this.montant,
      required this.client,
      required this.etat});

  static Facture fromJson(dynamic json) => Facture(
      Idfact: json['IdFact'],
      numfact: json['numfact'],
      client: json['client'],
      commande: json['ligne facture'],
      remise: json['remise'],
      total: json['total'],
      montant: json['mmontant'],
      date: json['date de facturation'],
      etat: json['etat']);

  Map<String, dynamic> toJson() => {
        'IdFact': Idfact,
        'numfact': numfact,
        'client': client,
        'commande': commande,
        'remise': remise,
        'total': total,
        'montant': montant,
        'date de facturation': date,
        'etat': etat
      };
}
