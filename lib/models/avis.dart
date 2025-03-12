class Avis {
  final int? id;
  final int idClient;
  final int idTechnicien;
  final int idIntervention;
  final int note;
  final String? commentaire;
  final DateTime dateCreation;
  
  Avis({
    this.id,
    required this.idClient,
    required this.idTechnicien,
    required this.idIntervention,
    required this.note,
    this.commentaire,
    required this.dateCreation,
  });
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_client': idClient,
      'id_technicien': idTechnicien,
      'id_intervention': idIntervention,
      'note': note,
      'commentaire': commentaire,
      'date_creation': dateCreation.toIso8601String(),
    };
  }
  
  static Avis fromMap(Map<String, dynamic> map) {
    return Avis(
      id: map['id'],
      idClient: map['id_client'],
      idTechnicien: map['id_technicien'],
      idIntervention: map['id_intervention'],
      note: map['note'],
      commentaire: map['commentaire'],
      dateCreation: DateTime.parse(map['date_creation']),
    );
  }
}

