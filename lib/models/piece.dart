class Piece {
  final int? id;
  final int idMaison;
  final String nom;
  
  Piece({
    this.id,
    required this.idMaison,
    required this.nom,
  });
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_maison': idMaison,
      'nom': nom,
    };
  }
  
  static Piece fromMap(Map<String, dynamic> map) {
    return Piece(
      id: map['id'],
      idMaison: map['id_maison'],
      nom: map['nom'],
    );
  }
}

