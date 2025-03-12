class Rapport {
  final int? id;
  final int idPanne;
  final int idTechnicien;
  final String description;
  final DateTime dateIntervention;
  final int duree;
  final double cout;
  final String statut;
  
  Rapport({
    this.id,
    required this.idPanne,
    required this.idTechnicien,
    required this.description,
    required this.dateIntervention,
    required this.duree,
    required this.cout,
    required this.statut,
  });
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_panne': idPanne,
      'id_technicien': idTechnicien,
      'description': description,
      'date_intervention': dateIntervention.toIso8601String(),
      'duree': duree,
      'cout': cout,
      'statut': statut,
    };
  }
  
  static Rapport fromMap(Map<String, dynamic> map) {
    return Rapport(
      id: map['id'],
      idPanne: map['id_panne'],
      idTechnicien: map['id_technicien'],
      description: map['description'],
      dateIntervention: DateTime.parse(map['date_intervention']),
      duree: map['duree'],
      cout: map['cout'],
      statut: map['statut'],
    );
  }
}

