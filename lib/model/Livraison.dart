class Livraison {
  final String? idliv;
  final String? name;
  final String? adr;
  final String? tel;

  const Livraison({
    required this.idliv,
    required this.name,
    required this.adr,
    required this.tel,
  });

  static Livraison fromJson(dynamic json) => Livraison(
      idliv: json['IdLiv'],
      name: json['name'],
      adr: json['Adresse professionnelle'],
      tel: json['portable professionnel']);

  Map<String, dynamic> toJson() => {
        'IdLiv': idliv,
        'name': name,
        'Adresse professionnelle': adr,
        'portable professionnel': tel,
      };
}
