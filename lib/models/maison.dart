class Maison {
  final int? id;
  final int idImmeuble;
  final String numero;
  final int nombrePieces;
  
  Maison({
    this.id,
    required this.idImmeuble,
    required this.numero,
    required this.nombrePieces,
  });
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_immeuble': idImmeuble,
      'numero': numero,
      'nombre_pieces': nombrePieces,
    };
  }
  
  static Maison fromMap(Map<String, dynamic> map) {
    return Maison(
      id: map['id'],
      idImmeuble: map['id_immeuble'],
      numero: map['numero'],
      nombrePieces: map['nombre_pieces'],
    );
  }
}

