class Client {
  final String? id;
  final String? name;
  final String? adr;
  final String? etq;
  final String? tel;
  final String? email;

  const Client({
    required this.id,
    required this.name,
    required this.adr,
    required this.tel,
    required this.etq,
    required this.email,
  });

  static Client fromJson(dynamic json) => Client(
      id: json['IdEmp'],
      email: json['email'],
      etq: json['Etiquette'],
      name: json['name'],
      adr: json['Adresse professionnelle'],
      tel: json['portable professionnel']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'Etiquette': etq,
        'name': name,
        'Adresse professionnelle': adr,
        'portable professionnel': tel,
      };
}
