class Immeuble {
  final int? id;
  final String nom;
  final String adresse;
  final String type;
  
  Immeuble({
    this.id,
    required this.nom,
    required this.adresse,
    required this.type,
  });
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'adresse': adresse,
      'type': type,
    };
  }
  
  static Immeuble fromMap(Map<String, dynamic> map) {
    return Immeuble(
      id: map['id'],
      nom: map['nom'],
      adresse: map['adresse'],
      type: map['type'],
    );
  }
}

