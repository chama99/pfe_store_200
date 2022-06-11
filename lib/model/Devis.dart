class Devis {
  String? Iddev;
  String? numdev;
  int? remise;
  List<String>? commande;
  DateTime? date;
  double? total;
  double? montant;
  String? client;
  String etat;

  Devis(
      {required this.Iddev,
      required this.numdev,
      required this.commande,
      required this.remise,
      required this.date,
      required this.total,
      required this.montant,
      required this.client,
      required this.etat});

  static Devis fromJson(dynamic json) => Devis(
      Iddev: json['idDev'],
      numdev: json['numdevis'],
      client: json['client'],
      commande: json['commande'],
      remise: json['remise'],
      total: json['total'],
      montant: json['mmontant'],
      date: json['date de devis'],
      etat: json['etat']);

  Map<String, dynamic> toJson() => {
        'idDevis': Iddev,
        'numdevis': numdev,
        'client': client,
        'commande': commande,
        'remise': remise,
        'total': total,
        'montant': montant,
        'date de devis': date,
        'etat': etat
      };
}
