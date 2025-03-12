class Equipement {
  final int? id;
  final int idPiece;
  final String code;
  final int quantite;
  final String nom;
  
  Equipement({
    this.id,
    required this.idPiece,
    required this.code,
    required this.quantite,
    required this.nom,
  });
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_piece': idPiece,
      'code': code,
      'quantite': quantite,
      'nom': nom,
    };
  }
  
  static Equipement fromMap(Map<String, dynamic> map) {
    return Equipement(
      id: map['id'],
      idPiece: map['id_piece'],
      code: map['code'],
      quantite: map['quantite'],
      nom: map['nom'],
    );
  }
}

