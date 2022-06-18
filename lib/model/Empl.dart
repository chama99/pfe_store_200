class Empl {
  final String? idemp;
  final String? name;
  final String? adr;
  final String? tel;

  const Empl({
    required this.idemp,
    required this.name,
    required this.adr,
    required this.tel,
  });

  Empl copyWith({
    String? idemp,
    String? name,
    String? urlAvatar,
  }) =>
      Empl(
        idemp: idemp,
        name: name,
        adr: adr,
        tel: tel,
      );

  static Empl fromJson(dynamic json) => Empl(
      idemp: json['IdEmp'],
      name: json['name'],
      adr: json['Adresse professionnelle'],
      tel: json['portable professionnel']);

  Map<String, dynamic> toJson() => {
        'IdEmp': idemp,
        'name': name,
        'Adresse professionnelle': adr,
        'portable professionnel': tel,
      };
}
