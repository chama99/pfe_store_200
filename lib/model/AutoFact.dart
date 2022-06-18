class AutoFacture {
  String? Idfact;
  String? numfact;
  String? numdev;
  int? remise;
  List<String>? commande;
  DateTime? date;
  double? total;
  double? montant;
  String? client;
  String etat;

  AutoFacture(
      {required this.Idfact,
      required this.numfact,
      required this.numdev,
      required this.commande,
      required this.remise,
      required this.date,
      required this.total,
      required this.montant,
      required this.client,
      required this.etat});

  static AutoFacture fromJson(dynamic json) => AutoFacture(
      Idfact: json['IdFact'],
      numfact: json['numfact'],
      numdev: json['numdevis'],
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
        'numdevis': numdev,
        'client': client,
        'commande': commande,
        'remise': remise,
        'total': total,
        'montant': montant,
        'date de facturation': date,
        'etat': etat
      };
}
