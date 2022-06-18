class Article {
  final String? idart;
  final String? name;
  final String? urlAvatar;
  final String? cat;
  final String? code;
  final String? role;
  final String? type;
  final String? unite;
  final int? qt;
  final double? pa;
  final double? pv;
  final int? ref;
  final int? tax;
  const Article({
    required this.idart,
    required this.name,
    required this.urlAvatar,
    required this.cat,
    required this.code,
    required this.role,
    required this.type,
    required this.unite,
    required this.qt,
    required this.pa,
    required this.pv,
    required this.ref,
    required this.tax,
  });

  Article copyWith({
    String? idUser,
    String? name,
    String? urlAvatar,
    String? cat,
    String? code,
    String? role,
    String? type,
    String? unite,
    int? qt,
    double? pa,
    double? pv,
    int? ref,
    int? tax,
  }) =>
      Article(
        idart: idUser,
        name: name,
        urlAvatar: urlAvatar,
        cat: cat,
        code: code,
        role: role,
        type: type,
        unite: unite,
        qt: qt,
        pa: pa,
        pv: pv,
        ref: ref,
        tax: tax,
      );

  static Article fromJson(dynamic json) => Article(
        idart: json['IdUser'],
        name: json['name'],
        urlAvatar: json['image'],
        cat: json['cat'],
        code: json['code_a_barre'],
        role: json['role_art'],
        type: json['type_art'],
        unite: json['unite'],
        qt: json['Quantité'],
        pa: json['prix_dachat'],
        pv: json['prix_de_vente'],
        ref: json['reference_interne'],
        tax: json['taxes_a_la_vente'],
      );

  Map<String, dynamic> toJson() => {
        'idUser': idart,
        'name': name,
        'image': urlAvatar,
        'cat': cat,
        'code_a_barre': code,
        'role_art': role,
        'type_art': type,
        'unite': unite,
        'Quantité': qt,
        'prix_dachat': pa,
        'prix_de_vente': pv,
        'reference_interne': ref,
        'taxes_a_la_vente': tax,
      };
}
